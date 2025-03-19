(* Donne les infos sur un dipole 
 * F représente un fil *)
type dipole_t = E_d | I_d | C | L | R | F 
type dipole = dipole_t * int

let parse_dipoles dipoles_s = Array.of_list (List.map (
    fun d -> 
        if String.length d <= 1 then failwith "nom de dipole incorrect";
        let t = d.[0] in
        let id = int_of_string (String.sub d 1 (String.length d - 1)) in
        if t = 'E' then (E_d, id)
        else if t = 'I' then (I_d, id)
        else if t = 'C' then (C, id)
        else if t = 'L' then (L, id)
        else if t = 'R' then (R, id)
        else if t = 'F' then (F, id)
        else
            failwith "nom de dipôle incorrect"
) (Array.to_list dipoles_s))

(* Les informations d'un circuit depuie un fichier *)
let parse_circuit_file file = 
    let ic = open_in file in

    (* Nombre de sommets *)
    let v = int_of_string (input_line ic) in
    
    let dipoles = Array.of_list (
            List.filter (
                fun s -> s <> ""
            ) (String.split_on_char ' ' (String.trim (input_line ic)))
    ) in

    let mat_incidence = Array.init v (fun _ ->
        Array.of_list (
            List.filter_map (
                fun s -> if s = "" then None else Some (int_of_string s)
            ) (String.split_on_char ' ' (String.trim (input_line ic)))
        )
    ) in
    (parse_dipoles dipoles), mat_incidence, v

(* Renvoie une liste des arêtes et sa longueur, sous la forme de couples de 
 * sommets, à partir d'une matrice d'incidence. *)
let list_edges_from_i i_mat = if 
    Array.length i_mat = 0 || Array.length (i_mat.(0)) = 0 then [], -1 
else
    let v = Array.length i_mat in
    let e = Array.length (i_mat.(0)) in
    let res = ref [] in
    for i = 0 to e - 1 do
        let a = ref (0, 0) in
        for j = 0 to v - 1 do
            if i_mat.(j).(i) = 1 then 
                let (x, _) = !a in
                a := (x, j)
            else if i_mat.(j).(i) = -1 then
                let (_, x) = !a in
                a := (j, x)
        done;
        res := !a::!res
    done;
    (* On renvoie dans le même ordre que dans le fichier *)
    List.rev (!res), e

(* Implémentation d'une structure union-find *)
(* find(i) revient à récupérer l'élément i-ième de la liste *)
let union (r, n) i j = 
    let old = r.(j) in
    for k = 0 to n - 1 do
        if r.(k) = old then 
            r.(k) <- r.(i)
    done

(* Implémentation de l'algorithme de Kruskal *)
(* Suppose un graphe connexe *)
let inner_tree edges e v =
    let r = Array.init e (fun i -> i) in
    let rec aux edges c acc = 
    match edges with
    (* On renverse pour que les arêtes apparaissent dans le même ordre que celui
     de edges : utile plus tard. *)
    | [] -> List.rev acc
    | _ when c >= v - 1 -> List.rev acc
    | (v1, v2)::t -> if r.(v1) = r.(v2) then aux t c acc else
        let _ = union (r, e) v1 v2 in
        aux t (c + 1) ((v1, v2)::acc)
    in aux edges 0 []

(* Prend un arbre sous forme d'une liste d'arêtes et une arête et renvoie l'unique
 cycle formé *)
(* Effectue un parcours en largeur de T à partir de a, jusqu'à tomber sur b. 
   Alors le chemin de a à b est le cycle unique *)  
let get_unique_cycle t (a, b) = 
    let q = Queue.create () in
    (* Ne devrait pas soulever d'erreur, puisque l'on doit tomber sur b *)
    let rec aux () = match Queue.take q with
    | (v, path) when v = b -> path
    | (v, path) ->
            let accessible_vertices = List.filter_map (
                fun (x, y) -> 
                    if x = v || y = v then 
                        Some (x, y)
                    else None) t in
            List.iter (
                fun (x, y) -> 
                    if y = v then (Queue.add (x, (x, y)::path) q)
                    else Queue.add(y, (x, y)::path) q) accessible_vertices;
            aux ()
    in Queue.add (a, [(a, b)]) q; aux () 

(* Le graphe g et l'arbre t sont sous la forme d'une liste de sommets dans le 
 même ordre. *) 
let get_all_cycles g t = 
    let rec aux g tree acc = match g, tree with
    | [], _ -> acc
    | hg::tg, ht::tt when hg = ht -> aux tg tt acc
    | h::tail, _ -> aux tail tree ((get_unique_cycle t h)::acc)
    in aux g t []

let get_cycle_basis edges e v =
    let t = inner_tree edges e v in
    let cycles = get_all_cycles edges t in
    let c_mat = Array.make_matrix (e - v + 1) e 0 in

    (* parcours de la liste des cycles *)
    let rec aux cycles i = match cycles with
    | [] -> ()
    | ((first, second)::c)::tail -> 
            let rec parse_cycle c' last = match c' with
            | (a, b)::tail -> 
                    let j = Option.get (List.find_index (fun x -> (a, b) = x) edges) in
                    c_mat.(i).(j) <- if a = last then 1 else -1;
                    parse_cycle tail b
            | [] -> ()
            in parse_cycle ((first, second)::c) first; aux tail (i+1)
    | _ -> failwith "inateignable"
    in aux cycles 0;

    c_mat
            
(* Pour représenter une équa diff sous forme d'arbre *)
type inconnue = I of int | U of int
type scal = R of int | C of int | L of int | Inv of scal
type term = 
| Zero
| E of int
| IConst of int
| Inc of inconnue
| Add of term list
(* Dérivée d'ordre n, n peut être négatif pour intégrer 
 Si n = 0, cela revient à ne rien faire *)
| Der of int * term
(* Multiplication par un scalaire. *)
| Mul of scal * term
| Neg of term

(* Une équation du circuit :
 * - Un tableau de toutes les inconnues mises en jeu
 * - Une fonction prenant une inconnue à substituer et la liste des substitution
 * des autres inconnues en jeu, pour renvoyer la substitution *)
type eq = (inconnue list) * (inconnue -> (term array) -> term)
(* Une substitution trouvée *)
type substitution = inconnue * term

(* Gauche et droite du signe égal *)
type eq_diff = term * term

(* Renvoie les équations imposées par les dipôles du circuit *)
let get_dipoles_equations dipoles = 
    let n = Array.length dipoles in
    let res = ref [] in
    for i = 0 to n - 1 do
        let inc = [I i; U i] in
        let check_arr arr = 
            if Array.length (arr) <> 1 then failwith "nombre d'inconnues incorrect"
        in
        let invalid_inc () = failwith "inconnnue invalide" in 
        let new_eq = match dipoles.(i) with
        | (E_d, e) -> 
                let eq (u:inconnue) arr = 
                    if Array.length (arr) > 0 then failwith "nombre d'inconnues incorrect";
                    match u with 
                    | U x when x = i -> E e
                    | _ -> invalid_inc ()
                in ([U i], eq)
        | (I_d, i_index) ->
                let eq (u:inconnue) arr = 
                    if Array.length (arr) > 0 then failwith "nombre d'inconnues incorrect";
                    match u with 
                    | I x when x = i -> IConst i_index
                    | _ -> invalid_inc ()
                in ([I i], eq)
        | (F, _) -> (* u = 0, on ne peut rien dire sur i *)
                let eq (u:inconnue) arr = 
                    if Array.length (arr) > 0 then failwith "nombre d'inconnues incorrect";
                    match u with
                    | U x when x = i -> Zero
                    | _ -> invalid_inc ()
                in ([U i], eq)
        | (C, c) -> (* i = Cdu/dt *)
                let eq (u:inconnue) arr =
                    check_arr arr;
                    match u with
                    | I x when x = i -> Mul (C c, Der (1, arr.(0)))
                    | U x when x = i -> Mul (Inv (C c), Der (-1, arr.(0)))
                    | _ -> invalid_inc ()
                in (inc, eq)
        | (L, l) -> (* u = Ldi/dt *)
                let eq (u:inconnue) arr =
                    check_arr arr;
                    match u with
                    | I x when x = i -> Mul (Inv (L l), Der (-1, arr.(0)))
                    | U x when x = i -> Mul (L l, Der (1, arr.(0)))
                    | _ -> invalid_inc ()
                in (inc, eq)
        | (R, r) -> (* u = Ri *)
                let eq (u:inconnue) arr =
                    check_arr arr;
                    match u with
                    | I x when x = i -> Mul (Inv (R r), arr.(0))
                    | U x when x = i -> Mul (R r, arr.(0))
                    | _ -> invalid_inc ()
                in (inc, eq)
        in res := new_eq::(!res)
    done;
    !res

(* Matrice des cycles fondamentaux supposée non vide *) 
let get_c_mat_eq c_mat = 
    let e = Array.length c_mat.(0) in
    let res = ref [] in
    for i = 0 to Array.length c_mat - 1 do
        let inc = ref [] in
        for j = 0 to e - 1 do
            if c_mat.(i).(j) = 1 || c_mat.(i).(j) = -1 then
                inc := (U j)::!inc
        done;
        let eq u arr = match u with (U j) ->
            if Array.length arr <> List.length !inc - 1 then 
                failwith "nombre d'inconnues incorrect";
            let sign = c_mat.(i).(j) in 
            Add (List.mapi (
                fun index t ->
                    let u_i = match List.nth !inc index with 
                    | (U u_i) -> u_i 
                    | _ -> failwith "inateignable" in
                    if sign * c_mat.(i).(u_i) = 1 then Neg (t)
                    else t
            ) (Array.to_list arr))
        | _ -> failwith "inconnue incorrecte"
        in res := (!inc, eq)::!res
    done;
    !res

(* Matrice d'incidence supposée non vide *) 
let get_i_mat_eq i_mat = 
    let e = Array.length i_mat.(0) in
    let res = ref [] in
    (*  *)
    for i = 0 to Array.length i_mat - 2 do
        let inc = ref [] in
        for j = 0 to e - 1 do
            if i_mat.(i).(j) = 1 || i_mat.(i).(j) = -1 then
                inc := (I j)::!inc
        done;
        let eq u arr = match u with (I j) ->
            if Array.length arr <> List.length !inc - 1 then 
                failwith "nombre d'inconnues incorrect";
            let sign = i_mat.(i).(j) in 
            Add (List.mapi (
                fun index t ->
                    let i_i = match List.nth !inc index with 
                    | (I i_i) -> i_i 
                    | _ -> failwith "inateignable" in
                    if sign * i_mat.(i).(i_i) = 1 then Neg (t)
                    else t
            ) (Array.to_list arr))
        | _ -> failwith "inconnue incorrecte"
        in res := (!inc, eq)::!res
    done;
    !res

let get_eqs file = 
    let dipoles, i_mat, v = parse_circuit_file file in
    let edges, e = list_edges_from_i i_mat in
    let c_mat = get_cycle_basis edges e v in
    
    ((get_dipoles_equations dipoles) @ (get_c_mat_eq c_mat)) @ (get_i_mat_eq i_mat) 

(* Vérifie si b contient tous les éléments de a sauf un élément, et renvoie cet élément *)
let contains_all_except_one a b = 
    let res, _ = List.fold_left (
        fun acc x -> match acc with
        | None, true -> if List.mem x b then None, true else Some x, true
        | Some y, true -> if List.mem x b then Some y, true else None, false
        | _, false -> None, false
    ) (None, true) a
    in res

let contains_all a b = List.for_all (fun x -> List.mem x b) a

let and_list a b = List.filter (fun (x, _) -> List.mem x b) a

exception EndSolve of eq_diff

let rec aux known subs (eqs : eq list) = 
        let rec find_sub (eqs : eq list) acc = match eqs with
        | (incs, eq)::[] -> begin
                let l = List.combine known subs in
                let l = and_list l incs in
                let curr_known, curr_subs = List.split l in
                match curr_known, curr_subs with
                | inc::_, sub::curr_subs -> 
                        raise (EndSolve (
                            sub, 
                            eq inc (Array.of_list (curr_subs))
                        ))
                | _ -> failwith "inatteignable"
        end
        | (inc, eq)::t -> begin
                match contains_all_except_one inc known with
                | None -> 
                        find_sub t ((inc, eq)::acc)
                | Some v -> 
                        let l = List.combine known subs in
                        let l = and_list l inc in
                        let _, curr_subs = List.split l in
                        v, eq v (Array.of_list (curr_subs)), (t @ acc)
        end
        | _ -> failwith "inatteignable ?"
        in let new_known, new_sub, eqs = find_sub eqs [] in
        aux (new_known::known) (new_sub::subs) eqs


let solve u eqs = 
        try aux [u] [Inc u] eqs with EndSolve eq -> eq

let solve_file u file = solve u (get_eqs file)


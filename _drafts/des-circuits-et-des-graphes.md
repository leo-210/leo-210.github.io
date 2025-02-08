---
layout: post
title: Des circuits, Kirchhoff et des graphes
description: Comment déterminer certaines lois d'un circuit avec de la théorie des graphes.
---

# Des circuits et des graphes

Dans le 
[post précédent]({% link _posts/2025-02-06-algorithme-pour-resoudre-un-circuit.md %}),
j'ai présenté un algorithme qui permettrait d'obtenir l'équation différentielle
d'un circuit en supposant de posséder un système de $$n$$ équations
indépendantes à $$n$$ inconnues.

Ici, on va s'intéresser aux équations issues des lois des mailles et des nœuds,
et comment les obtenir en s'assurant que les équations obtenues soient
linéairement indépendantes, à l'aide de théorie des graphes et un peu d'algèbre
linéaire.


# Des graphes orientés pour représenter un circuit

Entre chaque dipôle, on place un nœud, et on relie tous les nœuds avec des
arrêtes, on obtient un graphe, qui respecte ces conditions 

1. Il doit connexe, à savoir pour toute paire de nœud, il existe un chemin 
   les reliant.
2. Il ne doit pas posséder de boucle : un cable dont les deux bouts sont
   connectés au même nœud n'est pas utile ; autant l'écarter.
3. Comme présenté dans {% cite Vrbik2022 %}, si on enlève une arrête quelconque
   du graphe, le graphe doit rester connexe. S'il existait une telle arrête,
   alors le courant y serait nul, autant traiter les deux parties du circuit
   séparément.

Cette dernière condition est équivalente à dire que toute arrête doit appartenir
à au moins un cycle : la 3e condition est vérifiée ssi pour toute arrête il existe
deux chemins différents pour relier ses extrémités, cela traduit l'existence
d'un cycle.

De plus, pour résoudre un circuit, on se doit de l'<< orienter >>, c'est-à-dire
décider arbitrairement du sens des intensités de chacune des branches. De la 
même manière, on oriente chaque arrête du graphe, pour obtenir un graphe
orienté.

Par la suite, nous noterons $$G$$ un graphe à $$n$$ sommets et $$p$$ arrêtes,
représentant un circuit, qui respecte donc toutes les conditions ci-dessus.


## Des propriétés autour de la connexité

### Nombre d'arrêtes

Puisque $$G$$ est connexe, $$p \ge n - 1$$. Mais dans le cas d'égalité $$p = n -
1$$, le graphe ne respecterait pas la 3e condition, puisque qu'en enlevant
n'importe quelle arrête, on obtiendrai un graphe $$G'$$ tel que 
$$p' = n' - 2 < n'-1$$, contredisant la connexité supposée de $$G'$$. Ainsi, il
est nécessaire que $$p \ge n$$.

### Forte connexité

Nos trois conditions et l'orientation du graphe entraînent presque la forte 
connexité, mais puisque l'orientation du circuit est arbitraire, elle n'est pas
toujours acquise. En guise de contre-exemple, il suffit de prendre un graphe à
deux nœuds $$a$$ et $$b$$, et deux arrêtes. Si les deux arrêtes partent de $$a$$
pour arriver en $$b$$, alors il existe un chemin de $$a$$ vers $$b$$, mais pas
de $$b$$ vers $$a$$.

Cependant, on pourra toujours choisir une orientation telle que le graphe 
représentant le circuit soit fortement connexe. Dans le contre-exemple
ci-dessus, si on prend un arrête allant de $$a$$ vers $$b$$, et l'autre de $$b$$
vers $$a$$, alors le graphe devient fortement connexe.


> **Preuve :** Notons $$G'$$ le graphe non-orienté correspondant à $$G$$. On va
> reconstruire $$G$$ algorithmiquement en choisissant le sens des arrêtes de 
> telle manière à ce qu'il soit fortement connexe.
> 
> On note $$S_k$$ l'ensemble des sommets que l'on a connecté. Si la suite 
> $$(n - \#S_k)$$ est strictement décroissante, et si à chaque étape, $$G$$ est
> fortement connexe, alors on a trouvé une bonne orientation de $$G$$ (quand
> $$\#S - n = 0$$ alors on a fini).
> 
> **Initialisation.** Prenons n'importe quel cycle de $$G'$$, par la troisième
> condition, il en existe au moins un. Ajoutons chacun des $$m$$ sommets à $$S$$ 
> et relions-les selon leur ordre dans le cycle ($$v_0 \to v_1 \to \ldots \to
> v_m \to v_0 $$). Le graphe est pour l'instant fortement connexe, et $$\#S_0 \ge 
> 2$$.
> 
> **Hérédité.** Supposons que $$2 \le \#S_k \le n - 1$$, et $$S_k$$ fortement connexe. 
> Prenons alors $$v \in G' \smallsetminus S$$. Il existe un chemin reliant $$v$$ à
> $$v_1 \in S_k$$, puisque $$G'$$ est connexe. Prenons une arrête $$x$$ de ce chemin 
> dont l'une des extrémité est $$v_0$$, notons l'autre $$v' \notin S$$ (peut-être 
> égale à $$v$$). Par la troisième condition, $$x$$ appartient à un cycle $$C$$,
> dont $$v_1$$ fait partie. Définissons $$S_{k+1} = S_k \cup C$$. En faisant le << 
> tour >> du cycle, on tombe sur des sommets $$v_i$$ de $$S$$, en commençant par 
> $$v_0$$. Entre deux de ces sommets $$v_i, v_{i+1}$$, on trouve un cycle de
> $$G'$$, car il existe un chemin les reliant dans $$S_k$$ par hypothèse, et un 
> autre dans $$C$$. Pour relier les sommets de $$C$$ entre $$v_i$$ et $$v_{i+1}$$,
> on se réfère au sens qui relie ces sommets dans $$S_k$$, et on prend le sens
> inverse : ainsi on crée un cycle inversé. En effectuant cette démarche entre
> tous les sommets $$v_i$$, on s'assure que les sommets de $$S_{k+1}$$ peuvent
> être reliés de manière à créer un graphe fortement connexe. Et enfin, $$v \in C
> \subset S_{k+1}$$, mais $$v \notin S_k$$, dont $$\#S_{k+1}\ge\#S_k$$.
> $$\square$$


Remarque : Ce résultat se vérifie physiquement, puisque dans un circuit le
courant se déplace bien tel qu'il traverse tous les nœuds et en formant un
<< grand cycle >>.

Note : je ne sais pas si ce résultat sera utile par la suite, mais il est
intéressant.

#### Exemple

[Insérer un exemple]


## Matrice d'incidence

On définit la matrice de taille $$n\times p$$
d'incidence sommets-arcs $$A(G)$$, dont le coefficient $$i, j$$ est égal à :
- -1 si l'arc $$x_j$$ sort du sommet $$v_i$$
- 1 si l'arc $$x_j$$ entre dans le sommet $$v_i$$
- 0 sinon

[Insérer un exemple]


# Lois de Kirchhof

Prenons un graphe $$G$$ représentant un circuit, avec $$n$$ sommets et $$p$$
arrêtes. 

À l'aide de la matrice $$A(G)$$ définie au-dessus, on peut tirer les lois des
nœuds, et avec un peu plus de travail les lois des mailles.


## Loi des nœuds

Notons $$i_1, \ldots, i_p$$ les $$p$$ intensités du circuit, correspondant aux 
$$p$$ arrêtes de $$G$$.

Le produit de $$A(G)$$ par la matrice colonne des intensités 
$$\begin{pmatrix}i_1 \\ \vdots \\ i_p\end{pmatrix}$$
nous donne les lois 
des nœuds en chacun des sommets. En effet, chaque ligne $$i$$ de la matrice 
résultante est égale à $$\displaystyle\sum_{j=0}^p (A(G))_{i,j} i_j$$. Or chaque
ligne $$i$$ de $$A(G)$$ donne les intensités entrantes et sortantes du sommet
$$v_i$$. On retrouve donc bien notre loi des mailles en affirmant que l'expression
trouvée doit être nulle, à savoir :

$$\sum i_{\text{entrant}} - \sum i_{\text{sortant}} = 0$$

Mais les $$p$$ équations trouvées sont linéairement dépendantes : il suffit de
faire la somme des lignes de 1 à $$n-1$$ pour obtenir l'opposé de la ligne $$n$$
(la somme de toutes les lignes est nulle).

Preuve : à faire (piste : la somme de toutes les lignes est nulle)

On peut démontrer que la matrice $$A(G)$$ est de rang $$n-1$$, et on en déduit
alors qu'il suffit d'écarter n'importe quelle ligne pour obtenir un système
d'équations linéairement indépendant, et donc les lois des nœuds qu'on
recherche.

Preuve : Probablement par un pivot de Gauss, {% cite Vrbik2022 %}
donne une piste (paragraphe 2.2).


# Références

{% bibliography --cited_in_order %}

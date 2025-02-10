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
arêtes, on obtient un graphe, qui respecte ces conditions 

1. Il doit connexe, à savoir pour toute paire de nœud, il existe un chemin 
   les reliant.
2. Il ne doit pas posséder de boucle : un cable dont les deux bouts sont
   connectés au même nœud n'est pas utile ; autant l'écarter.
3. Comme présenté dans {% cite Vrbik2022 %}, si on enlève une arête quelconque
   du graphe, le graphe doit rester connexe. S'il existait une telle arête,
   alors le courant y serait nul, autant traiter les deux parties du circuit
   séparément.

Cette dernière condition est équivalente à dire que toute arête doit appartenir
à au moins un cycle : la 3e condition est vérifiée ssi pour toute arête il existe
deux chemins différents pour relier ses extrémités, cela traduit l'existence
d'un cycle.

De plus, pour résoudre un circuit, on se doit de l'<< orienter >>, c'est-à-dire
décider arbitrairement du sens des intensités de chacune des branches. De la 
même manière, on oriente chaque arête du graphe, pour obtenir un graphe
orienté.

Par la suite, nous noterons $$G$$ un graphe à $$n$$ sommets et $$p$$ arêtes,
représentant un circuit, qui respecte donc toutes les conditions ci-dessus.

Aussi, je confondrai les notions de graphe orienté et non-orienté : si j'utilise
une notion s'appliquant à un graphe orienté, alors je parle de $$G$$, au
contraire si je parle d'un graphe non-orienté, je parle du graphe non-orienté
correspondant à $$G$$.


## Des propriétés autour de la connexité

### Nombre d'arêtes

Puisque $$G$$ est connexe, $$p \ge n - 1$$. Mais dans le cas d'égalité $$p = n -
1$$, le graphe ne respecterait pas la 3e condition, puisque qu'en enlevant
n'importe quelle arête, on obtiendrai un graphe $$G'$$ tel que 
$$p' = n' - 2 < n'-1$$, contredisant la connexité supposée de $$G'$$. Ainsi, il
est nécessaire que $$p \ge n$$.

### Forte connexité

Nos trois conditions et l'orientation du graphe entraînent presque la forte 
connexité, mais puisque l'orientation du circuit est arbitraire, elle n'est pas
toujours acquise. En guise de contre-exemple, il suffit de prendre un graphe à
deux nœuds $$a$$ et $$b$$, et deux arêtes. Si les deux arêtes partent de $$a$$
pour arriver en $$b$$, alors il existe un chemin de $$a$$ vers $$b$$, mais pas
de $$b$$ vers $$a$$.

Cependant, on pourra toujours choisir une orientation telle que le graphe 
représentant le circuit soit fortement connexe. Dans le contre-exemple
ci-dessus, si on prend un arête allant de $$a$$ vers $$b$$, et l'autre de $$b$$
vers $$a$$, alors le graphe devient fortement connexe.


> **Preuve :** Notons $$G'$$ le graphe non-orienté correspondant à $$G$$. On va
> reconstruire $$G$$ algorithmiquement en choisissant le sens des arêtes de 
> telle manière à ce qu'il soit fortement connexe.
> 
> On note $$S_k$$ l'ensemble des sommets que l'on a connecté. Si la suite 
> $$(n - \#S_k)_{k\in\mathbb{N}}$$ est strictement décroissante, et si à chaque
> étape, $$G$$ est fortement connexe, alors on a trouvé une bonne orientation de 
> $$G$$ (quand $$\#S - n = 0$$ alors on a fini).
> 
> **Initialisation.** Prenons n'importe quel cycle de $$G'$$, par la troisième
> condition, il en existe au moins un. Ajoutons chacun des $$m$$ sommets à $$S$$ 
> et relions-les selon leur ordre dans le cycle ($$v_0 \to v_1 \to \ldots \to
> v_m \to v_0 $$). Le graphe est pour l'instant fortement connexe, et $$\#S_0 \ge 
> 2$$.
> 
> **Hérédité.** Supposons que $$2 \le \#S_k \le n - 1$$, et $$S_k$$ fortement connexe. 
> Prenons alors $$v \in G' \smallsetminus S$$. Il existe un chemin reliant $$v$$ à
> $$v_1 \in S_k$$, puisque $$G'$$ est connexe. Prenons une arête $$x$$ de ce chemin 
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
{: .proof }


> **Remarque :** Ce résultat se vérifie physiquement, puisque dans un circuit le
> courant se déplace bien tel qu'il traverse tous les nœuds et en formant un
> << grand cycle >>.
{: .remark }

> **Note :** Je ne sais pas si ces résultats seront utile par la suite, mais ils
> sont intéressants.
{: .note }

#### Exemple

[Insérer un exemple]


## Matrice d'incidence

On définit la matrice $$B$$ de taille $$n\times p$$
d'incidence sommets-arcs $$A(G)$$, dont le coefficient $$i, j$$ est égal à :
- -1 si l'arc $$x_j$$ sort du sommet $$v_i$$
- 1 si l'arc $$x_j$$ entre dans le sommet $$v_i$$
- 0 sinon

[Insérer un exemple]


# Lois de Kirchhof

Prenons un graphe $$G$$ représentant un circuit, avec $$n$$ sommets et $$p$$
arêtes. 

À l'aide de la matrice d'incidence $$B$$ définie au-dessus, on peut tirer les 
lois des nœuds, et avec un peu plus de travail les lois des mailles.


## Loi des nœuds

Notons $$i_1, \ldots, i_p$$ les $$p$$ intensités du circuit, correspondant aux 
$$p$$ arêtes de $$G$$.

Le produit de $$B$$ par le vecteur des intensités de chaque branche du circuit
$$I = \begin{pmatrix}i_1 \\ \vdots \\ i_p\end{pmatrix}$$
nous donne les lois des nœuds en chacun des sommets. En effet, chaque ligne 
$$i$$ de la matrice résultante est égale à $$\displaystyle\sum_{j=0}^p 
(B)_{i,j} i_j$$. Or chaque ligne $$i$$ de $$B$$ donne les intensités 
entrantes et sortantes du sommet $$v_i$$. On retrouve donc bien nos lois des
nœuds en affirmant que l'expression trouvée doit être nulle, à savoir :

$$\sum i_{\text{entrant}} - \sum i_{\text{sortant}} = 0$$

La loi des noeuds revient donc à : $$BI = 0$$.

Mais les $$n$$ équations trouvées sont linéairement dépendantes : il suffit de
faire la somme des lignes de 1 à $$n-1$$ pour obtenir l'opposé de la ligne $$n$$
(la somme de toutes les lignes est nulle).

> **Preuve :** Si on somme toutes les lignes, on obtient la ligne nulle : en effet
> sur chacune des colonnes, par construction, il y a exactement un << 1 >> et un
> << -1 >>. À partir de là, on peux en déduire aisément que la somme des toutes
> les lignes sauf une est égale à cette dernière ligne.
> $$\square$$
{: .proof }

Au chapitre 2 de {% cite Bapat2014 %}, il est démontré que le rang de la matrice
d'adjacence d'un graphe connecté est exactement $$n - 1$$, pour $$n$$ nœuds.
Par conséquent, en utilisant le résultat du dessus, on sait que toutes les
lignes de $$B$$ sont linéairement indépendantes, sauf une que l'on peut choisir
arbitrairement. On a ainsi nos $$n-1$$ lois des nœuds à partir du graphe.

[insérer un exemple]


## Loi des mailles

Pour les lois des mailles, ce n'est pas aussi simple que les lois des nœuds,
car il ne suffit pas toujours d'enlever une seule loi des mailles pour avoir un
système linéairement indépendant.


### Cycles fondamentaux de $$G$$

Soit $$T$$ un arbre couvrant de $$G$$, et $$T^c$$ son arbre complémentaire dans
$$G$$.

En tant qu'arbre à $$n$$ sommets, un arbre couvrant possède $$n-1$$ arêtes. Donc
$$T^c$$ possède $$p - n + 1$$ arêtes par construction.

Pour toute arête $$e_i \in V(T^c)$$, $$T \cup \{e_i\}$$ possède exactement un 
cycle noté $$C_i$$. On appelle ces $$p-n+1$$ cycles << cycles fondamentaux de
$$G$$ >> (bien entendu par rapport à $$T$$).

{% cite Bapat2014 %} démontre que les cycles fondamentaux d'un graphe connecté $$G$$
forment une base des cycles de $$G$$.

Ainsi les lois des mailles associées à ces cycles fondamentaux sont linéairement
indépendantes, et il n'y a pas de système de lois des mailles avec plus
d'équations qui soient linéairement indépendantes. Il nous suffit donc de
trouver un moyen efficace pour exprimer toutes ces lois des mailles.


### Matrice des cycles fondamentaux de $$G$$

Soit $$C_i$$ un cycle fondamental de $$G$$ formé par l'union de $$T$$ et
$$e_i \in T^c$$.

On nomme << vecteur d'incidence >> de $$C_i$$ le vecteur de $$p$$ éléments tels
que le $$k$$-ième soit égal à :
- 1 si $$e_k \in C_i$$ et $$e_k$$ est dans le même sens que $$e_i$$ dans le
  cycle
- -1 si $$e_k \in C_i$$ et qu'il est dans l'autre sens
- 0 si $$ e_k \notin C_i$$

On défini alors $$C$$ la matrice des cycles fondamentaux de $$G$$ comme étant 
une matrice de format $$p-n+1 \times p$$ telle que sa $$i$$-ième ligne soit
égale au vecteur d'incidence de $$C_i$$.

Si on note $$U = \begin{pmatrix} u_1 \\ \vdots \\ u_p \end{pmatrix}$$ le
vecteur des potentiels dans chaque branche du circuit représenté par $$G$$, alors
les lignes de la relation $$CU = 0$$ nous donnent exactement $$p-n+1$$ lois des
mailles indépendantes.

[insérer un exemple]


# Comptons nos équations !

Une des choses qu'on apprend à faire en cours de physique avant de commencer à
résoudre un circuit, c'est de compter nos inconnues et nos équations pour être
certains que le système peut être résolu (sinon, on s'engage dans une *très
longue* aventure).

Déjà, dans le circuit, on a au total $$2p$$ inconnues : les inconnues sont les
potentiels et les intensités de chaque branche, donc deux inconnues par branche.

Maintenant, à l'aide du travail fait au dessus, on possède déjà $$n-1$$
équations par les lois des nœuds et $$p-n+1$$ pour les lois des nœuds, ce qui
fait un total de $$p$$ équations.

Mais sur chaque branche, il y a un dipôle (on considérera qu'un fil est un
dipôle qui impose $$u = 0$$[^dipole]). On défini un dipôle comme étant un objet imposant
une équation avec l'intensité ou le potentiel de sa branche. Par exemple, un
condensateur impose $$i = C\frac {\textrm{d} u} {\textrm{d}t}$$, et un
interrupteur ouvert impose $$i = 0$$, tout en laissant $$u$$ libre. 

[^dipole]: En pratique, pour simplifier les calculs, on considérera qu'un tel dipôle << supprime >> l'inconnue et donne une constante à la place.

Les équations de chaque dipôle sont linéairement indépendantes deux-à-deux, car
chaque dipôle appartient à une branche différente, et son équation met en jeu
des variables différentes que tous les autres dipôles.

De plus, les équations des dipôles sont linéairement indépendantes des lois de
Kirchhof, car ces lois mettent en jeu au moins deux inconnues de même << nature >>
(intensités ou courants), alors que les équations des dipôles possèdent au plus
une inconnue de même << nature >>. 

On a donc $$p$$ équations en plus, pour un total de $$2p$$, ce qui est bien égal
au nombre d'inconnues, youpi !

Ainsi, en supposant que le modèle du circuit possède une unique solution[^unique], 
on peut la trouver à partir de ces équations

[^unique]: Ce n'est malheureusement pas toujours le cas... cf. {% cite Recski1989 %}

# Références

{% bibliography --cited_in_order %}

<hr>

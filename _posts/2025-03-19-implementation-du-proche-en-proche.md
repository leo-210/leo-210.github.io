---
layout: post
title: Implémentation de l'algorithme de proche en proche
description: Code accompagné de quelques explications
---

# Un très long code... qui marche !

Voici une implémentation en OCaml de l'algorithme de proche en proche. Il prend
en entrée en fichier texte contenant les informations du circuit à résoudre, et
une des inconnues du circuit dont on veut récupérer une équation différentielle.
Si le circuit est résolvable par la méthode de proche en proche (ie. si on peut
trouver des substitutions à chaque étape), alors le programme renvoie une
équation différentielle.

Notez que les résultats sont certes corrects (au signe près, il faut que je
vérifie bien tout), mais ne sont pas simplifiés. Cela est quelque chose dont je
m'occuperai peut-être plus tard (ce n'est pas le coeur du TIPE).


## Format du fichier d'entrée

Le fichier d'entrée contient, dans l'ordre :
- un entier v : le nombre de sommets.
- un liste des arcs avec leur type et leur index (eg. `C1`, `R2`).
- la matrice d'incidence du circuit, avec les arcs dans le même ordre que la
  liste ci-dessus.

Exemple : 
```
6
E1 R1 F1 L1 C1 F2 F3
1  -1 0  0  0  0  0
0  1  -1 0  -1 0  0
0  0  1  -1 0  0  0
0  0  0  1  0  -1 0
0  0  0  0  1  1  -1
-1 0  0  0  0  0  1
```

Les `F` représentent des fils (ils permettent d'éviter des doubles arêtes, qui
ne sont pas supportées par cette implémentation).

# Annexe : implémentation en OCaml

Le programme est très long, car beaucoup de code est dédié à de la mise en 
place : création des structures de données, lecture du fichier et traduction
vers ces structures, exprimer les équations du circuit comme une fonction, etc.

Aussi, certains points pourraient être modifiés pour grandement améliorer les
performances, mais n'étant pas mon but principal, je ne m'en suis pas soucié
(eg. utiliser une structure qui permette de vérifier l'appartenance d'un élément
en $$ O(1) $$, au lieu de parcourir une liste à chaque fois).

```ocaml
{% include proche_en_proche.ml %}
```

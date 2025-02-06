---
layout: post
title: Un algorithme qui résout un circuit
description: Proposition d'un algorithme, preuve de sa terminaison et correction.
---

# Comment pourrions-nous résoudre n'importe quel circuit ?

Dans mon [premier post]({% link _posts/2025-02-01-premier-post.md %}), je
présente brièvement mes idées. Ici, je développe un peu plus celle d'un
résolveur de circuit, puisqu'après discussion elle semble pour l'instant être la
meilleure pour un TIPE.

L'idée c'est, qu'à partir d'un circuit quelconque (composé de dipôles connus),
le programme renvoie l'équation différentielle du circuit pour une grandeur
demandée.

# Un algorithme qui passe par les complexes

Une première idée serait de passer par les complexes : on peut alors faire des
circuits équivalents et des ponts diviseurs avec les impédances des dipôles.

En supposant que nous arrivions à détecter aisément des associations en série et
parallèle (cela dépend de comment on choisit de représenter le circuit dans la
mémoire, cf. un potentiel prochain post), on devrait pouvoir résoudre de manière 
assez efficace.

Mais cette approche a deux grand problèmes :
- Selon le circuit et la grandeur demandée, on a besoin de faire des choix entre
  circuit équivalent et ponts diviseurs, ce qui peut vite devenir assez délicat.
- Même si l'on obtient une solution, celle-ci sera très moche en complexe, et
  pour repasser en temporelle, elle nécessitera un grand travail de
  simplification littérale, ce qui risque d'être très compliqué dans certains
  cas pour un ordinateur.


# Résolution << de proche en proche >>

Une autre idée est de résoudre de << proche en proche >>. Étant donné un circuit
et une grandeur $$a$$ demandée, on essaye, en utilisant une équations du circuit
$$E$$, d'exprimer une autre grandeur, notons-la $$b$$, en fonction de $$a$$ 
uniquement. Puis on essaye d'exprimer une autre grandeur $$c$$ de la même 
manière, mais en considérant le résultat pour $$b$$ et sans utiliser $$E$$.

À chaque << tour >>, on se ramène à un système d'équations avec une équation en
moins et une inconnue en moins, par substitution.

Lorsqu'il ne reste qu'une équation, on renvoie cette équation avec toutes les
substitutions trouvées : on obtient une équation différentielle.

Et si, à un moment, on n'arrive pas à exprimer aucune grandeur en fonction de
$$a$$ uniquement, alors on renvoie une erreur.


## Terminaison de l'algorithme

En supposant que l'on possède $$n$$ grandeurs à exprimer et $$n$$ équations, à
chaque tour de l'algorithme, on ne possède plus que $$n-1$$ équation à exploiter
pour $$n-1$$ inconnues. De plus, si l'on arrive à 1 équation, le programme
renvoie la dernière équation avec toutes les substitutions de toutes les 
inconnues. Donc le nombre d'équations moins 1 est un variant (strictement 
décroissant et le programme s'arrête s'il est nul). Ainsi, le programme termine.


## Correction

On suppose que l'on commence avec un système de $$k$$ équation indépendantes à 
$$k$$ inconnues $$S$$. On note $$S_n$$ le système d'inconnues au 
$$n\text{-ième}$$ tour de boucle, et $$k_n$$ son nombre d'inconnnues. 

On propose l'invariant $$I_n$$ : << $$S$$ est équivalent à $$S_n$$ >>.

Pour $$n = 0$$, $$S_0 = S$$, ce qui est évidemment équivalent à $$S$$.

Supposons que $$I_n$$ soit vrai. L'algorithme trouve une substitution correcte
pour une inconnue $$a$$ en utilisant une équation $$E$$. Dès lors, on peut substituer
$$a$$ dans toutes les autres équations. On prend alors $$S_{n+1}$$ un système
d'équations à $$k_n$$ inconnues, avec les mêmes équations que $$S_n$$, sans $$E$$
et avec la substitution de $$a$$. Il est équivalent à $$S_n$$, et donc par
hypothèse de récurrence, à $$S$$.

D'où la correction.


## Choses à creuser

Bien entendu, cette preuve suppose que l'algorithme arrive à trouver un
substitution correcte. Mais ces preuves de terminaisons et corrections montrent
bien que l'idée a le mérite d'être creusée.

De plus, on suppose également que l'on arrive à tirer de n'importe quel circuit
un système de $$n$$ équations à $$n$$ inconnues, et que ces équations sont
indépendantes. Pour cela, en particulier pour les lois des mailles où les
redondances sont fréquentes et pas évidentes, on a besoin d'une réflexion plus
approfondie. La théorie des graphes semble être une bonne direction, en
utilisant notamment une matrice d'adjacence.

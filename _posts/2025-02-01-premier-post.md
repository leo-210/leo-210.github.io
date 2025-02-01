---
layout: post
title: Premier post, youpi !
description: Ceci est officiellement le premier post que je rédige, c'est beau.
---

# Un premier pas pour Léo, un grand pas pour... bahh Léo aussi

C'est fou ça quand même de pouvoir rédiger mon propre blog, mais j'ai 
l'impression de m'écarter du sujet principal, *roulement de tambour*, le TIPE.
C'est pas ici que j'expliquerai en détail chacune de mes idées, ainsi que tout
ce qui va avec, mais tant qu'à faire, voici un petit aperçu.


# Mes idées en bref

J'ai trois idées principales, qui rentrent plus ou moins dans le thème << Boucles
et cycles >>.

Les 3 idées viennent dans l'ordre du moins bon au meilleur (classement qui ne
tient uniquement à moi).


## Stocker précisément des nombres réel dans la mémoire

J'ai pas vraiment de lien avec le thème, mais je le trouve stylé. Il y a
plusieurs approches, dont :
- représenter les rationnels avec des fractions (mais dans ce cas au revoir les
  réels)
- représenter les nombres comme une fonction récursive qui à chaque appel donne
  une meilleure approximation du nombre (c'est stylé non ?)


## Un programme permettant de trouver l'équation différentielle d'un circuit composé de dipôles

Un peu plus dans le thème : un circuit c'est bien une boucle après tout.

Le sujet me plaît bien, ça devrait être plutôt rigolo de réfléchir à une bonne
implémentation, en mélangeant théorie des graphes pour représenter un circuit,
de la physique bien entendu, et éventuellement trouver comment créer une
interface accessible pour donner un circuit au programme.

Le soucis, c'est que j'ai peur que ça rentre un peu trop dans le "bidouillage",
car avec ce sujet je n'ai pas vraiment l'impression de répondre à une
problématique. J'ai juste une vague idée d'algorithme et l'idée de l'implémenter
me semble intéressante au moins.


## Un simulateur des mouvements d'astres avec une réflexion sur la précision

Le meilleur pour la fin, le sujet sur lequel je suis le plus enclin à partir
pour l'instant. En plus le thème c'est pas trop mal : les astres ont
généralement des trajectoire qui font des boucles (cf. la Terre autour du
soleil).

L'idée ce serait de créer un programme permettant de simuler n'importe les 
mouvements d'astres à partir d'une quelconque disposition.

C'est pas nouveau, mais pour introduire un peu de *fun* et de réflexion
scientifique, j'ai pensé à m'intéresser spécifiquement à la précision du
programme, tout en gardant un bon compromis avec la performance.

L'idée qui m'a lancé, c'est le choix du $$\mathrm{d}t$$ qui change énormément
la précision. Un plus petit $$ \mathrm{d}t $$ va évidemment augmenter la
précision, mais également détruire les performances. On se rend cependant
compte que selon l'accélération appliquée aux astres à un instant donné, on a 
besoin d'un plus ou moins petit $$ \mathrm{d}t $$ pour garder une même 
précision. En effet, si l'accélération est assez faible, la vitesse ne variera
*pas trop*, et on peut alors se permettre de prendre un $$ \mathrm{d} t $$ plus
grand, sans trop perdre en précision.

Ce qui serait intéressant, ce serait d'essayer de quantifier cette précision,
pour ainsi avoir une imprécision constante sur le mouvement des astres à tout
instant.

Un projet annexe serait d'implémenter une interface graphique pour voir les
planètes bouger (c'est bien plus rigolo comme ça). Dans ce cas le programme
serait probablement en C, pour utiliser des librairies telles que OpenGL 3.


## Conclusion

Finalement, en intro j'ai menti, je suis tout de même entré un peu dans les
détails, mais c'est mon blog donc je fais ce que je veux, et toc !

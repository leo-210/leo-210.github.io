---
layout: post
title: Retour sur le proche en proche
description: Précisions et nouveaux problèmes
---

# Un algorithme imparfait

L'algorithme de résolution "de proche en proche" a une grande faille : il n'est
pas garanti qu'une substitution soit toujours trouvée, parfois il n'y en a pas.
En pratique, l'algorithme est ainsi très efficace et plutôt simple à
implémenter, mais seulement pour des circuits plutôt simples. On peut
donc parfois trouver une équation différentielle en $$O(n^2)$$[^prouver], ce qui n'est pas
dégueulasse.

[^prouver]: Cela me semble assez intuitif, mais il faudrait quand-même rédiger une preuve un peu rigoureuse.

## Une capacité de simplification

L'algorithme permet tout de même de parfois simplifier un système d'équations
différentielles linéaire en enlevant des inconnues et des équations. Il peut
donc y avoir une certaine utilité.

Certes, pour certains systèmes où il n'arrive même pas à trouver une
substitution, le proche en proche n'aura aucun changement sur le système, mais
il peut le simplifier, au pire il ne fera rien.

Dans l'idée de simplifier des systèmes, si l'on ne trouve aucune substitution à
une certaine étape, on peut choisir une des inconnues du circuit arbitrairement, 
et considérer qu'elle est déjà connue. Bien que cela puisse ne rien y faire, en
pratique ça permet de débloquer souvent certaines situations et d'encore réduire
le système.

À la fin on obtient donc un système équivalent (on l'a démontré précédemment) à
au plus $$n$$ inconnues, et assez souvent moins.

> **À creuser :** une question qui me semble intéressante, c'est le choix des 
> inconnues que l'on veut garder à la fin de telle sorte à optimiser au maximum la 
> simplification. [Cette vidéo](https://www.youtube.com/watch?v=F8qiM3o0Jc0) donne 
> une approche "algorithmique" qui semblerait permettre d'optimiser exactement cela.
> Cependant, la vidéo ne montre pas vraiment pourquoi, et cette astuce semble
> être plutôt empirique qu'autre chose.
{: .note }


# D'autres pistes d'algorithmes

## Par les complexes

Comme je l'avais présenté dans un autre post, on peut résoudre un circuit en
passant par les nombres complexes, en considérant que tout dipôle possède une
impédance complexe, qui marche un peu comme une résistance. 

C'est pratique car on peut alors réutiliser les théorèmes basés sur la loi
d'Ohm, tels que les ponts diviseurs et les résistances équivalentes en 
série/parallèle.

Une des difficultés, c'est que le choix de quand faire tel pont diviseur, quand
faire tel circuit équivalent semble très arbitraire et difficile à déterminer de
manière efficace par un ordinateur. Il y a toujours l'option du backtracking :
on essaie toutes les possibilités jusqu'à ce que ça marche, mais là, la 
complexité explose, ce qui n'est pas terrible.

Autre problème, c'est que cette approche donne des gros calculs à la fin, et
faire de la simplification littérale de manière algorithmique, c'est pas facile.


## Théorème de Millman

Un dernier problème de l'approche ci-dessous, c'est qu'il existe des circuit où
l'on ne peut faire ni de ponts diviseurs, ni trouver d'associations en série ou
en parallèle, c'est nul.

Mais il existe un théorème bien puissant qui pourrait débloquer une grande
partie de ces problèmes, au défaut près qu'il ajoute une couche de complexité
calculatoire.

Il faut que je me penche un peu plus sur le théorème de Millman, en particulier
voir s'il existe des circuits qui ne serait pas résolvables en utilisant toutes
ces techniques, ce qui poserait problème car il faudrait encore trouver autre
chose. 

Si au contraire on peut tout résoudre avec ces trois outils, le prouver serait
certainement intéressant.


## Mini conclusion sur les complexes

Cette méthode par les complexes semble donc pouvoir résoudre plus de circuits en
général que le proche en proche, mais au prix d'être beaucoup plus compliquée à
implémenter.

<hr>

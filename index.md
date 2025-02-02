---
title: Avancée TIPE
layout: default
---

# Un projet pris très au sérieux

Ici, ça rigole pas. On est (plutôt "je" en fait maintenant que j'y pense, bref)
là pour faire un joli truc bien cool et tout ça tout ça. 

Ouais je sais pas vraiment quoi écrire, mais faut bien meubler pour que le site
ressemble à quelque chose.


# Structure du site

Le site sera un genre de blog, avec chaque post décrivant mes différentes
avancées sur le TIPE, mes réflexions, les décisions prises, mes résultats ou 
mes échec, afin de garder une trace datée de tout ça.


# Liste des posts

Vous pouvez trouver la liste de tous les posts ci-dessous.

{% for post in site.posts %}

* * *

### {{post.date | date: "%d/%m/%y"}} --- [{{ post.title }}]({{ post.url }})
{{ post.description | truncate: 96}}


{%endfor%}


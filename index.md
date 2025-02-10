---
layout: default
title: ""
---

# Structure du site

Le site sera un genre de blog, avec chaque post décrivant mes différentes
avancées sur le TIPE, mes réflexions, les décisions prises, mes résultats ou 
mes échec, afin de garder une trace datée de tout ça.

La bibliographie actuelle est disponible [juste ici]({% link refs.md %}) 

# Idée actuelle

Si nécessaire, je ferai une page dédiée à cette partie.

Mon idée de sujet actuellement, c'est de créer un programme permettant, pour
n'importe quel circuit électronique, de donner l'équation différentielle 
vérifiée par une grandeur arbitrairement choisie du circuit.


# Liste des posts

Vous pouvez trouver la liste de tous les posts ci-dessous.

{% for post in site.posts %}

* * *

### {{post.date | date: "%d/%m/%y"}} --- [{{ post.title }}]({{ post.url }})
{{ post.description | truncate: 96}}


{%endfor%}


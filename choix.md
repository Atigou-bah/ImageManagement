# EXPLICATION DES CHOIX

## Modélisation et Implémentation

Dans la modélisation de la base de données, plusieurs entités et relations ont été mises en place avec des contraintes d'intégrité pour chaque entité et relation. Certaines contraintes pouvaient être directement établies lors de la création des tables (**statique**), tandis que d'autres devaient être gérées de façon **dynamique** via des triggers.

Pour choisir l'implémentation d'une contrainte, il fallait déterminer si elle pouvait être réalisée facilement de manière statique (en utilisant des `CHECK`) ou si elle nécessitait une gestion dynamique avec des triggers.

---

## Requêtes et Optimisations

### 1. Nombre d’images publiées par catégorie au cours des deux dernières semaines

Pour cette requête, j'ai défini quelques index pour améliorer les performances :  

- Un index sur **IMAGE(date_publication)**  
- Un index sur **IMAGE(idCategorie)**

---

### 2. Par utilisateur, le nombre d’albums, d’images publiées, de likes donnés et reçus

Pour optimiser cette requête, j'ai défini les index suivants :  

- **ALBUM(idUtilisateur)**  
- **IMAGE(idUtilisateur)**  
- **LIKES(idUtilisateur)**  
- **LIKES(idImage)**

---

### 3. Pour chaque image, le nombre de likes par pays des utilisateurs, et la différence entre le pays ayant le plus de likes et celui en ayant le moins, triée par valeur absolue de cette différence

Pour cette requête :  

- J'ai créé une **vue** qui contient, pour chaque image, le pays de ses likes et le nombre de likes par pays.  
- Cela permet de calculer facilement le maximum et le minimum des likes par pays pour chaque image.  
- Les index définis pour cette optimisation sont :  
  - **IMAGE(idImage)**  
  - **UTILISATEUR(pays)**

---

### 4. Les images qui ont au moins deux fois plus de likes que la moyenne des images de leur catégorie

Pour cette requête également, j'ai utilisé des index pour optimiser la recherche :  

- **IMAGE(idCategorie)**  
- **LIKES(idImage, idUtilisateur)**  

Ces index avaient déjà été définis dans les requêtes précédentes, ce qui permet de réutiliser les optimisations existantes.

---

## Procédures et fonctions 

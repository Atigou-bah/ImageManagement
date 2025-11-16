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

# Procedures, Functions & Triggers – Documentation

Ce document présente les procédures, fonctions et déclencheurs développés dans le cadre du projet de gestion d’images.  
La structure et la présentation ont été améliorées pour offrir une documentation claire et professionnelle.

---

## 1. Fonction : Conversion d’une image en JSON

L’objectif est de créer une fonction qui convertit les informations d’une image (titre, auteur, catégorie, nombre de likes, etc.) au format **JSON**.

Deux approches possibles :

1. **Retourner un CLOB JSON**  
   Permet de manipuler les données JSON directement dans PL/SQL.

2. **Écrire le JSON dans un fichier externe**  
   Utile pour l’export ou l’intégration avec d’autres systèmes.

Dans notre implémentation, nous avons choisi de **retourner un CLOB au format JSON**, facilitant ainsi l’utilisation au sein de la base de données.

---

## 2. Procédure : Génération de la newsletter hebdomadaire

Cette procédure génère automatiquement une newsletter contenant :

- un texte descriptif,  
- la liste des **20 images les plus populaires de la semaine**.

La newsletter générée est ensuite enregistrée en base.

### 2.1. Table `NEWSLETTER`

La table suivante permet de stocker la newsletter hebdomadaire :

| Champ          | Type   | Description                                |
|----------------|--------|--------------------------------------------|
| `idNewsletter` | NUMBER | Identifiant unique                          |
| `description`  | VARCHAR   | Contenu textuel de la newsletter            |
| `images`       | CLOB   | Liste (texte ou JSON) des images incluses   |
| `date_envoi`   | DATE   | Date d’envoi de la newsletter               |

Le type **CLOB** est utilisé pour permettre le stockage flexible de blocs textuels volumineux (contenu + images).

---

## 3. Procédure : Recommandation d’images pour un utilisateur

Cette procédure génère une liste personnalisée d’images recommandées en fonction :

- des catégories préférées de l’utilisateur,
- de la popularité récente des images.

### 3.1. Vue `IMAGE_POPULAIRE_RECENTE`

Cette vue liste les images considérées comme populaires.  
Dans notre cas : une image ayant reçu **au moins 5 likes**.

La procédure utilise deux **curseurs** :

1. Sur les catégories préférées de l’utilisateur.
2. Sur la vue `IMAGE_POPULAIRE_RECENTE`.

Cela permet d’obtenir une sélection d’images :

- pertinentes (catégories voulues),
- populaires et récentes.

---

# Déclencheurs (Triggers)

## 1. Limitation du nombre d’albums par utilisateur

Un utilisateur ne peut pas créer plus de **x albums**.  
Ici, la limite est fixée à **5 albums**.

Le déclencheur :

- Vérifie, avant insertion, le nombre d’albums existants pour l’utilisateur.
- Bloque l’opération si la limite est dépassée.

Ce système garantit un usage raisonnable selon la taille du jeu de données.

---

## 2. Archivage automatique lors de la suppression d’une image

Lorsqu’une image est supprimée, elle doit être automatiquement archivée dans une table dédiée.

Un déclencheur `BEFORE DELETE` :

- insère l’image dans une table d’archives,
- puis laisse la suppression s’effectuer.

Une fonction `archive_image(id_image)` permet de tester facilement ce déclencheur en appelant une suppression contrôlée.

---

## 3. Anti-spam : Limitation du nombre d’images publiées par seconde

Pour éviter le spam, un utilisateur ne peut pas publier plus de **y images par seconde**.  
Dans notre jeu de données : **5 images/sec**.

Le déclencheur :

1. Vérifie les timestamps des dernières images publiées par l’utilisateur,
2. Compare les secondes (avec conversion correcte),
3. Bloque l’insertion si la limite est atteinte.

Cela empêche les publications massives en un très court instant.

---

# Conclusion

Les éléments développés permettent :

- une gestion cohérente et automatisée des images,
- un système de recommandations pertinent,
- une newsletter hebdomadaire dynamique,
- des règles d’intégrité grâce aux déclencheurs (limites, archivage, anti-spam).

Ces fonctionnalités assurent un fonctionnement robuste et optimisé du système.





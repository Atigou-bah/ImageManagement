# 📸 Projet BDD : Site de Partage d'Images

Ce projet consiste en la conception et l'implémentation d'une base de données relationnelle complète pour un site de partage d'images (type Flickr ou Instagram).

Le système gère les utilisateurs, les publications d'images, les albums, ainsi que les interactions sociales (likes, commentaires) et génère des suggestions de contenu basées sur la popularité.

## 📋 Fonctionnalités du Système

Le modèle de données supporte les fonctionnalités suivantes :

* **Gestion des Utilisateurs :** Inscription, profil (nom, pays, date de naissance), préférences de catégories.
* **Gestion des Images :**
    * Classification par catégorie principale (Nature, Architecture, etc.) et tags multiples.
    * Métadonnées complètes (taille, format, visibilité publique/privée, pays, etc.).
    * **Système d'Archivage :** Les images supprimées ou inactives sont déplacées automatiquement dans une table d'historique.
* **Organisation :** Regroupement des images dans des **Albums** (publics ou privés).
* **Interactions Sociales :** Système de "Likes" et de commentaires.
* **Algorithmes de Contenu :**
    * Calcul de popularité basé sur les likes des 2 dernières semaines.
    * Génération automatique de newsletters et de suggestions personnalisées.

## 🛠️ Architecture Technique

Le projet intègre les éléments suivants :

### 1. Modélisation
* **Modèle Entité-Association (E/A)** : Conception conceptuelle respectant les contraintes métier.
* **Modèle Relationnel** : Traduction logique avec typage précis et clés primaires/étrangères.

### 2. SQL Avancé (Analytique)
Des requêtes complexes ont été développées pour extraire des statistiques, notamment :
* Volume d'images par catégorie (2 dernières semaines).
* Tableau de bord utilisateur (nombre d'albums, likes donnés/reçus).
* Analyse géographique des likes (écart entre pays).
* Détection de corrélations : les couples d'images souvent "likées" ensemble par un même utilisateur.

### 3. PL/SQL (Logique Procédurale)
* **Fonctions :** Conversion des données d'une image au format **JSON**.
* **Procédures :** Génération de la **newsletter hebdomadaire** (Top 20 images populaires).
* **Recommandation :** Algorithme de suggestion d'images selon les goûts de l'utilisateur.

### 4. Déclencheurs (Triggers) & Intégrité
* **Archivage automatique :** Trigger au moment de la suppression (`DELETE`) d'une image pour la basculer vers la table d'archives.
* **Quotas :** Limitation du nombre d'albums par utilisateur.
* **Anti-Spam :** Limitation de la fréquence d'ajout d'images par seconde.

from faker import Faker
import random
from datetime import datetime
from calendar import monthrange 

# ==============================
# ⚙️ GENERAL CONFIGURATION
# ==============================
# Change the locale to 'en_US' for English data
fake = Faker('en_US')

# Nombre d’éléments à générer
N = 50          # users, albums, etc.
N_images = 100  # images

# Output SQL file
sql_file = "data_en.sql"

# Constante pour le minimum de likes (NOUVEAU)
MIN_LIKES_PER_IMAGE = 15

# ==============================
# 📌 Function to generate a random timestamp in the CURRENT month/year
# ==============================
def random_datetime_current_month():
    # Get the current date and time
    now = datetime.now()
    
    # Get the current year and month
    year = now.year
    month = now.month
    
    # Determine the number of days in the current month
    _, days_in_month = monthrange(year, month)
    
    # Select a random day in that month
    day = random.randint(1, days_in_month)
    hour = random.randint(0, 23)
    minute = random.randint(0, 59)
    second = random.randint(0, 59)
    
    # Format the date and time string
    return f"{year}-{month:02d}-{day:02d} {hour:02d}:{minute:02d}:{second:02d}"

# ==============================
# Generating the SQL file
# ==============================
with open(sql_file, "w", encoding="utf-8") as f:

    f.write(f"SET DEFINE OFF;\n")

    # ==============================
    # 1️⃣ USERS (50 Inserts)
    # ==============================
    f.write("-- ======= USERS =======\n")
    for _ in range(N):
        identifiant = fake.unique.user_name()
        mdp = fake.password(length=10)
        nom = fake.last_name().replace("'", "''")
        prenom = fake.first_name().replace("'", "''")
        date_naissance = fake.date_of_birth(minimum_age=18, maximum_age=70).strftime("%Y-%m-%d")
        email = fake.unique.email()
        pays = fake.country().replace("'", "''")
        abonne_newsletter = random.choice([0, 1])

        f.write(
            f"INSERT INTO UTILISATEUR (identifiant, mdp, nom, prenom, date_naissance, email, pays, abonne_newsletter) "
            f"VALUES ('{identifiant}', '{mdp}', '{nom}', '{prenom}', "
            f"TO_DATE('{date_naissance}', 'YYYY-MM-DD'), "
            f"'{email}', '{pays}', {abonne_newsletter});\n"
        )
    f.write("\n")

    # ==============================
    # 2️⃣ CATEGORIES (15 Inserts)
    # ==============================
    f.write("-- ======= CATEGORIES =======\n")
    categories = [
        "nature", "art", "architecture", "animals", "technology",
        "fashion", "sports", "food", "travel", "music",
        "science", "history", "movies", "literature", "design"
    ]
    for nom in categories:
        f.write(f"INSERT INTO CATEGORIE(nom) VALUES('{nom}');\n")
    f.write("\n")

    # ==============================
    # 3️⃣ LABELS (36 Inserts)
    # ==============================
    f.write("-- ======= LABELS =======\n")
    labels_images = [
        "landscape", "forest", "mountain", "river", "lake", "beach", "desert",
        "building", "house", "bridge", "street", "car", "bike", "train", "plane",
        "animal", "bird", "cat", "dog", "flower", "tree", "sky", "food",
        "fruit", "vegetable", "person", "portrait", "child", "crowd", "city",
        "countryside", "sea", "ocean", "snow", "sunset", "night"
    ]
    for nom in labels_images:
        f.write(f"INSERT INTO LABEL(nom) VALUES('{nom}');\n")
    f.write("\n")

    # ==============================
    # 4️⃣ IMAGES (100 Inserts)
    # ==============================
    f.write("-- ======= IMAGES =======\n")
    for id_image in range(1, N_images + 1):
        titre = fake.word().replace("'", "''")
        id_utilisateur = random.randint(1, N)
        id_categorie = random.randint(1, len(categories))
        description = fake.sentence().replace("'", "''")
        date_pub = random_datetime_current_month()
        format_img = random.choice(["png", "svg", "jpeg", "jpg"])
        taille = random.randint(100, 5000)
        visibilite = random.choice([0, 1])
        pays_origine = fake.country().replace("'", "''")
        telechargeable = random.choice([0, 1])

        f.write(
            f"INSERT INTO IMAGE (idUtilisateur, idCategorie, description, titre, date_publication, format, taille, visibilite, pays, telechargeables) "
            f"VALUES ({id_utilisateur}, {id_categorie}, '{description}', '{titre}', "
            f"TO_TIMESTAMP('{date_pub}', 'YYYY-MM-DD HH24:MI:SS'), "
            f"'{format_img}', {taille}, {visibilite}, '{pays_origine}', {telechargeable});\n"
        )
    f.write("\n")

    # ==============================
    # 5️⃣ ALBUMS (50 Inserts)
    # ==============================
    f.write("-- ======= ALBUMS =======\n")
    for id_album in range(1, N + 1):
        titre_album = fake.word().replace("'", "''")
        description = fake.sentence(nb_words=6).replace("'", "''")
        date_creation = random_datetime_current_month()
        visibilite_al = random.choice([0, 1])
        id_utilisateur = random.randint(1, N)

        f.write(
            f"INSERT INTO ALBUM(idUtilisateur, titre, description, date_creation, visibilite) "
            f"VALUES({id_utilisateur}, '{titre_album}', '{description}', "
            f"TO_TIMESTAMP('{date_creation}', 'YYYY-MM-DD HH24:MI:SS'), {visibilite_al});\n"
        )
    f.write("\n")

    # ==============================
    # 6️⃣ LIKES
    # ==============================
    f.write("-- ======= LIKES (MIN 15 PER IMAGE) =======\n")
    
    # Itérer sur chaque image de 1 à N_images (1 à 100)
    for id_image in range(1, N_images + 1):
        # Nombre de likes : minimum 15, maximum aléatoire (ex: 15 à 30)
        nombre_like = random.randint(MIN_LIKES_PER_IMAGE, 30) 
        
        # Pour éviter les contraintes d'unicité (un utilisateur ne peut liker qu'une fois)
        # On choisit aléatoirement un nombre unique d'utilisateurs parmi les N utilisateurs (50)
        # Assurez-vous que nombre_like ne dépasse pas N (50)
        actual_likes = min(nombre_like, N)
        
        # Choisir 'actual_likes' utilisateurs distincts
        liking_users = random.sample(range(1, N + 1), actual_likes)
        
        for id_utilisateur in liking_users:
            date_like = random_datetime_current_month()
            f.write(
                f"INSERT INTO LIKES(idImage, idUtilisateur, date_like) "
                f"VALUES({id_image}, {id_utilisateur}, "
                f"TO_TIMESTAMP('{date_like}', 'YYYY-MM-DD HH24:MI:SS'));\n"
            )
    f.write("\n")

    # ==============================
    # 7️⃣ COMMENTS (WITHOUT DATE)
    # ==============================
    f.write("-- ======= COMMENTS =======\n")
    # Utiliser le même principe que LIKES pour garantir au moins N_images commentaires au total
    for id_image in range(1, N_images + 1):
        nombre_commente = random.randint(5, 15) # Exemple : 5 à 15 commentaires par image
        
        commenting_users = random.sample(range(1, N + 1), min(nombre_commente, N))
        
        for id_utilisateur in commenting_users:
            texte = fake.sentence(nb_words=10).replace("'", "''")
            f.write(
                f"INSERT INTO COMMENTE(idImage, idUtilisateur, texte) "
                f"VALUES({id_image}, {id_utilisateur}, '{texte}');\n"
            )
    f.write("\n")

    # ==============================
    # 8️⃣ HAS_LABEL
    # ==============================
    f.write("-- ======= HAS_LABEL =======\n")
    labels_count = len(labels_images)
    for id_image in range(1, N_images + 1):
        nombre_label = random.randint(0, 5)
        
        # Choisir des labels uniques
        label_ids = random.sample(range(1, labels_count + 1), min(nombre_label, labels_count))
        
        for id_label in label_ids:
            f.write(
                f"INSERT INTO SON_LABEL(idImage, idLabel) VALUES({id_image}, {id_label});\n"
            )
    f.write("\n")

    # ==============================
    # 9️⃣ PREFERS
    # ==============================
    f.write("-- ======= PREFERS =======\n")
    categories_count = len(categories)
    for id_utilisateur in range(1, N + 1):
        nb_cat = random.randint(0, 5)
        
        # Choisir des catégories uniques
        category_ids = random.sample(range(1, categories_count + 1), min(nb_cat, categories_count))
        
        for id_categorie in category_ids:
            f.write(
                f"INSERT INTO PREFERE(idUtilisateur, idCategorie) VALUES({id_utilisateur}, {id_categorie});\n"
            )
    f.write("\n")

    # ==============================
    # 🔟 BELONGS_TO (RÉVISION POUR CLÉS ÉTRANGÈRES)
    # ==============================
    f.write("-- ======= BELONGS_TO (Ensures valid IDs) =======\n")
    
    album_ids = list(range(1, N + 1)) # 1 à 50
    image_ids = list(range(1, N_images + 1)) # 1 à 100
    used_pairs = set()

    # Itérer sur chaque album pour y ajouter des images
    for id_album in album_ids:
        nb_image = random.randint(0, 7)
        
        # Filtrer les images qui ne sont PAS déjà dans cet album
        possible_image_choices = [img for img in image_ids if (id_album, img) not in used_pairs]

        if not possible_image_choices:
            continue

        # Sélectionner jusqu'à nb_image images uniques à ajouter
        images_to_add = random.sample(possible_image_choices, min(nb_image, len(possible_image_choices)))

        for id_image in images_to_add:
            used_pairs.add((id_album, id_image))
            f.write(
                f"INSERT INTO APPARTIENT(idAlbum, idImage) VALUES({id_album}, {id_image});\n"
            )
    f.write("\n")

print(f"✅ File {sql_file} successfully generated with MIN_LIKES_PER_IMAGE={MIN_LIKES_PER_IMAGE} and foreign key fix for APPARTIENT!")
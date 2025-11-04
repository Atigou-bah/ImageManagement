from faker import Faker
import random

# ==============================
# ⚙️ CONFIGURATION GÉNÉRALE
# ==============================
fake = Faker('fr_FR')

# Nombre d’éléments à générer
N = 50          # utilisateurs, albums, etc.
N_images = 100  # images

# Fichier SQL de sortie
sql_file = "insertion.sql"

# ==============================
# Génération du fichier SQL
# ==============================
with open(sql_file, "w", encoding="utf-8") as f:

    f.write("-- ==============================\n")
    f.write("-- ⚡ INSERTIONS GÉNÉRÉES PAR PYTHON\n")
    f.write("-- ==============================\n\n")

    # ==============================
    # 1️⃣ UTILISATEURS
    # ==============================
    f.write("-- ======= UTILISATEURS =======\n")
    for _ in range(N):
        identifiant = fake.unique.user_name()
        mdp = fake.password(length=10)
        nom = fake.last_name().replace("'", "''")
        prenom = fake.first_name().replace("'", "''")
        date_naissance = fake.date_of_birth(minimum_age=18, maximum_age=70).strftime("%Y-%m-%d")
        email = fake.unique.email()
        pays = fake.country().replace("'", "''")
        abonne_newsletter = random.choice([0, 1])

        f.write(f"INSERT INTO UTILISATEUR (identifiant, mdp, nom, prenom, date_naissance, email, pays, abonne_newsletter) "
                f"VALUES ('{identifiant}', '{mdp}', '{nom}', '{prenom}', TO_DATE('{date_naissance}', 'YYYY-MM-DD'), "
                f"'{email}', '{pays}', {abonne_newsletter});\n")
    f.write("\n")

    # ==============================
    # 2️⃣ CATEGORIES
    # ==============================
    f.write("-- ======= CATEGORIES =======\n")
    categories = [
        "nature", "art", "architecture", "animaux", "technologie",
        "mode", "sports", "gastronomie", "voyage", "musique",
        "science", "histoire", "films", "littérature", "design"
    ]
    for nom in categories:
        f.write(f"INSERT INTO CATEGORIE(nom) VALUES('{nom}');\n")
    f.write("\n")

    # ==============================
    # 3️⃣ LABELS
    # ==============================
    f.write("-- ======= LABELS =======\n")
    labels_images = [
        "paysage", "forêt", "montagne", "rivière", "lac", "plage", "désert",
        "bâtiment", "maison", "pont", "rue", "voiture", "vélo", "train", "avion",
        "animal", "oiseau", "chat", "chien", "fleur", "arbre", "ciel", "nourriture",
        "fruit", "légume", "personne", "portrait", "enfant", "foule", "ville",
        "campagne", "mer", "océan", "neige", "coucher de soleil", "nuit"
    ]
    for nom in labels_images:
        f.write(f"INSERT INTO LABEL(nom) VALUES('{nom}');\n")
    f.write("\n")

    # ==============================
    # 4️⃣ IMAGES
    # ==============================
    f.write("-- ======= IMAGES =======\n")
    for _ in range(N_images):
        titre = fake.word().replace("'", "''")
        id_utilisateur = random.randint(1, N)
        id_categorie = random.randint(1, len(categories))
        description = fake.sentence().replace("'", "''")
        date_pub = fake.date_between(start_date='-1y', end_date='today').strftime("%Y-%m-%d")
        format_img = random.choice(["png", "svg", "jpeg", "jpg"])
        taille = random.randint(100, 5000)
        visibilite = random.choice([0, 1])
        pays_origine = fake.country().replace("'", "''")
        telechargeable = random.choice([0, 1])

        f.write(f"INSERT INTO IMAGE (idUtilisateur, idCategorie, description, titre, date_publication, format, taille, visibilite, pays, telechargeables) "
                f"VALUES ({id_utilisateur}, {id_categorie}, '{description}', '{titre}', TO_DATE('{date_pub}', 'YYYY-MM-DD'), "
                f"'{format_img}', {taille}, {visibilite}, '{pays_origine}', {telechargeable});\n")
    f.write("\n")

    # ==============================
    # 5️⃣ ALBUMS
    # ==============================
    f.write("-- ======= ALBUMS =======\n")
    for _ in range(N):
        titre_album = fake.word().replace("'", "''")
        description = fake.sentence(nb_words=6).replace("'", "''")
        date_creation = fake.date_between(start_date='-1y', end_date='today').strftime("%Y-%m-%d")
        visibilite_al = random.choice([0, 1])
        id_utilisateur = random.randint(1, N)

        f.write(f"INSERT INTO ALBUM(idUtilisateur, titre, description, date_creation, visibilite) "
                f"VALUES({id_utilisateur}, '{titre_album}', '{description}', TO_DATE('{date_creation}', 'YYYY-MM-DD'), {visibilite_al});\n")
    f.write("\n")

    # ==============================
    # 6️⃣ LIKES
    # ==============================
    f.write("-- ======= LIKES =======\n")
    for _ in range(N):
        id_image = random.randint(1, N_images)
        nombre_like = random.randint(0, 5)
        for _ in range(nombre_like):
            date_like = fake.date_between(start_date='-1y', end_date='today').strftime("%Y-%m-%d")
            id_utilisateur = random.randint(1, N)
            f.write(f"INSERT INTO LIKES(idImage, idUtilisateur, date_like) "
                    f"VALUES({id_image}, {id_utilisateur}, TO_DATE('{date_like}', 'YYYY-MM-DD'));\n")
    f.write("\n")

    # ==============================
    # 7️⃣ COMMENTAIRES
    # ==============================
    f.write("-- ======= COMMENTAIRES =======\n")
    for _ in range(N):
        id_image = random.randint(1, N_images)
        nombre_commente = random.randint(0, 5)
        for _ in range(nombre_commente):
            texte = fake.sentence(nb_words=10).replace("'", "''")
            id_utilisateur = random.randint(1, N)
            f.write(f"INSERT INTO COMMENTE(idImage, idUtilisateur, texte) "
                    f"VALUES({id_image}, {id_utilisateur}, '{texte}');\n")
    f.write("\n")

    # ==============================
    # 8️⃣ SON_LABEL
    # ==============================
    f.write("-- ======= SON_LABEL =======\n")
    for _ in range(N):
        id_image = random.randint(1, N_images)
        nombre_label = random.randint(0, 5)
        for _ in range(nombre_label):
            id_label = random.randint(1, len(labels_images))
            f.write(f"INSERT INTO SON_LABEL(idImage, idLabel) VALUES({id_image}, {id_label});\n")
    f.write("\n")

    # ==============================
    # 9️⃣ PREFERE
    # ==============================
    f.write("-- ======= PREFERE =======\n")
    for _ in range(N):
        id_utilisateur = random.randint(1, N)
        nb_cat = random.randint(0, 5)
        for _ in range(nb_cat):
            id_categorie = random.randint(1, len(categories))
            f.write(f"INSERT INTO PREFERE(idUtilisateur, idCategorie) VALUES({id_utilisateur}, {id_categorie});\n")
    f.write("\n")

    # ==============================
    # 🔟 APPARTIENT
    # ==============================
    f.write("-- ======= APPARTIENT =======\n")
    for _ in range(N):
        id_album = random.randint(1, N)
        nb_image = random.randint(0, 5)
        for _ in range(nb_image):
            id_image = random.randint(1, N_images)
            f.write(f"INSERT INTO APPARTIENT(idAlbum, idImage) VALUES({id_album}, {id_image});\n")
    f.write("\n")

print(f"✅ Fichier {sql_file} généré avec succès !")

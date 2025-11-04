    from faker import Faker
    import random
    import oracledb
    import getpass

    # ==============================
    # ⚙️ CONFIGURATION GÉNÉRALE
    # ==============================
    fake = Faker('fr_FR')

    # Active le mode thick
    oracledb.init_oracle_client()

    DB_USER = "ton_user"
    DB_PASS = "mdp"
    DB_HOST = "osr-oracle.unistra.fr"
    DB_PORT = 1521
    DB_SERVICE = "osr"  # service name récupéré depuis DBeaver

    # DSN avec service_name
    dsn = f"(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST={DB_HOST})(PORT={DB_PORT}))(CONNECT_DATA=(SERVICE_NAME={DB_SERVICE})))"

    print("Connexion à Oracle...")
    conn = oracledb.connect(user=DB_USER, password=DB_PASS, dsn=dsn)
    print("Connecté !")


# Nombre d’éléments à générer
N = 50          # utilisateurs, albums, etc.
N_images = 100  # images

# ==============================
# 1️⃣ UTILISATEURS
# ==============================
for _ in range(N):
    identifiant = fake.unique.user_name()
    mdp = fake.password(length=10)
    nom = fake.last_name()
    prenom = fake.first_name()
    date_naissance = fake.date_of_birth(minimum_age=18, maximum_age=70).strftime("%Y-%m-%d")
    email = fake.unique.email()
    pays = fake.country()
    abonne_newsletter = random.choice([0, 1])

    cur.execute("""
        INSERT INTO UTILISATEUR (identifiant, mdp, nom, prenom, date_naissance, email, pays, abonne_newsletter)
        VALUES (:1, :2, :3, :4, TO_DATE(:5, 'YYYY-MM-DD'), :6, :7, :8)
    """, (identifiant, mdp, nom, prenom, date_naissance, email, pays, abonne_newsletter))

print(f"👤 {N} utilisateurs insérés avec succès ✅")

# ==============================
# 2️⃣ CATEGORIES
# ==============================
categories = [
    "nature", "art", "architecture", "animaux", "technologie",
    "mode", "sports", "gastronomie", "voyage", "musique",
    "science", "histoire", "films", "littérature", "design"
]

for nom in categories:
    cur.execute("""INSERT INTO CATEGORIE(nom) VALUES(:1)""", (nom,))

print(f"🏷️  {len(categories)} catégories insérées avec succès ✅")

# ==============================
# 3️⃣ LABELS
# ==============================
labels_images = [
    "paysage", "forêt", "montagne", "rivière", "lac", "plage", "désert",
    "bâtiment", "maison", "pont", "rue", "voiture", "vélo", "train", "avion",
    "animal", "oiseau", "chat", "chien", "fleur", "arbre", "ciel", "nourriture",
    "fruit", "légume", "personne", "portrait", "enfant", "foule", "ville",
    "campagne", "mer", "océan", "neige", "coucher de soleil", "nuit"
]

for nom in labels_images:
    cur.execute("""INSERT INTO LABEL(nom) VALUES(:1)""", (nom,))

print(f"🔖 {len(labels_images)} labels insérés avec succès ✅")

# ==============================
# 4️⃣ IMAGES
# ==============================
for _ in range(N_images):
    titre = fake.word()
    id_utilisateur = random.randint(1, N)
    id_categorie = random.randint(1, len(categories))
    description = fake.sentence()
    date_pub = fake.date_between(start_date='-1y', end_date='today').strftime("%Y-%m-%d")
    format_img = random.choice(["png", "svg", "jpeg", "jpg"])
    taille = random.randint(100, 5000)
    visibilite = random.choice([0, 1])
    pays_origine = fake.country()
    telechargeable = random.choice([0, 1])

    cur.execute("""
        INSERT INTO IMAGE (idUtilisateur, idCategorie,description,titre, date_publication, format, taille, visibilite, pays, telechargeables)
        VALUES (:1, :2, :3, :4, TO_DATE(:5, 'YYYY-MM-DD'), :6, :7, :8, :9,:10)
    """, (id_utilisateur, id_categorie, description, titre, date_pub, format_img, taille, visibilite, pays_origine, telechargeable))

print(f"🖼️  {N_images} images insérées avec succès ✅")

# ==============================
# 5️⃣ ALBUMS
# ==============================
for _ in range(N):
    titre_album = fake.word()
    description = fake.sentence(nb_words=6)
    date_creation = fake.date_between(start_date='-1y', end_date='today').strftime("%Y-%m-%d")
    visibilite_al = random.choice([0, 1])
    id_utilisateur = random.randint(1, N)

    cur.execute("""
        INSERT INTO ALBUM(idUtilisateur, titre, description, date_creation, visibilite)
        VALUES(:1, :2, :3, TO_DATE(:4, 'YYYY-MM-DD'), :5)
    """, (id_utilisateur, titre_album, description, date_creation, visibilite_al))

print(f"📁 {N} albums insérés avec succès ✅")

# ==============================
# 6️⃣ LIKES
# ==============================
for _ in range(N):
    id_image = random.randint(1, N_images)
    nombre_like = random.randint(0, 5)
    for _ in range(nombre_like):
        date_like = fake.date_between(start_date='-1y', end_date='today').strftime("%Y-%m-%d")
        id_utilisateur = random.randint(1, N)
        try:
            cur.execute("""
                INSERT INTO LIKES(idImage, idUtilisateur, date_like)
                VALUES(:1, :2, TO_DATE(:3, 'YYYY-MM-DD'))
            """, (id_image, id_utilisateur, date_like))
        except oracledb.IntegrityError:
            pass

print(f"❤️ Likes insérés avec succès ✅")

# ==============================
# 7️⃣ COMMENTAIRES
# ==============================
for _ in range(N):
    id_image = random.randint(1, N_images)
    nombre_commente = random.randint(0, 5)
    for _ in range(nombre_commente):
        texte = fake.sentence(nb_words=10)
        id_utilisateur = random.randint(1, N)
        try:
            cur.execute("""
                INSERT INTO COMMENTE(idImage, idUtilisateur, texte)
                VALUES(:1, :2, :3)
            """, (id_image, id_utilisateur, texte))
        except oracledb.IntegrityError:
            pass

print(f"💬 Commentaires insérés avec succès ✅")

# ==============================
# 8️⃣ SON_LABEL
# ==============================
for _ in range(N):
    id_image = random.randint(1, N_images)
    nombre_label = random.randint(0, 5)
    for _ in range(nombre_label):
        id_label = random.randint(1, len(labels_images))
        try:
            cur.execute("""
                INSERT INTO SON_LABEL(idImage, idLabel)
                VALUES(:1, :2)
            """, (id_image, id_label))
        except oracledb.IntegrityError:
            pass

print(f"🏷️  Associations image-label insérées avec succès ✅")

# ==============================
# 9️⃣ PREFERE
# ==============================
for _ in range(N):
    id_utilisateur = random.randint(1, N)
    nb_cat = random.randint(0, 5)
    for _ in range(nb_cat):
        id_categorie = random.randint(1, len(categories))
        try:
            cur.execute("""
                INSERT INTO PREFERE(idUtilisateur, idCategorie)
                VALUES(:1, :2)
            """, (id_utilisateur, id_categorie))
        except oracledb.IntegrityError:
            pass

print(f"⭐ Préférences insérées avec succès ✅")

# ==============================
# 🔟 APPARTIENT
# ==============================
for _ in range(N):
    id_album = random.randint(1, N)
    nb_image = random.randint(0, 5)
    for _ in range(nb_image):
        id_image = random.randint(1, N_images)
        try:
            cur.execute("""
                INSERT INTO APPARTIENT(idAlbum, idImage)
                VALUES(:1, :2)
            """, (id_album, id_image))
        except oracledb.IntegrityError:
            pass

print(f"📸 Relations album-image insérées avec succès ✅")

# ==============================
# 💾 VALIDATION & FERMETURE
# ==============================
conn.commit()
cur.close()
conn.close()

print("\n--- ✅ INSERTION TERMINÉE ---")
print(f"👤 {N} utilisateurs")
print(f"🏷️  {len(categories)} catégories")
print(f"🔖 {len(labels_images)} labels")
print(f"🖼️  {N_images} images")
print(f"📁 {N} albums\n")
print("Toutes les données ont été insérées avec succès et la connexion Oracle a été fermée 🔒")

from faker import Faker
import random
import oracledb
import getpass

fake = Faker('fr_FR')

# Informations de connexion Oracle (à adapter selon ton tnsnames.ora ou ton DSN)
DB_USER = "bahm"
DB_PASS = getpass.getpass("Mot de passe Oracle : ")

# Exemple : service Oracle de l’Université de Strasbourg
# (remplace si ton prof ou ton admin t’a donné un autre service)
dsn = "(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=oracle.unistra.fr)(PORT=1521))(CONNECT_DATA=(SERVICE_NAME=ORCLPDB1)))"

conn = oracledb.connect(user=DB_USER, password=DB_PASS, dsn=dsn)
cur = conn.cursor()

N = 50
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

conn.commit()
cur.close()
conn.close()
print(f"{N} utilisateurs insérés avec succès ✅")

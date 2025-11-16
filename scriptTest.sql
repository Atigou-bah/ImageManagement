-- Fonction formatJson 
SELECT formatJson(1) from dual; 

-- Procédure  Newsletter 

exec NewsletterGene('teste') ; 

SELECT count(*) from newsletter where description = 'teste'; 


-- fonction liste d'image pour un utilisateur 

SELECT listeImage(1) form dual; 

-- Declencheur limite du nombre d'album 

INSERT INTO ALBUM(idUtilisateur, titre, description, date_creation, visibilite)
VALUES(6, 'Harmonie', 'Un album qui explore la sérénité et l’équilibre intérieur.', TO_TIMESTAMP('2025-11-03 10:15:22', 'YYYY-MM-DD HH24:MI:SS'), 1);

INSERT INTO ALBUM(idUtilisateur, titre, description, date_creation, visibilite)
VALUES(6, 'Aventure', 'Capturer l’esprit de l’exploration et des voyages lointains.', TO_TIMESTAMP('2025-11-04 14:42:10', 'YYYY-MM-DD HH24:MI:SS'), 1);

INSERT INTO ALBUM(idUtilisateur, titre, description, date_creation, visibilite)
VALUES(6, 'Souvenirs', 'Un album rempli de moments précieux et de souvenirs familiaux.', TO_TIMESTAMP('2025-11-05 09:05:45', 'YYYY-MM-DD HH24:MI:SS'), 1);

INSERT INTO ALBUM(idUtilisateur, titre, description, date_creation, visibilite)
VALUES(6, 'Nature', 'Beauté et diversité de la nature capturée en images.', TO_TIMESTAMP('2025-11-06 16:30:12', 'YYYY-MM-DD HH24:MI:SS'), 1);

INSERT INTO ALBUM(idUtilisateur, titre, description, date_creation, visibilite)
VALUES(6, 'Créativité', 'Exploration des arts et créations originales.', TO_TIMESTAMP('2025-11-07 11:50:33', 'YYYY-MM-DD HH24:MI:SS'), 1);


--  apres l'insertion de 5 albums de l'utilisateur 6 étant donné il avait déjà d'autre album donc à partir du 6 eme album ca va echouer 

select count(*) from album where idUtilisateur = 6; 


-- archivage automatique lors de la suppression d'une image 

SELECT count(*) from IMAGEARCHIVE where idImage = 1 ; 

exec archiverImage(1);  

SELECT count(*) from IMAGEARCHIVE where idImage = 1 ; 

-- anti spam 

SELECT count(*) from IMAGE where idUtilisateur = 50; 


INSERT INTO IMAGE (idUtilisateur, idCategorie, description, titre, date_publication, format, taille, visibilite, pays, telechargeables)
VALUES (50, 12, 'Silence fragile dans un espace figé.', 'horizon', TO_TIMESTAMP('2025-11-07 02:10:10', 'YYYY-MM-DD HH24:MI:SS'), 'jpg', 2048, 1, 'Qatar', 1);

INSERT INTO IMAGE (idUtilisateur, idCategorie, description, titre, date_publication, format, taille, visibilite, pays, telechargeables)
VALUES (50, 12, 'Un moment suspendu entre ombre et lumière.', 'reflet', TO_TIMESTAMP('2025-11-07 02:10:10', 'YYYY-MM-DD HH24:MI:SS'), 'jpeg', 1750, 1, 'Qatar', 0);

INSERT INTO IMAGE (idUtilisateur, idCategorie, description, titre, date_publication, format, taille, visibilite, pays, telechargeables)
VALUES (50, 12, 'Présence discrète dans un monde en mouvement.', 'murmure', TO_TIMESTAMP('2025-11-07 02:10:10', 'YYYY-MM-DD HH24:MI:SS'), 'png', 1890, 1, 'Qatar', 1);

SELECT count(*) from IMAGE where idUtilisateur = 50; 



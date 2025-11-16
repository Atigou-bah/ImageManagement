-- DROP VIEW categories_populaire;
DROP VIEW image_populaire_recentes;
DROP VIEW pays_like;

-- *********************************************************
-- les categories les plus populaire au moins de 2 likes 
-- **********************************************************


-- CREATE OR REPLACE VIEW categories_populaire AS 
-- SELECT 
--     c.nom AS nom_categorie,
--     COUNT(DISTINCT l.idImage) AS nb_images_likes
-- FROM CATEGORIE c
-- JOIN IMAGE i ON i.IDCATEGORIE = c.IDCATEGORIE
-- JOIN LIKES l ON l.IDIMAGE = i.IDIMAGE
-- GROUP BY c.nom
-- HAVING COUNT(DISTINCT l.IDIMAGE) >= 2;



-- *********************************************************
-- Les images les plus populaires dans la semaine, au moins 5 likes
-- **********************************************************

CREATE OR REPLACE VIEW   image_populaire_recentes AS 
SELECT 
    i.IDIMAGE,
    i.titre AS titre_image,
    i.DESCRIPTION,
    c.idCategorie, 
    c.nom AS categorie,
    COUNT(l.idUtilisateur) AS nb_likes
FROM IMAGE i
JOIN LIKES l ON i.IDIMAGE = l.IDIMAGE
JOIN CATEGORIE c 
ON c.idCategorie = i.idCategorie
WHERE TRUNC(SYSDATE) - TRUNC(i.date_publication) <= 7 
GROUP BY i.IDIMAGE, i.titre, i.DESCRIPTION,c.idCategorie,c.nom
HAVING COUNT(DISTINCT l.idUtilisateur) >= 5;


-- *********************************************************
-- une vue pour avoir les nb de like par pays pour chaque image 
-- **********************************************************

CREATE OR REPLACE VIEW pays_like AS
SELECT
    i.idImage,
    u.pays AS pays_like,-- pour avoir les nb de like par pays pour chaque image 
    COUNT(*) AS nb_likes
FROM IMAGE i
JOIN LIKES l ON i.idImage = l.idImage
JOIN UTILISATEUR u ON l.idUtilisateur = u.idUtilisateur
GROUP BY i.idImage, u.pays
ORDER BY i.idImage, nb_likes DESC;

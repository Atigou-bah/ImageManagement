DROP VIEW categories_populaire
DROP VIEW image_populaire

-- *********************************************************
-- les categories les plus populaire au moins de 2 likes 
-- **********************************************************


CREATE VIEW categories_populaire AS 
SELECT 
    c.nom AS nom_categorie,
    COUNT(DISTINCT l.idImage) AS nb_images_likées
FROM CATEGORIE c
JOIN IMAGE i ON i.IDCATEGORIE = c.IDCATEGORIE
JOIN LIKES l ON l.IDIMAGE = i.IDIMAGE
GROUP BY c.nom
HAVING COUNT(DISTINCT l.IDIMAGE) >= 2;


-- *********************************************************
-- Les images les plus populaires au moins 5 likes  
-- **********************************************************

CREATE VIEW image_populaire AS 

SELECT 
    i.IDIMAGE , i.titre As titre_images,i.DESCRIPTION,
    Count(DISTINCT l.idUtilisateur) AS nb_likes 
FROM image i 
JOIN LIKES l 
ON i.IDIMAGE  = l.IDIMAGE  
GROUP BY i.IDIMAGE , i.titre , i.DESCRIPTION
HAVING Count(DISTINCT l.idUtilisateur) >= 5; 

-- *********************************************************
-- Les images les plus populaires recente sur les 14 derniers jours 
-- **********************************************************

-- CREATE VIEW image_populaire_recentes AS 
-- SELECT 
--     i.IDIMAGE,
--     i.titre AS titre_image,
--     i.DESCRIPTION,
--     COUNT(l.idUtilisateur) AS nb_likes
-- FROM IMAGE i
-- JOIN LIKES l ON i.IDIMAGE = l.IDIMAGE
-- WHERE TRUNC(SYSDATE) - TRUNC(l.date_like) <= 14
-- GROUP BY i.IDIMAGE, i.titre, i.DESCRIPTION
-- HAVING COUNT(DISTINCT l.idUtilisateur) >= 1;





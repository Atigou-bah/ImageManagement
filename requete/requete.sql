-- Le nombre d’images publiées par catégorie au cours des deux dernières
-- semaines.

CREATE INDEX idx_image_datepub 
ON IMAGE(date_publication);

CREATE INDEX idx_image_categorie
 ON IMAGE(idCategorie);

SELECT 
    c.nom, 
    COUNT(i.idImage) AS nb_image
FROM IMAGE i
JOIN CATEGORIE c ON i.idCategorie = c.idCategorie
WHERE TRUNC(SYSDATE) - TRUNC(date_publication) <= 14
GROUP BY c.nom
ORDER BY nb_image DESC;

-- Par utilisateur, le nombre d’albums, d’images publiées, de likes donnés et reçus.

CREATE INDEX idx_album_utilisateur ON ALBUM(idUtilisateur);
CREATE INDEX idx_image_utilisateur ON IMAGE(idUtilisateur);
CREATE INDEX idx_likes_utilisateur ON LIKES(idUtilisateur);
CREATE INDEX idx_likes_image ON LIKES(idImage);

SELECT 
    u.idUtilisateur,
    u.nom,
    (SELECT COUNT(*) FROM ALBUM a WHERE a.idUtilisateur = u.idUtilisateur) AS nb_album,
    (SELECT COUNT(*) FROM IMAGE i WHERE i.idUtilisateur = u.idUtilisateur) AS nb_images,
    (SELECT COUNT(*) FROM LIKES l WHERE l.idUtilisateur = u.idUtilisateur) AS nb_like_donne,
    (SELECT COUNT(*) 
     FROM LIKES l 
     JOIN IMAGE i ON l.idImage = i.idImage
     WHERE i.idUtilisateur = u.idUtilisateur) AS nb_like_recu
FROM UTILISATEUR u;


-- Pour chaque image, le nombre de likes par pays des utilisateurs, la différence
-- entre le pays ayant le plus de likes et celui en ayant le moins, triée par
-- valeur absolue de cette différence.



CREATE OR REPLACE VIEW pays_like_count AS
SELECT
    i.idImage,
    u.pays AS pays_like,
    COUNT(*) AS nb_likes
FROM IMAGE i
JOIN LIKES l ON i.idImage = l.idImage
JOIN UTILISATEUR u ON l.idUtilisateur = u.idUtilisateur
GROUP BY i.idImage, u.pays
ORDER BY i.idImage, nb_likes DESC;

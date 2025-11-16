-- Le nombre d’images publiées par catégorie au cours des deux dernières
-- semaines.

CREATE INDEX idx_image_datepub ON IMAGE(date_publication);

CREATE INDEX idx_image_categorie ON IMAGE(idCategorie);

SELECT 
    c.nom, 
    COUNT(i.idImage) AS nb_image
FROM IMAGE i
JOIN CATEGORIE c ON i.idCategorie = c.idCategorie
WHERE TRUNC(SYSDATE) - TRUNC(i.date_publication) <= 14
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


--Pour cette requête j'ai decidé de definir une vue pour facilité la requêtes ;
-- Pour avoir le resulat demandé on fait juste une requete sur la vue pays_like; 

CREATE INDEX idx_idImage ON IMAGE(idImage);
CREATE INDEX idx_pays ON UTILISATEUR(pays);

SELECT 
    idImage,
    Max(NB_LIKES ) - min(NB_LIKES )  AS difference
FROM pays_like
GROUP BY idImage;



-- Les images qui ont au moins deux fois plus de likes que la moyenne des images
-- de leur catégorie.

CREATE INDEX image_idCategorie_idx ON IMAGE(idCategorie);
CREATE INDEX likes_idImage_idUtilisateur_idx ON LIKES(idImage, idUtilisateur);

SELECT 
    i.idImage,
    i.idCategorie,
    COUNT(l.idImage) AS nb_likes 
FROM 
    image i 
    LEFT JOIN likes l ON l.idImage = i.idImage 
GROUP BY i.idImage, i.idCategorie 
HAVING
    COUNT(l.idImage) >= 2 * ( 
        SELECT 
            AVG(nb_likes) 
        FROM ( 
            SELECT 
                COUNT(*) AS nb_likes 
            FROM 
                IMAGE i2 
                LEFT JOIN LIKES l2 ON l2.idImage = i2.idImage 
            WHERE i2.idCategorie = i.idCategorie 
            GROUP BY i2.idImage 
        )
    );



-- Les 10 couples d'images les plus souvent likées ensemble par un même utilisateur.
SELECT 
    l1.idImage AS image1, 
    l2.idImage AS image2, 
    COUNT(*) AS nb_co_likes 
FROM 
    likes l1 
    JOIN likes l2 ON l1.idUtilisateur = l2.idUtilisateur AND l1.idImage < l2.idImage 
GROUP BY l1.idImage, l2.idImage 
ORDER BY nb_co_likes DESC 
FETCH FIRST 10 ROWS ONLY;




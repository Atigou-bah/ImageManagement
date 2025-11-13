CREATE OR REPLACE FUNCTION formatJson(id Image.idImage%TYPE) 
RETURN CLOB IS

json_o  CLOB; 

BEGIN
    SELECT JSON_OBJECT(
        'idImage' VALUE i.idImage,
        'titre' VALUE i.titre, 
        'Description' VALUE i.description, 
        'Auteur' VALUE u.nom, 
        'Categorie' VALUE c.nom, 
        'Nb_likes' VALUE COUNT(l.idUtilisateur)
        ) 
    into json_o 
    FROM image i 
    JOIN utilisateur u 
    ON u.idUtilisateur = i.idUtilisateur 
    JOIN categorie c 
    ON i.idCategorie = c.idCategorie  
    JOIN likes l 
    ON l.idImage = i.idImage
    WHERE i.idImage = id
    GROUP BY i.idImage, i.titre, i.description, u.nom, c.nom; 


    RETURN json_o; 

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '{"error": "Aucune image trouvée"}';

END; 
/ 


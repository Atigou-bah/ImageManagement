CREATE OR REPLACE FUNCTION formatJson(p_id Image.idImage%TYPE) 
RETURN CLOB 
IS
    json_o CLOB;
BEGIN
    SELECT JSON_OBJECT(
        'idImage'     VALUE i.idImage,
        'titre'       VALUE i.titre, 
        'description' VALUE i.description, 
        'auteur'      VALUE u.nom, 
        'categorie'   VALUE c.nom, 
        'nb_likes'    VALUE COUNT(l.idUtilisateur)
    RETURNING CLOB)

    INTO json_o
    FROM image i
    JOIN utilisateur u ON u.idUtilisateur = i.idUtilisateur
    JOIN categorie c ON c.idCategorie = i.idCategorie
    LEFT JOIN likes l ON l.idImage = i.idImage
    WHERE i.idImage = p_id
    GROUP BY i.idImage, i.titre, i.description, u.nom, c.nom;

    RETURN json_o;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN '{"error": "Aucune image trouvée"}';
END;
/ 

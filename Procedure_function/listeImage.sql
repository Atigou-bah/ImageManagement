CREATE OR REPLACE FUNCTION listeImage(id UTILISATEUR.idUtilisateur%TYPE) 
RETURN CLOB IS

CURSOR curseurCat is (
    SELECT *
    FROM PREFERE 
    WHERE idUtilisateur = id); 

CURSOR curseurIm is (
    SELECT *
    FROM image_populaire_recentes
    ); 

    json_liste CLOB := '{"Images": [';
    premier BOOLEAN := TRUE; 

BEGIN
    FOR courantCat in curseurCat 
    LOOP 
END; 
/
      
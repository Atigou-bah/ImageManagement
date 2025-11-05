CREATE OR REPLACE PROCEDURE archiverImage(id Image.idImage%TYPE) IS
    idImage Image.idImage%TYPE;
    titre   Image.titre%TYPE;
    description Image.description%TYPE;
BEGIN
    DELETE FROM likes WHERE idImage = id;
    DELETE FROM son_label WHERE idImage = id;
    DELETE FROM APPARTIENT WHERE idImage = id; 
    DELETE FROM COMMENTE WHERE idImage = id; 
    DELETE FROM LIKES WHERE idImage = id; 
    DELETE FROM IMAGE WHERE idImage = id;

    SELECT idImage, titre, description
    INTO idImage, titre, description
    FROM IMAGEARCHIVE
    WHERE idImage = id;

    -- Afficher
    DBMS_OUTPUT.PUT_LINE('Image ' || idImage || ' : ' || titre || ' archivée avec succès');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Aucune image trouvée avec l’ID ' || id);
END;
/

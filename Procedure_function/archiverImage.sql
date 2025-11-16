CREATE OR REPLACE PROCEDURE archiverImage(p_id IN Image.idImage%TYPE) IS
    v_test NUMBER := 0;
BEGIN
    -- Vérifier si l'image existe
    SELECT COUNT(*) INTO v_test 
    FROM Image 
    WHERE idImage = p_id;

    IF v_test = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Aucune image trouvée avec l’ID ' || p_id);
    ELSE
        DELETE FROM Image WHERE idImage = p_id;
        DBMS_OUTPUT.PUT_LINE('Image ' || p_id || ' supprimée et archivée (via trigger) avec succès');
    END IF;
END;
/

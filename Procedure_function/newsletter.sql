CREATE OR REPLACE PROCEDURE newsletterGene (
    texte IN NEWSLETTER.description%TYPE
) IS
    CURSOR monCurseur IS
        SELECT *
        FROM image_populaire_recentes
        FETCH FIRST 20 ROWS ONLY;

    json_image CLOB := '{"Images": [';
    premier BOOLEAN := TRUE;
    compteur NUMBER := 0;
BEGIN
    FOR courant IN monCurseur LOOP
        IF NOT premier THEN
            json_image := json_image || ',';
        END IF;

        premier := FALSE;

        json_image := json_image ||
            '{"id": ' || courant.idImage ||
            ', "titre": "' || REPLACE(courant.titre_image, '"', '\"') || '"' ||
            ', "nb_likes": "' || REPLACE(courant.nb_likes, '"', '\"') || '"' ||
            ', "categorie": "' || REPLACE(courant.categorie, '"', '\"') || '"' ||
            '}';

        compteur := compteur + 1;
    END LOOP;

    json_image := json_image || ']}';

    IF compteur != 0 THEN
        INSERT INTO NEWSLETTER(description, image, date_envoi)
        VALUES (texte, json_image, SYSDATE);

        DBMS_OUTPUT.PUT_LINE(
            ' Une newsletter a été ajoutée avec succès avec ' || compteur || ' images.'
        );
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Aucune image récente trouvée.');
    END IF;
END;
/

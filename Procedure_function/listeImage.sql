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
    --image_vu NUMBER := 0; 
    compteur NUMBER := 0; 

BEGIN
    FOR courantCat in curseurCat 
    LOOP 
        FOR courantIm in curseurIm 
        LOOP 
            -- SELECT 
            -- count(*)
            -- into image_vu 
            -- FROM likes l 
            -- where l.idImage = courantIm.idImage AND l.idUtilisateur = id; -- verifier si l'utilisateur à deja like l'image ca sert a rien de lui conseillé l'image 

            IF NOT premier THEN
                json_liste := json_liste || ',';
            END IF;

            premier := FALSE;

            IF courantCat.idCategorie = courantIm.idCategorie --AND image_vu = 0 
                THEN 
                    json_liste := json_liste || 
                    '{"id": ' || courantIm.idImage ||
                    ', "titre": "' || REPLACE(courantIM.titre_image, '"', '\"') || '"' ||
                    ', "nb_likes": "' || REPLACE(courantIm.nb_likes, '"', '\"') || '"' ||
                    ', "categorie": "' || REPLACE(courantIm.categorie, '"', '\"') || '"' ||
                    '}';
                    compteur := compteur + 1 ; 
            END IF; 
        END LOOP; 
    END LOOP; 
    json_liste := json_liste || ']}';
    IF compteur != 0 THEN 
            DBMS_OUTPUT.PUT_LINE(' nombre d image conseillees ' || compteur );
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Aucune image trouvée.');
    END IF;
    RETURN json_liste;
END; 
/
      
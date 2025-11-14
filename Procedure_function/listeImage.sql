CREATE OR REPLACE FUNCTION listeImage(p_id UTILISATEUR.idUtilisateur%TYPE) 
RETURN CLOB IS

    CURSOR curseurCat IS 
        SELECT * 
        FROM PREFERE 
        WHERE idUtilisateur = p_id;

    CURSOR curseurIm IS 
        SELECT * 
        FROM image_populaire_recentes;

    json_liste CLOB := '{"Images": [';
    premier BOOLEAN := TRUE;
    compteur NUMBER := 0;

BEGIN
    FOR courantCat IN curseurCat LOOP
        FOR courantIm IN curseurIm LOOP

            -- Vérifie que l'image correspond à la catégorie préférée
            IF courantCat.idCategorie = courantIm.idCategorie THEN

                -- Ajoute la virgule seulement si ce n'est pas la première image
                IF NOT premier THEN
                    json_liste := json_liste || ',';
                END IF;

                -- Ajout de l'image au JSON
                json_liste := json_liste || 
                    '{"id": ' || courantIm.idImage ||
                    ', "titre": "' || REPLACE(courantIm.titre_image, '"', '\"') || '"' ||
                    ', "nb_likes": "' || courantIm.nb_likes || '"' ||
                    ', "categorie": "' || REPLACE(courantIm.categorie, '"', '\"') || '"' ||
                    '}';

                premier := FALSE;  -- Marque que le premier élément a été ajouté
                compteur := compteur + 1;
            END IF;

        END LOOP;
    END LOOP;

    json_liste := json_liste || ']}';

    IF compteur != 0 THEN
        DBMS_OUTPUT.PUT_LINE('Nombre d images conseillées : ' || compteur);
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Aucune image trouvée.');
    END IF;

    RETURN json_liste;

END;
/

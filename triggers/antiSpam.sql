CREATE OR REPLACE TRIGGER antiSpam
BEFORE INSERT ON IMAGE
FOR EACH ROW
DECLARE
    date_time   DATE;
    idUser      UTILISATEUR.idUtilisateur%TYPE;
    diff_sec    NUMBER;
    x           NUMBER := 5; -- nombre de secondes minimum entre deux insertions
BEGIN
    idUser := :NEW.idUtilisateur;

    SELECT MAX(date_publication)
    INTO date_time
    FROM IMAGE
    WHERE idUtilisateur = idUser;

    IF date_time IS NOT NULL THEN
        diff_sec := (SYSDATE - date_time) * 24 * 60 * 60;

        IF diff_sec < x THEN
            RAISE_APPLICATION_ERROR(-20001,
                'Impossible d''insérer deux images en moins de ' || x || ' secondes');
        END IF;
    END IF;
END;
/

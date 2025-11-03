CREATE OR REPLACE TRIGGER trg_email_format
BEFORE INSERT OR UPDATE ON UTILISATEUR
FOR EACH ROW
BEGIN
  IF NOT REGEXP_LIKE(:NEW.email,
     '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
    RAISE_APPLICATION_ERROR(-20001, 'Format d''email invalide');
  END IF;
END;
/


CREATE OR REPLACE TRIGGER verif_date_publication
BEFORE INSERT ON IMAGE
FOR EACH ROW
BEGIN
    IF TRUNC(:NEW.date_publication) > TRUNC(CURRENT_DATE) THEN
        RAISE_APPLICATION_ERROR(-20001, 'La date de publication doit etre aujourd''hui');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER verif_creation_album
BEFORE INSERT ON ALBUM
FOR EACH ROW
BEGIN
    IF TRUNC(:NEW.date_creation) > TRUNC(CURRENT_DATE) THEN
        RAISE_APPLICATION_ERROR(-20001, 'La date de publication doit etre aujourd''hui');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER verif_date_like
BEFORE INSERT ON LIKES
FOR EACH ROW
BEGIN
    IF :NEW.date_like > TRUNC(SYSDATE) THEN
        RAISE_APPLICATION_ERROR(-20001, 'La date ne peut pas etre dans le futur');
    END IF;
END;
/


CREATE OR REPLACE TRIGGER verif_age_utilisateur
BEFORE INSERT OR UPDATE ON UTILISATEUR
FOR EACH ROW
BEGIN
    IF MONTHS_BETWEEN(SYSDATE, :NEW.date_naissance) / 12 < 18 THEN
        RAISE_APPLICATION_ERROR(-20001, 'L''utilisateur doit avoir au moins 18 ans.');
    END IF;
END;
/



CREATE OR REPLACE TRIGGER nbAlbum  
BEFORE INSERT ON ALBUM 
FOR EACH ROW
DECLARE 
    nb INTEGER := 5; 
    nb_create INTEGER; 
BEGIN 
    -- Compter le nombre d'albums déjà créés par cet utilisateur
    SELECT count(*) 
    INTO nb_create 
    FROM Album 
    WHERE idUtilisateur = :NEW.idUtilisateur;

	IF nb_create >= nb 
		THEN RAISE_APPLICATION_ERROR(-20001, 'nombre maximum d album atteint'); 
	END IF; 
END; 
/ 


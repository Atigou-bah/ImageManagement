CREATE OR REPLACE TRIGGER archiveImage
BEFORE DELETE ON IMAGE
FOR EACH ROW
BEGIN
    -- Insérer dans la table d'archive
    INSERT INTO IMAGEARCHIVE (
        idImage, titre, date_publication, format, taille, visibilite, pays, telechargeables
    )
    VALUES (
        :OLD.idImage, :OLD.titre, :OLD.date_publication, :OLD.format, :OLD.taille, :OLD.visibilite, :OLD.pays, :OLD.telechargeables
    ); 

    -- Afficher un message
    DBMS_OUTPUT.PUT_LINE('IMAGE ' || :OLD.idImage || ' - ' || :OLD.titre || ' ARCHIVEE AVEC SUCCES'); 
END;
/

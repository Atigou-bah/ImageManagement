DROP TABLE APPARTIENT CASCADE CONSTRAINTS;
DROP TABLE SON_LABEL CASCADE CONSTRAINTS;
DROP TABLE PREFERE CASCADE CONSTRAINTS;
DROP TABLE LIKES CASCADE CONSTRAINTS;
DROP TABLE COMMENTE CASCADE CONSTRAINTS;
DROP TABLE ALBUM CASCADE CONSTRAINTS;
DROP TABLE IMAGEARCHIVE CASCADE CONSTRAINTS;
DROP TABLE IMAGE CASCADE CONSTRAINTS;
DROP TABLE LABEL CASCADE CONSTRAINTS;
DROP TABLE CATEGORIE CASCADE CONSTRAINTS;
DROP TABLE UTILISATEUR CASCADE CONSTRAINTS;
DROP TABLE NEWSLETTER CASCADE CONSTRAINTS;

-- *****************************************************************
-- UTILISATEUR 
-- *****************************************************************

CREATE TABLE UTILISATEUR (
    idUtilisateur NUMBER(8)     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    identifiant NVARCHAR2(255)   UNIQUE NOT NULL,
    mdp NVARCHAR2(255)           NOT NULL,
    nom NVARCHAR2(255)           NOT NULL,
    prenom NVARCHAR2(255)        NOT NULL,
    date_naissance DATE         NOT NULL,
    email NVARCHAR2(255)         UNIQUE NOT NULL,
    pays NVARCHAR2(255)          NOT NULL,
    abonne_newsletter NUMBER(1) DEFAULT 0 CHECK (abonne_newsletter IN (0, 1)),
    CONSTRAINT mdf_contraint CHECK (LENGTH(mdp) >= 8)
);

-- *****************************************************************
-- CATEGORIE  
-- *****************************************************************

CREATE TABLE CATEGORIE (
    idCategorie NUMBER(8)   GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom NVARCHAR2(255)       UNIQUE NOT NULL
);

-- *****************************************************************
-- LABEL 
-- *****************************************************************

CREATE TABLE LABEL (
    idLabel NUMBER(8)       GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom NVARCHAR2(255)       UNIQUE NOT NULL
);

-- *****************************************************************
-- IMAGE 
-- *****************************************************************

CREATE TABLE IMAGE (
    idImage NUMBER(8)           GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    idUtilisateur NUMBER(8),
    idCategorie NUMBER(8),
    description NVARCHAR2(255),
    titre NVARCHAR2(255)         NOT NULL,
    date_publication DATE       NOT NULL,
    format NVARCHAR2(10)         NOT NULL,
    taille NUMBER(8)            NOT NULL CHECK(taille > 0),
    visibilite NUMBER(1) DEFAULT 0 CHECK (visibilite IN (0,1)),
    pays NVARCHAR2(255),
    telechargeables NUMBER(1) DEFAULT 0 CHECK (telechargeables IN (0,1)),
    CONSTRAINT fk_idutilisateur FOREIGN KEY (idUtilisateur)
        REFERENCES UTILISATEUR(idUtilisateur) ON DELETE CASCADE,
    CONSTRAINT fk_idcategorie FOREIGN KEY (idCategorie)
        REFERENCES CATEGORIE(idCategorie)
);

-- *****************************************************************
-- IMAGEARCHIVE 
-- *****************************************************************

CREATE TABLE IMAGEARCHIVE (
    idImage NUMBER(8),
    titre NVARCHAR2(255)         NOT NULL,
    description NVARCHAR2(255),
    date_publication DATE       NOT NULL,
    format NVARCHAR2(10)         NOT NULL,
    taille NUMBER(8)            NOT NULL CHECK(taille > 0),
    visibilite NUMBER(1) DEFAULT 0 CHECK (visibilite IN (0,1)),
    pays NVARCHAR2(255),
    telechargeables NUMBER(1) DEFAULT 0 CHECK (telechargeables IN (0,1))
);

-- *****************************************************************
-- ALBUM  
-- *****************************************************************

CREATE TABLE ALBUM (
    idAlbum NUMBER(8)           GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    idUtilisateur NUMBER(8)     NOT NULL,
    titre NVARCHAR2(255)         NOT NULL,
    description NVARCHAR2(255),
    date_creation DATE          NOT NULL,
    visibilite NUMBER(1) DEFAULT 0 CHECK (visibilite IN (0,1)),
    CONSTRAINT fk_idutilisateur_album FOREIGN KEY (idUtilisateur)
        REFERENCES UTILISATEUR(idUtilisateur) ON DELETE CASCADE
);

-- *****************************************************************
-- LIKES 
-- *****************************************************************

CREATE TABLE LIKES (
    idImage NUMBER(8),
    idUtilisateur NUMBER(8),
    date_like DATE              NOT NULL,
    CONSTRAINT pk_likes PRIMARY KEY(idImage, idUtilisateur),
    CONSTRAINT fk_likes_image FOREIGN KEY (idImage)
        REFERENCES IMAGE(idImage) ON DELETE CASCADE,
    CONSTRAINT fk_likes_utilisateur FOREIGN KEY (idUtilisateur)
        REFERENCES UTILISATEUR(idUtilisateur) ON DELETE CASCADE
);

-- *****************************************************************
-- COMMENTE 
-- *****************************************************************

CREATE TABLE COMMENTE (
    idImage NUMBER(8),
    idUtilisateur NUMBER(8),
    texte NVARCHAR2(255)         NOT NULL,
    CONSTRAINT pk_comment PRIMARY KEY(idImage, idUtilisateur),
    CONSTRAINT fk_comment_image FOREIGN KEY (idImage)
        REFERENCES IMAGE(idImage) ON DELETE CASCADE,
    CONSTRAINT fk_comment_utilisateur FOREIGN KEY (idUtilisateur)
        REFERENCES UTILISATEUR(idUtilisateur) ON DELETE CASCADE
);

-- *****************************************************************
-- SON_LABEL 
-- *****************************************************************

CREATE TABLE SON_LABEL (
    idImage NUMBER(8),
    idLabel NUMBER(8),
    CONSTRAINT pk_son_label PRIMARY KEY(idImage, idLabel),
    CONSTRAINT fk_son_label_image FOREIGN KEY (idImage)
        REFERENCES IMAGE(idImage) ON DELETE CASCADE,
    CONSTRAINT fk_son_label_label FOREIGN KEY (idLabel)
        REFERENCES LABEL(idLabel) ON DELETE CASCADE
);

-- *****************************************************************
-- PREFERE   
-- *****************************************************************

CREATE TABLE PREFERE (
    idUtilisateur NUMBER(8),
    idCategorie NUMBER(8),
    CONSTRAINT pk_prefere PRIMARY KEY (idUtilisateur, idCategorie),
    CONSTRAINT fk_prefere_utilisateur FOREIGN KEY (idUtilisateur)
        REFERENCES UTILISATEUR(idUtilisateur) ON DELETE CASCADE,
    CONSTRAINT fk_prefere_categorie FOREIGN KEY (idCategorie)
        REFERENCES CATEGORIE(idCategorie) ON DELETE CASCADE
);

-- *****************************************************************
-- APPARTIENT  
-- *****************************************************************

CREATE TABLE APPARTIENT (
    idAlbum NUMBER(8),
    idImage NUMBER(8),
    CONSTRAINT pk_appartient PRIMARY KEY (idAlbum, idImage),
    CONSTRAINT fk_appartient_album FOREIGN KEY (idAlbum)
        REFERENCES ALBUM(idAlbum) ON DELETE CASCADE,
    CONSTRAINT fk_appartient_image FOREIGN KEY (idImage)
        REFERENCES IMAGE(idImage) ON DELETE CASCADE
);


-- *****************************************************************
-- Newsletter   
-- ***************************************************************** 
CREATE TABLE NEWSLETTER(
    idNewsletter NUMBER(8)           GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    description NVARCHAR2(255),
    image CLOB NOT NULL, 
    date_envoi date DEFAULT SYSDATE
    ); 
DROP TABLE ALBUM;
DROP TABLE UTILISATEUR;
DROP TABLE CATEGORIE;
DROP TABLE IMAGE;
DROP TABLE IMAGEARCHIVE;
DROP TABLE LABEL;
DROP TABLE COMMENTE;
DROP TABLE LIKES ;
DROP TABLE PREFERE;
DROP TABLE SON_LABEL; 
DROP TABLE APPARTIENT; 

CREATE TABLE UTILISATEUR (
    idUtilisateur NUMBER(8) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    identifiant VARCHAR2(255) UNIQUE NOT NULL,
    mdp VARCHAR2(255) NOT NULL,
    nom VARCHAR2(255) NOT NULL,
    prenom VARCHAR2(255) NOT NULL,
    date_naissance DATE NOT NULL,
    email VARCHAR2(255) UNIQUE NOT NULL,
    pays VARCHAR2(255) NOT NULL,
    abonne_newsletter NUMBER(1) DEFAULT 0 CHECK (abonne_newsletter IN (0, 1)),
    CONSTRAINT mdf_contraint CHECK (LENGTH(mdp) >= 8)
);


CREATE TABLE CATEGORIE (
    idCategorie NUMBER(8) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom VARCHAR2(255) UNIQUE NOT NULL
);

CREATE TABLE LABEL (
    idLabel NUMBER(8) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nom VARCHAR2(255) UNIQUE NOT NULL
);



CREATE TABLE IMAGE (
    idImage NUMBER(8) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    idUtilisateur NUMBER(8),
    idCategorie NUMBER(8),
    titre VARCHAR2(255) NOT NULL,
    date_publication DATE NOT NULL,
    format VARCHAR2(10) NOT NULL,
    taille NUMBER(8) NOT NULL,
    visibilite NUMBER(1) DEFAULT 0 CHECK (visibilite IN (0,1)),
    pays VARCHAR2(255),
    telechargeables NUMBER(1) DEFAULT 0 CHECK (telechargeables IN (0,1)),
    CONSTRAINT fk_idutilisateur FOREIGN KEY (idUtilisateur) REFERENCES UTILISATEUR(idUtilisateur),
    CONSTRAINT fk_idcategorie FOREIGN KEY (idCategorie) REFERENCES CATEGORIE(idCategorie)
);


CREATE TABLE IMAGEARCHIVER (
    idImage NUMBER(8),
    titre VARCHAR2(255) NOT NULL,
    date_publication DATE NOT NULL,
    format VARCHAR2(10) NOT NULL,
    taille NUMBER(8) NOT NULL,
    visibilite NUMBER(1) DEFAULT 0 CHECK (visibilite IN (0,1)),
    pays VARCHAR2(255),
    telechargeables NUMBER(1) DEFAULT 0 CHECK (telechargeables IN (0,1))
);


CREATE TABLE ALBUM (
    idAlbum NUMBER(8) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    idUtilisateur NUMBER(8) NOT NULL,
    titre VARCHAR2(255) NOT NULL,
    description VARCHAR2(255),
    date_creation DATE NOT NULL,
    visibilite NUMBER(1) DEFAULT 0 CHECK (visibilite IN (0,1)),
    CONSTRAINT fk_idutilisateur_album FOREIGN KEY (idUtilisateur) REFERENCES UTILISATEUR(idUtilisateur)
);



CREATE TABLE LIKES (
    idImage NUMBER(8),
    idUtilisateur NUMBER(8),
    date_like DATE NOT NULL,
    CONSTRAINT pk_likes PRIMARY KEY(idImage, idUtilisateur),
    CONSTRAINT fk_likes_image FOREIGN KEY (idImage) REFERENCES IMAGE(idImage),
    CONSTRAINT fk_likes_utilisateur FOREIGN KEY (idUtilisateur) REFERENCES UTILISATEUR(idUtilisateur)
);

CREATE TABLE COMMENTE (
    idImage NUMBER(8),
    idUtilisateur NUMBER(8),
    texte VARCHAR2(255) NOT NULL,
    CONSTRAINT pk_comment PRIMARY KEY(idImage, idUtilisateur),
    CONSTRAINT fk_comment_image FOREIGN KEY (idImage) REFERENCES IMAGE(idImage),
    CONSTRAINT fk_comment_utilisateur FOREIGN KEY (idUtilisateur) REFERENCES UTILISATEUR(idUtilisateur)
);

CREATE TABLE SON_LABEL (
    idImage NUMBER(8),
    idLabel NUMBER(8),
    CONSTRAINT pk_son_label PRIMARY KEY(idImage, idLabel),
    CONSTRAINT fk_son_label_image FOREIGN KEY (idImage) REFERENCES IMAGE(idImage),
    CONSTRAINT fk_son_label_label FOREIGN KEY (idLabel) REFERENCES LABEL(idLabel)
);

CREATE TABLE PREFERE (
    idUtilisateur NUMBER(8),
    idCategorie NUMBER(8),
    CONSTRAINT pk_prefere PRIMARY KEY (idUtilisateur, idCategorie),
    CONSTRAINT fk_prefere_utilisateur FOREIGN KEY (idUtilisateur) REFERENCES UTILISATEUR(idUtilisateur),
    CONSTRAINT fk_prefere_categorie FOREIGN KEY (idCategorie) REFERENCES CATEGORIE(idCategorie)
);

CREATE TABLE APPARTIENT (
    idAlbum NUMBER(8),
    idImage NUMBER(8),
    CONSTRAINT pk_appartient PRIMARY KEY (idAlbum, idImage),
    CONSTRAINT fk_appartient_album FOREIGN KEY (idAlbum) REFERENCES ALBUM(idAlbum),
    CONSTRAINT fk_appartient_image FOREIGN KEY (idImage) REFERENCES IMAGE(idImage)
);







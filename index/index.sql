CREATE INDEX idx_image_datepub ON IMAGE(date_publication);

CREATE INDEX idx_image_categorie ON IMAGE(idCategorie);

CREATE INDEX idx_album_utilisateur ON ALBUM(idUtilisateur);

CREATE INDEX idx_image_utilisateur ON IMAGE(idUtilisateur);

CREATE INDEX idx_likes_utilisateur ON LIKES(idUtilisateur);

CREATE INDEX idx_likes_image ON LIKES(idImage);

CREATE INDEX idx_idImage ON IMAGE(idImage);

CREATE INDEX idx_pays ON UTILISATEUR(pays);

CREATE INDEX image_idCategorie_idx ON IMAGE(idCategorie);

CREATE INDEX likes_idImage_idUtilisateur_idx ON LIKES(idImage, idUtilisateur);

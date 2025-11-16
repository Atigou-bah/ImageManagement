
## Modèle relationnel 
- **UTILISATEUR**( <u>idUtilisateur</u> : Integer, identifiant : String, mdp : String, nom: String, prenom : String, date_naissance : Date,email : String, pays : String, abonne_newsletter : Bool ).

- **IMAGE**( <u>idImage</u> : Integer, #idUtilisateur : Integer, #idCategorie : Integer titre : String, description : String, date_publication :  Date, format : String, taille : Integer, visibilite : Boolean, pays_origine : String, telechargeable : Boolean ).

- **ALBUM**( <u>idAlbum</u> : Integer, #idUtilisateur : integer, titre : String, description : String, date_creation : Date, visibilite : Boolean ).

- **LABEL** ( <u>idLabel</u> : Integer, nom : String ).
- **CATEGORIE** ( <u>idCategorie</u> : Integer, nom : String ).


- **IMAGEARCHIVE**( <u>idImage</u> : Integer, #idUtilisateur : Integer, #idCategorie : Integer titre : String, description : String, date_publication :  Date, format : String, taille : Integer, visibilite : Boolean, pays_origine : String, telechargeable : Boolean).

- **Newsletter**(<u>idNewsletter</u> : integer, description : string , Image : JSON, Date_envoi: Date). 

- **PREFERE** ( #idUtilisateur, #idCategorie )
- **DETIENT** ( #idUtilisateur, #idAlbum )
- **REPERTORIER** ( #idCategorie, #idImage )
- **POST** ( #idUtilisateur, #idImage )
- **COMMENTE** ( #idUtilisateur, #idImage, texte : String )
- **LIKES** ( #idUtilisateur, #idImage, date : Date )
- **SON_LABEL** ( #idImage, #idLabel )
- **APPARTIENT** ( #idAlbum, #idImage )



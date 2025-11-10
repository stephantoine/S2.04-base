DROP SCHEMA IF EXISTS colleges CASCADE;
CREATE SCHEMA colleges;
SET SCHEMA 'colleges';

CREATE TABLE _region(
  code_region       varchar(2),
  libelle_region    varchar(34)  NOT NULL,
  CONSTRAINT region_pk PRIMARY KEY(code_region),
  UNIQUE(libelle_region)
);
  
CREATE TABLE _departement(
  code_du_departement   varchar(3),
  nom_departement       varchar(23)  NOT NULL,
  code_region           varchar(2)  NOT NULL,
  CONSTRAINT departement_pk PRIMARY KEY(code_du_departement),
  UNIQUE(nom_departement),
  CONSTRAINT inclut_fk FOREIGN KEY(code_region) REFERENCES _region(code_region)
);


CREATE TABLE _commune(
  code_insee_de_la_commune  varchar(5),
  nom_de_la_commune         varchar(45)  NOT NULL,
  code_du_departement       varchar(3)   NOT NULL,
  CONSTRAINT commune_pk PRIMARY KEY(code_insee_de_la_commune),
  UNIQUE(nom_de_la_commune),
  CONSTRAINT se_situe_fk FOREIGN KEY(code_du_departement) REFERENCES _departement(code_du_departement)
);


CREATE TABLE _quartier_prioritaire(
  code_quartier_prioritaire   varchar(8),
  nom_quartier_prioritaire    varchar(85)  NOT NULL,
  CONSTRAINT quartier_prioritaire_pk PRIMARY KEY(code_quartier_prioritaire)
);


CREATE TABLE _type(
  code_nature     varchar(3),
  libelle_nature  varchar(39),
  CONSTRAINT type_pk PRIMARY KEY(code_nature, libelle_nature)
);


CREATE TABLE _academie(
  code_academie   numeric(2),
  lib_academie    varchar(16)  NOT NULL,
  CONSTRAINT academie_pk PRIMARY KEY(code_academie),
  UNIQUE(lib_academie)
);


CREATE TABLE _etablissement(
  uai VARCHAR(8) PRIMARY KEY,
  nom_etablissement VARCHAR(108) NOT NULL,
  secteur VARCHAR(6) NOT NULL,
  code_postal VARCHAR(5) NOT NULL,
  lattitude REAL NOT NULL,
  longitude REAL NOT NULL,
  code_nature VARCHAR(3) NOT NULL,
  libelle_nature  VARCHAR(39) NOT NULL,
  code_insee_de_la_commune VARCHAR(5) NOT NULL,
  code_academie NUMERIC(2) NOT NULL,
  CONSTRAINT depend_de_fk FOREIGN KEY(code_academie) REFERENCES _academie(code_academie),
  CONSTRAINT est_localise_dans_fk FOREIGN KEY(code_insee_de_la_commune) REFERENCES _commune(code_insee_de_la_commune),
  CONSTRAINT est_type_de_fk FOREIGN KEY(code_nature, libelle_nature) REFERENCES _type(code_nature, libelle_nature)
);

  
CREATE TABLE _est_a_proximite_de(
  code_quartier_prioritaire varchar(8)  NOT NULL,
  uai varchar(8)  NOT NULL,
  CONSTRAINT est_a_proximite_de_fk1 FOREIGN KEY(code_quartier_prioritaire) REFERENCES _quartier_prioritaire(code_quartier_prioritaire),
  CONSTRAINT est_a_proximite_de_fk2 FOREIGN KEY(uai) REFERENCES _etablissement(uai)
);


CREATE TABLE _annee(
  annee_scolaire VARCHAR(9) PRIMARY KEY);
 
CREATE TABLE _caracteristiques_tout_etablissement(
  uai VARCHAR(8),
  annee_scolaire VARCHAR(9),
  effectifs NUMERIC(5) NOT NULL,
  ips REAL NOT NULL,
  ecart_type_de_l_ips REAL NOT NULL,
  ep VARCHAR(7) NOT NULL,
  CONSTRAINT caracteristiques_tout_etablissement_pk PRIMARY KEY (uai, annee_scolaire),
  CONSTRAINT caracteristiques_tout_etablissement_fk1 FOREIGN KEY (uai) REFERENCES _etablissement(uai),
  CONSTRAINT caracteristiques_tout_etablissement_fk2 FOREIGN KEY (annee_scolaire) REFERENCES _annee(annee_scolaire)
);

CREATE TABLE _caracteristiques_college(
  uai VARCHAR(8),
  annee_scolaire VARCHAR(9),
  nbre_eleves_hors_segpa_hors_uils INTEGER,
  nbre_eleve_segpa INTEGER,
  nbre_eleve_ulis INTEGER,
  CONSTRAINT caracteristiques_college_pk PRIMARY KEY (uai, annee_scolaire),
  CONSTRAINT caracteristiques_college_fk1 FOREIGN KEY (uai) REFERENCES _etablissement(uai),
  CONSTRAINT caracteristiques_college_fk2 FOREIGN KEY (annee_scolaire) REFERENCES _annee(annee_scolaire)
);
  


CREATE TABLE _classe(
  id_classe VARCHAR(4) PRIMARY KEY);
  
CREATE TABLE _caracteristiques_selon_classe(
  uai VARCHAR(8),
  id_classe VARCHAR(4),
  annee_scolaire VARCHAR(9),
  nbre_eleves_hors_segpa_hors_uils_selon_niveau INTEGER NOT NULL,
  nbre_eleves_segpa_selon_niveau INTEGER NOT NULL,
  nbre_eleves_ulis_selon_niveau INTEGER NOT NULL,
  effectif_filles INTEGER NOT NULL,
  effectif_garçons INTEGER NOT NULL,
  CONSTRAINT caracteristiques_selon_classe_pk PRIMARY KEY(uai, id_classe, annee_scolaire),
  CONSTRAINT caracteristiques_selon_classe_fk1 FOREIGN KEY (uai) REFERENCES _etablissement(uai),
  CONSTRAINT caracteristiques_selon_classe_fk2 FOREIGN KEY (annee_scolaire) REFERENCES _annee(annee_scolaire),
  CONSTRAINT caracteristiques_selon_classe_fk3 FOREIGN KEY (id_classe) REFERENCES _classe(id_classe)
);

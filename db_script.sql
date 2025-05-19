CREATE SEQUENCE seq_meteos;
CREATE SEQUENCE seq_pays;
CREATE SEQUENCE seq_stationmeteos;

CREATE TABLE Meteos (
  num           number(9) DEFAULT seq_meteos.nextval NOT NULL, 
  sta_avoir_num number(9) NOT NULL, 
  dateMesure    timestamp(0) NOT NULL, 
  temperature   number(10) NOT NULL, 
  description   varchar2(2000) NOT NULL, 
  pression      number(10) NOT NULL, 
  humidite      number(10, 2) NOT NULL, 
  visibilite    number(10) NOT NULL, 
  precipitation number(10, 2) NOT NULL, 
  CONSTRAINT PK_met 
    PRIMARY KEY (num), 
  CONSTRAINT NID1_met_dateMesure 
    UNIQUE (sta_avoir_num, dateMesure), 
  CONSTRAINT met_num_DATATYPE 
    CHECK ((num>0)));

CREATE TABLE Pays (
  num  number(9) DEFAULT seq_pays.nextval NOT NULL, 
  code varchar2(10) NOT NULL, 
  nom  varchar2(50) NOT NULL, 
  CONSTRAINT PK_pay 
    PRIMARY KEY (num), 
  CONSTRAINT NID1_pay_code 
    UNIQUE (code), 
  CONSTRAINT NID2_pay_nom 
    UNIQUE (nom), 
  CONSTRAINT pay_num_DATATYPE 
    CHECK ((num>0)));

CREATE TABLE StationMeteos (
  num            number(9) DEFAULT seq_stationmeteos.nextval NOT NULL, 
  pay_situer_num number(9) NOT NULL, 
  owm_id         number(10) NOT NULL, 
  latitude       number(10, 2) NOT NULL, 
  longitude      number(10, 2) NOT NULL, 
  nom            varchar2(50), 
  CONSTRAINT PK_sta 
    PRIMARY KEY (num), 
  CONSTRAINT NID1_sta_owm_id 
    UNIQUE (owm_id), 
  CONSTRAINT sta_num_DATATYPE 
    CHECK ((num>0)));

CREATE INDEX FK1_met_sta_avoir 
  ON Meteos (sta_avoir_num);

CREATE INDEX FK1_sta_pay_situer 
  ON StationMeteos (pay_situer_num);

ALTER TABLE Meteos ADD CONSTRAINT FK1_met_sta_avoir FOREIGN KEY (sta_avoir_num) REFERENCES StationMeteos (num);
ALTER TABLE StationMeteos ADD CONSTRAINT FK1_sta_pay_situer FOREIGN KEY (pay_situer_num) REFERENCES Pays (num);


USE IB150031

GO


--1.Nad bazom podataka kreirati dvije �eme: Osobe i Ispiti.

CREATE SCHEMA Osobe
GO

CREATE SCHEMA Ispiti
GO

/*
2.Tabele Kandidati i Komisija pridru�iti �emi Osobe, a tabele Testovi i RezultatiTesta pridru�iti �emi Ispiti.
 Tako�er, view kreiran u vje�bi 9 (zadatak 5) pridru�iti �emi Ispiti.*/

ALTER SCHEMA Osobe TRANSFER [dbo].[Komisija]
GO


ALTER SCHEMA Osobe TRANSFER [dbo].[Kandidati]
GO

ALTER SCHEMA Ispiti TRANSFER [dbo].[RezultatiTesta]
GO

ALTER SCHEMA Ispiti TRANSFER [dbo].[Testovi]
GO

ALTER SCHEMA Ispiti TRANSFER [dbo].[Pogled]
GO

/*
3.Sve stored procedure kreirane u vje�bi 9 pridru�iti odgovaraju�im �emama, 
a u zavisnosti od �eme kojoj pripada tabela nad kojom se procedura izvr�ava.*/

CREATE SCHEMA Pra�enje
GO


ALTER SCHEMA Pra�enje TRANSFER [dbo].[usp_AuditingInsert]
GO

ALTER SCHEMA Osobe TRANSFER [dbo].Unos_Kandidata_Testa
GO

ALTER SCHEMA Osobe TRANSFER [dbo].usp_brisanje_kandidata
GO

ALTER SCHEMA Osobe TRANSFER [dbo].usp_dodaj_kandidata
GO

ALTER SCHEMA Osobe TRANSFER [dbo].usp_izmjeni_kandidata
GO

ALTER SCHEMA Ispiti TRANSFER [dbo].usp_brisanje_testa
GO

--ALTER SCHEMA Ispiti TRANSFER [dbo].[usp_RezultatiTesta_insert]
--GO

--ALTER SCHEMA Ispiti TRANSFER [dbo].[usp_RezultatiTesta_update]
--GO

--aLTER SCHEMA Ispiti TRANSFER [dbo].[usp_Test_DELETE]
--GO

ALTER SCHEMA Ispiti TRANSFER [dbo].usp_PrikazNaOsnovuParametara
GO


/*
4. Kreirati novi SQL Server login te mu kao default bazu podataka postaviti bazu podataka kreiranu u vje�bi 7.*/

USE master
GO

CREATE LOGIN Student 
WITH PASSWORD='enter583',
DEFAULT_DATABASE=IB150031,
CHECK_EXPIRATION=OFF
GO


CREATE LOGIN ProbniStudent
WITH PASSWORD='P@SSWORT',
DEFAULT_DATABASE=IB150031,
CHECK_EXPIRATION=OFF

USE IB150031
GO

/*
5.Nad bazom podataka kreirati novog korisnika, mapirati ga 
sa prethodno kreiranim loginom te mu kao default �emu postaviti �emu Ispiti.*/
CREATE USER Emir FOR LOGIN Student
WITH DEFAULT_SCHEMA=Ispiti
GO

/*
6.Prethodno kreiranom korisniku dozvoliti �itanje podataka i izvr�avanje procedura nad �emom Ispiti.
 Primjenom objekata kreiranih u prethodnim vje�bama testirati dodijeljene permisije!*/
GRANT SELECT,EXECUTE ON SCHEMA::[Ispiti] TO Emir
GO

CREATE USER Armin FOR LOGIN ProbniStudent
WITH DEFAULT_SCHEMA=Ispiti
GO


ALTER ROLE db_datareader ADD MEMBER Armin
GO

ALTER ROLE db_datareader ADD MEMBER Edo
GO

ALTER ROLE db_denydatareader ADD MEMBER Armin
GO


REVOKE EXECUTE ON SCHEMA::[Ispiti] TO Edo
GO

GRANT EXECUTE ON SCHEMA::Ispiti TO Edo
GO

/*
7.Kreirati view koji vra�a podatke o svim osobama u bazi podataka (kandidati i �lanovi komisije) 
i to: ime, prezime, telefon i email, te ga dodijeliti �emi Osobe.*/

CREATE VIEW vOsobe
AS
SELECT K.Ime,K.Prezime,K.Telefon,K.Email
FROM [Osobe].[Kandidati] AS K
UNION
SELECT Ko.Ime,Ko.Prezime,Ko.Telefon,Ko.Email
FROM [Osobe].[Komisija] AS Ko
GO

ALTER SCHEMA Osobe TRANSFER vOsobe
GO


/*
8.Kreiranom korisniku dozvoliti �itanje podataka o osobama isklju�ivo putem view-a.
 Testirati dodijeljene permisije!*/

GRANT SELECT ON OBJECT::[Osobe].[vOsobe] TO Edo
GO
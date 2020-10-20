USE IB150031

GO


--1.Nad bazom podataka kreirati dvije šeme: Osobe i Ispiti.

CREATE SCHEMA Osobe
GO

CREATE SCHEMA Ispiti
GO

/*
2.Tabele Kandidati i Komisija pridružiti šemi Osobe, a tabele Testovi i RezultatiTesta pridružiti šemi Ispiti.
 Takoðer, view kreiran u vježbi 9 (zadatak 5) pridružiti šemi Ispiti.*/

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
3.Sve stored procedure kreirane u vježbi 9 pridružiti odgovarajuæim šemama, 
a u zavisnosti od šeme kojoj pripada tabela nad kojom se procedura izvršava.*/

CREATE SCHEMA Praæenje
GO


ALTER SCHEMA Praæenje TRANSFER [dbo].[usp_AuditingInsert]
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
4. Kreirati novi SQL Server login te mu kao default bazu podataka postaviti bazu podataka kreiranu u vježbi 7.*/

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
sa prethodno kreiranim loginom te mu kao default šemu postaviti šemu Ispiti.*/
CREATE USER Emir FOR LOGIN Student
WITH DEFAULT_SCHEMA=Ispiti
GO

/*
6.Prethodno kreiranom korisniku dozvoliti èitanje podataka i izvršavanje procedura nad šemom Ispiti.
 Primjenom objekata kreiranih u prethodnim vježbama testirati dodijeljene permisije!*/
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
7.Kreirati view koji vraæa podatke o svim osobama u bazi podataka (kandidati i èlanovi komisije) 
i to: ime, prezime, telefon i email, te ga dodijeliti šemi Osobe.*/

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
8.Kreiranom korisniku dozvoliti èitanje podataka o osobama iskljuèivo putem view-a.
 Testirati dodijeljene permisije!*/

GRANT SELECT ON OBJECT::[Osobe].[vOsobe] TO Edo
GO
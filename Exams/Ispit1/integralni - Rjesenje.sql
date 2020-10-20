
--1

CREATE DATABASE Integralni
GO

USE Integralni
GO

CREATE TABLE Studenti
(
	StudentID INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_Studenti PRIMARY KEY,
	BrojDosijea NVARCHAR(10) NOT NULL CONSTRAINT UQ_BrojDosijea UNIQUE,
	Ime NVARCHAR(35) NOT NULL,
	Prezime NVARCHAR(35) NOT NULL,
	GodinaStudija TINYINT NOT NULL,
	NacinStudiranja NVARCHAR(10) NOT NULL DEFAULT 'Redovan',
	Email NVARCHAR(50) NULL
)
GO

CREATE TABLE Predmeti
(
	PredmetID INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_Predmeti PRIMARY KEY,
	Naziv NVARCHAR(100) NOT NULL,
	Oznaka NVARCHAR(10) NOT NULL CONSTRAINT UQ_OznakaPredmeta UNIQUE
)
GO

CREATE TABLE Ocjene
(
	PredmetID INT NOT NULL CONSTRAINT FK_Ocjene_Predmeti FOREIGN KEY REFERENCES Predmeti(PredmetID),
	StudentID INT NOT NULL CONSTRAInt FK_Ocjene_Studenti FOREIGN KEY REFERENCES Studenti(StudentID),
	Ocjena TINYINT NOT NULL,
	Bodovi DECIMAL(18,2) NOT NULL,
	DatumPolaganja DATETIME NOT NULL
)
GO
  
-- 2
--a)

INSERT INTO Predmeti (Naziv, Oznaka)
VALUES	('Programiranje III', 'PRIII'),
		('Baze podataka II', 'BPII'),
		('Analiza i dizajn softvera', 'ADS')


SELECT * FROM Predmeti


--b)

USE AdventureWorks2014
GO

INSERT INTO Integralni.dbo.Studenti (BrojDosijea, Ime, Prezime, GodinaStudija, Email)
SELECT	TOP 10
		T1.AccountNumber AS BrojDosijea,
		T2.FirstName AS Ime,
		T2.LastName AS Prezime,
		2 AS GodinaStudija,
		T3.EmailAddress AS Email
FROM	Sales.Customer AS T1
	INNER JOIN Person.Person AS T2 ON T1.PersonID = T2.BusinessEntityID
	INNER JOIN Person.EmailAddress AS T3 ON T2.BusinessEntityID = T3.BusinessEntityID
ORDER BY NEWID()
GO

USE Integralni
GO

SELECT * FROM Studenti
GO

/*
3. Kreirati uskladištenu proceduru koja æe vršiti 
upis podataka u tabelu Ocjene (sva polja). 
Provjerom ispravnosti procedure unijeti 
minimalno 5 zapisa u tabelu Ocjene.
*/

CREATE PROCEDURE usp_EvidantirajOcjenu
(
	@PredmetID INT,
	@StudentID INT,
	@Ocjena TINYINT,
	@Bodovi DECIMAL(18,2),
	@DatumPolaganja DATETIME
)
AS
BEGIN
	INSERT INTO Ocjene (PredmetID, StudentID, Ocjena, Bodovi, DatumPolaganja)
	VALUES	(@PredmetID, @StudentID, @Ocjena, @Bodovi, @DatumPolaganja)
END
GO


EXEC usp_EvidantirajOcjenu	@PredmetID = 1,
							@StudentID = 2,
							@Ocjena = 6,
							@Bodovi = 60,
							@DatumPolaganja = '09.12.2015'
GO


EXEC usp_EvidantirajOcjenu	@PredmetID = 1,
							@StudentID = 5,
							@Ocjena = 5,
							@Bodovi = 20,
							@DatumPolaganja = '07.12.2015'
GO


EXEC usp_EvidantirajOcjenu	@PredmetID = 2,
							@StudentID = 1,
							@Ocjena = 9,
							@Bodovi = 86,
							@DatumPolaganja = '09.14.2015'
GO


EXEC usp_EvidantirajOcjenu	@PredmetID = 2,
							@StudentID = 9,
							@Ocjena = 7,
							@Bodovi = 66,
							@DatumPolaganja = '05.12.2015'
GO


EXEC usp_EvidantirajOcjenu	@PredmetID = 3,
							@StudentID = 1,
							@Ocjena = 8,
							@Bodovi = 81,
							@DatumPolaganja = '03.12.2015'
GO

SELECT * FROM Ocjene
GO

/*
4. Takoðer, u svoju bazu podataka putem Import/Export alata prebaciti sljedeæe tabele sa podacima: CreditCard,
PersonCreditCard i Person koje se nalaze u AdventureWorks2014 bazi podataka.

Postupak:
	-> Right click na ime baze (Integralni),
	-> Tasks
	-> Import data... (ili export ako se npr kaze da se u excel nesto spremi ili u drugu bazu)
	-> Odabere se iz padajuce liste zadnja opcija (SQL Server Native bla bla),
	-> Unese se ime servera, .(tacka) ili (local) ili ako nam je data IP adresa unesemo nju
		i tek nakon toga se u padajucoj listi DATABASE odabere baze iz koje uzimamo podatke (AW2014)
	-> Odaberemo destinaciju, u ovom slucaju opet se radi o SQL Server native...
	   Defaultno bi nam trebao biti oznacen nas server i baza na koju smo kliknuli, 
	   u ovom slucaju nista ne treba dirati.
	-> Odaberemo prvu opciju, jer zelimo odabrati tabele koje zelimo prebaciti
	-> "Nakliknamo" zeljene tabele
	-> Next -> FINISH
*/

/*
5. Kreiranje indeksa u bazi podataka nada tabelama koje ste importovali u zadatku broj 2:
a) Non-clustered indeks nad tabelom Person. 
Potrebno je indeksirati Lastname i FirstName. Takoðer,
potrebno je ukljuèiti kolonu Title.
*/

CREATE NONCLUSTERED INDEX IX_Osobe ON Person.Person
(
	LastName,
	FirstName
)
INCLUDE
(
	Title
)
GO

/*
b) Napisati proizvoljni upit nad tabelom 
Person koji u potpunosti iskorištava indeks iz prethodnog koraka
*/

SELECT	LastName, 
		FirstName,
		Title
FROM	Person.Person
GO

/*
c) Uraditi disable indeksa iz koraka a)
*/

ALTER INDEX IX_Osobe ON Person.Person
DISABLE

/*
d) Clustered indeks nad tabelom 
CreditCard i kolonom CreditCardID
*/

SELECT * FROM Sales.CreditCard
GO

CREATE CLUSTERED INDEX IX_Kartice ON Sales.CreditCard
(
	CreditCardID
)
GO

/*
e) Non-clustered indeks nad tabelom CreditCard i 
kolonom CardNumber. Takoðer, potrebno je ukljuèiti
kolone ExpMonth i ExpYear.
*/

CREATE NONCLUSTERED INDEX IX_KarticeIstek ON Sales.CreditCard
(
	CardNumber
)
INCLUDE
(
	ExpMonth,
	ExpYear
)
GO

/*
6. Kreirati view sa sljedeæom definicijom. 
Objekat treba da prikazuje:  Prezime, 
							 ime, 
							 broj kartice i 
							 tip kartice, 
ali samo onim osobama 
koje imaju karticu tipa Vista i nemaju titulu.
*/

CREATE VIEW view_OsobeKarticeVista
AS
SELECT	T1.LastName AS Prezime,
		T1.FirstName AS Ime,
		T3.CardNumber AS [Broj kartice],
		T3.CardType AS [Tip kartice]
FROM	Person.Person AS T1
	INNER JOIN Sales.PersonCreditCard AS T2 ON T1.BusinessEntityID = T2.BusinessEntityID
	INNER JOIN Sales.CreditCard AS T3 ON T2.CreditCardID = T3.CreditCardID
WHERE	T3.CardType LIKE 'Vista' AND
		T1.Title IS NULL
GO

SELECT * FROM view_OsobeKarticeVista
GO

/*
7. Napraviti full i diferencijalni backup 
baze podataka na default lokaciju servera:
C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\Backup
*/

BACKUP DATABASE Integralni
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\IntBak.bak'
GO

BACKUP DATABASE Integralni
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\IntBakDiff.bak'
WITH DIFFERENTIAL
GO

/*
8. Mapirati login sa SQL Server-a pod imenom „student“ 
u svoju bazu kao korisnika pod svojim imenom
*/

CREATE LOGIN student1 
WITH PASSWORD = 'P@SSWORd!'
GO

CREATE USER Emir1 FOR LOGIN student1
GO

/*
9. Kreirati uskladištenu proceduru koja æe za 
uneseno prezime, ime ili broj kartice vršiti pretragu nad prethodno
kreiranim view-om (zadatak 4). Procedura obavezno treba da vraæa rezultate bez obzira da li su 
vrijednosti parametara postavljene. Testirati ispravnost procedure u sljedeæim situacijama:
a) Nije postavljena vrijednost niti jednom parametru (vraæa sve zapise)
b) Postavljena je vrijednost parametra prezime, a ostala dva parametra nisu (pretraga po prezimenu)
c) Postavljene su vrijednosti parametara prezime i ime, a broj kartice nije (pretraga po prezimenu i imenu)
d) Postavljene su vrijednosti sva tri parametra (pretraga po svim parametrima)
Takoðer, procedura treba da pretragu prezimena i imena vrši parcijalno (poèinje sa)
*/
drop procedure usp_FindByParameters
CREATE PROCEDURE usp_FindByParameters 
(
	@Prezime NVARCHAR(50) = NULL,
	@Ime NVARCHAR(30) = NULL,
	@BrojKartice NVARCHAR(40) = NULL
)
AS 
BEGIN
	SELECT	*
	FROM	view_OsobeKarticeVista
	WHERE	(Prezime LIKE @Prezime OR Prezime LIKE @Prezime + '%' OR @Prezime IS NULL) AND 
			(Ime LIKE @Ime OR Ime LIKE @Ime + '%' OR @Ime IS NULL) AND 
			([Broj kartice] LIKE @BrojKartice OR [Broj kartice] LIKE @BrojKartice + '%' OR @BrojKartice IS NULL)		
END
GO

EXEC usp_FindByParameters
GO

EXEC usp_FindByParameters @Ime = 'Sara'
GO

EXEC usp_FindByParameters @Prezime = 'P'
GO

EXEC usp_FindByParameters @BrojKartice = '11117940002905'
GO

SELECT * FROM view_OsobeKarticeVista
GO

EXEC usp_FindByParameters @Ime = 'S', @Prezime = 'P'
GO

EXEC usp_FindByParameters @Ime = 'G', @Prezime = 'F', @BrojKartice = '1111'
GO

/*
10. Kreirati uskladištenu proceduru koje æe za uneseni broj kartice 
vršiti brisanje kreditne kartice (CreditCard).
Takoðer, u istoj proceduri (u okviru jedne transakcije) 
prethodno obrisati sve zapise o vlasništvu kartice
(PersonCreditCard). Obavezno testirati 
ispravnost kreirane procedure.
*/

CREATE PROCEDURE usp_DeleteByCardNumber
(
	@CardNumber NVARCHAR(30)
)
AS
BEGIN



	DELETE FROM	Sales.PersonCreditCard
	FROM	Sales.PersonCreditCard AS T1 NNER JOIN Sales.CreditCard AS T2 
	ON T1.CreditCardID = T2.CreditCardID
	WHERE	T2.CardNumber LIKE @CardNumber

	    DELETE FROM	Sales.CreditCard
	WHERE	CardNumber LIKE @CardNumber
	
END
GO

EXEC usp_DeleteByCardNumber '22222222222222'
GO
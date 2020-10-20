-- 1.
/*
Kreirati novu bazu podataka i imenovati imenovati vašim brojem indexa.
Postavke za data fajl:
	-Lokacija: C:\BP2\Data
	-Veličina: inicijalno 5 MB,
	-Maksimalna veličina: Bez ograničenja
	-Uvećanje: 10%
Postavke za log fajl:
	-Lokacija: C:\BP2\Log
	-Veličina: inicijalno 2 MB
	-Maksimalna veličina: Bez ograničenja
	-Uvećanje: 5%
*/

CREATE DATABASE IB150031
ON
	(NAME = IB140065_dat, FILENAME = 'C:\BP2\Data\IB140065.mdf', SIZE = 5MB, MAXSIZE = UNLIMITED, FILEGROWTH = 10%)
LOG ON
	(NAME = IB140065_log, FILENAME = 'C:\BP2\Log\IB140065.ldf', SIZE = 2MB, MAXSIZE = UNLIMITED, FILEGROWTH = 5%)


-- 2.
/*
U bazi podataka kreirati sljedeće tabele:
	-Kandidati
		-Ime, polje za unos 30 karaktera (obavezan unos),
		-Prezime, polje za unos 30 karaktera (obavezan unos),
		-JMBG, polje za unos 13 karaktera (obavezan unos i jedinstvena vrijednost),
		-DatumRodjenja, polje za unos datuma (obavezan unos),
		-MjestoRodjenja, polje za unos 30 karaktera,
		-Telefon, polje za unos 20 karaktera,
		-Email, polje za unos 50 karaktera (jedinstvena vrijednost).
	-Testovi
		-Datum, polje za unos datuma i vremena (obavezan unos),
		-Naziv, polje za unos 50 karaktera (obavezan unos),
		-Oznaka, polje za unos 10 karaktera (obavezan unos i jedinstvena vrijednost),
		-Oblast, polje za unos 50 karaktera (obavezan unos),
		-MaxBrojBodova, polje za unos cijelog broja (obavezan unos),
		-Opis, polje za unos 250 karaktera.
	-RezultatiTesta
		-Polozio, polje za unos ishoda testiranja – DA/NE (obavezan unos)
		-OsvojeniBodovi, polje za unos decimalnog broja (obavezan unos),
		-Napomena, polje za unos dužeg niza karaktera.
Napomena: Kandidat može da polaže više testova i za svaki test ostvari određene rezultate, pri čemu
kandidat ne može dva puta polagati isti test. Također, isti test može polagati više kandidata.
*/

USE IB150031
GO

CREATE TABLE Kandidati
(
	KandidatID int IDENTITY(1,1) CONSTRAINT PK_Kandidat PRIMARY KEY,
	Ime nvarchar(30) NOT NULL,
	Prezime nvarchar(30) NOT NULL,
	JMBG nvarchar(13) NOT NULL CONSTRAINT UQ_JMBG UNIQUE,
	DatumRodjenja date NOT NULL,
	MjestoRodjenja nvarchar(30) NULL,
	Telefon nvarchar(20) NULL,
	Email nvarchar(50) NULL CONSTRAINT UQ_Email UNIQUE
);

CREATE TABLE Testovi
(
	TestID int IDENTITY(1,1) CONSTRAINT PK_Test PRIMARY KEY,
	Datum datetime NOT NULL,
	Naziv nvarchar(50) NOT NULL,
	Oznaka nvarchar(10) NOT NULL CONSTRAINT UQ_Oznaka UNIQUE,
	Oblast nvarchar(50) NOT NULL,
	MaxBrojBodova int NOT NULL,
	Opis nvarchar(250) NULL
);

CREATE TABLE RezultatiTesta
(
	TestID int NOT NULL CONSTRAINT FK_Test FOREIGN KEY REFERENCES Testovi(TestID),
	KandidatID int NOT NULL CONSTRAINT FK_Key FOREIGN KEY REFERENCES Kandidati(KandidatID),
	PRIMARY KEY (TestID, KandidatID),
	Polozio bit NOT NULL,
	OsvojeniBodovi decimal NOT NULL,
	Napomena text NULL
);


-- 3.
/*
Kreirati referentnu tabelu Gradovi i vezati je sa tabelom Kandidati. Također, u tabelu Kandidati dodati
polja Adresa i PostanskiBroj.
*/


CREATE TABLE Gradovi
(
	GradID int IDENTITY(1,1) CONSTRAINT PK_Grad PRIMARY KEY,
	Naziv nvarchar(30) NOT NULL
);

SELECT*
FROM Gradovi

INSERT INTO Gradovi
VALUES('Konjic');

INSERT INTO Gradovi
VALUES('Mostar');

INSERT INTO Gradovi
VALUES('Sarajevo');

ALTER TABLE Kandidati
ADD GradID int NULL CONSTRAINT FK_Grad FOREIGN KEY REFERENCES Gradovi(GradID),
	Adresa nvarchar(50),
	PostanskiBroj nvarchar(5)
GO

UPDATE Kandidati
SET GradID=1
WHERE KandidatID=1

-- 4.
/*
U tabelu Kandidati importovati 10 kupaca iz baze podataka AdventureWorks2014 i to sljedeće kolone:
	-FirstName (Person) -> Ime,
	-LastName (Person) -> Prezime,
	-Zadnjih 13 karaktera kolone rowguid iz tabele Customer (Crticu zamijeniti brojem 0) -> JMBG,
	-ModifiedDate (Customer) -> DatumRodjenja,
	-City (Address) -> MjestoRodjenja,
	-PhoneNumber (PersonPhone) -> Telefon,
	-EmailAddress (EmailAddress) -> Email.
*/

INSERT INTO Kandidati (Ime, Prezime, JMBG, DatumRodjenja, MjestoRodjenja, Telefon, Email)
	SELECT TOP 10 P.FirstName, P.LastName, REPLACE (RIGHT (C.rowguid, 13), '-', '0') AS JMBG, C.ModifiedDate, A.City, PP.PhoneNumber, EA.EmailAddress
	FROM AdventureWorks2014.Person.Person AS P
		INNER JOIN AdventureWorks2014.Sales.Customer AS C
		ON C.PersonID = P.BusinessEntityID INNER JOIN AdventureWorks2014.Person.BusinessEntityAddress AS BEA
		ON P.BusinessEntityID = BEA.BusinessEntityID INNER JOIN AdventureWorks2014.Person.Address AS A
		ON BEA.AddressID = A.AddressID INNER JOIN AdventureWorks2014.Person.PersonPhone AS PP
		ON P.BusinessEntityID = PP.BusinessEntityID INNER JOIN AdventureWorks2014.Person.EmailAddress AS EA
		ON P.BusinessEntityID = EA.BusinessEntityID

-- Provjera
SELECT *
FROM Kandidati


-- 5.
/*
U tabelu Testovi unijeti minimalno 3 zapisa sa proizvoljnim podacima.
*/

SELECT *
FROM Testovi


INSERT INTO Testovi (Datum, Naziv, Oznaka, Oblast, MaxBrojBodova, Opis)
VALUES (GETDATE(), 'Test1', 'T1', 'Programiranje', 30, 'Test iz programiranja.'),
	   (GETDATE(), 'Test2', 'T2', 'Baze podataka II', 25, 'Test iz baza podataka.'),
	   (GETDATE(), 'Test3', 'T3', 'Web razvoj i dizajn', 35, 'Test iz web razvoja.')


-- 6.
/*
U tabelu RezultatiTesta unijeti minimalno 10 zapisa sa proizvoljnim podacima.
*/

SELECT *
FROM RezultatiTesta

select*
from Kandidati

select*
from Testovi



INSERT INTO RezultatiTesta (TestID, KandidatID, Polozio, OsvojeniBodovi, Napomena)
VALUES (4, 4, 1, 20, 'Napomena'),
	   (5, 4, 1, 15, 'Napomena'),
	   (6, 4, 1, 18, 'Napomena'),
	   (4, 1, 1, 25, 'Napomena'),
	   (5, 1, 1, 21, 'Napomena'),
	   (6, 1, 1, 31, 'Napomena'),
	   (4, 5, 1, 5, 'Napomena'),
	   (5, 5, 1, 25, 'Napomena'),
	   (6, 5, 1, 19, 'Napomena'),
	   (4, 6, 1, 22, 'Napomena')


-- 7.
/*
Kreirati upit koji prikazuje rezultate testiranja za odabrani test (oznaka testa kao filter). Kao rezultat
upita prikazati sljedeće kolone: ime i prezime, jmbg, telefon i email kandidata, zatim datum, naziv, oznaku,
oblast i maksimalan broj bodova na testu, te polje položio, osvojene bodove i procentualni rezultat testa.
*/

SELECT *
FROM RezultatiTesta

select*
from Kandidati

select*
from Testovi

SELECT K.Ime, K.Prezime, K.JMBG, K.Telefon, K.Email, T.Datum, T.Naziv, T.Oznaka, T.Oblast,
		T.MaxBrojBodova, RT.Polozio, RT.OsvojeniBodovi, ROUND(((RT.OsvojeniBodovi/T.MaxBrojBodova) * 100), 2) AS 'Procenat'
FROM Kandidati AS K INNER JOIN RezultatiTesta AS RT
ON K.KandidatID = RT.KandidatID INNER JOIN Testovi AS T
ON RT.TestID = T.TestID
WHERE T.Oznaka = 'T1'


-- 8.
/*
Izmijeniti rezultate testiranja svim kandidatima koji su polagali odabrani test (oznaka testa kao filter).
Svim kandidatima broj osvojenih bodova uvećati za 5.
*/

UPDATE RezultatiTesta
SET OsvojeniBodovi = OsvojeniBodovi + 5
	FROM RezultatiTesta AS RT
	INNER JOIN Testovi AS T
	ON RT.TestID = T.TestID
WHERE T.Oznaka = 'T1'



-- 9.
/*
Obrisati jedan test i sve ostvarene rezultate na odabranom testu (oznaka testa kao filter).
*/


ALTER TABLE RezultatiTesta
DROP CONSTRAINT FK_Test

ALTER TABLE RezultatiTesta
ADD CONSTRAINT FK_Test FOREIGN KEY (TestID) REFERENCES Testovi(TestID) ON DELETE CASCADE

DELETE FROM Testovi 
WHERE Oznaka = 'T3'
GO

SELECT *
FROM Testovi

SELECT *
FROM RezultatiTesta





-- 10.
/*
Obrisati tabelu Gradovi i ukloniti polja Adresa i PostanskiBroj.
*/
DROP TABLE Gradovi

ALTER TABLE Kandidati
DROP CONSTRAINT FK_Grad

ALTER TABLE Kandidati
ADD CONSTRAINT FK_Grad FOREIGN KEY (GradID) REFERENCES Gradovi(GradID) ON DELETE CASCADE 

ALTER TABLE Kandidati
DROP COLUMN GradID, Adresa, PostanskiBroj

SELECT *
FROM Kandidati




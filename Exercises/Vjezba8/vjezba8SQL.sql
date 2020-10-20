-- 1.
/*
Unutar baze podataka kreirane u vje�bi 7 dodati novu tabelu Komisija sa sljede�im poljima:
	-Ime, polje za unos 30 karaktera (obavezan unos)
	-Prezime, polje za unos 30 karaktera (obavezan unos)
	-Titula, polje za unos 15 karaktera,
	-Telefon, polje za unos 20 karaktera,
	-Email, polje za unos 50 karaktera.
Napomena: Tabelu kreirati bez primarnog klju�a
*/

USE IB150031
GO

CREATE TABLE Komisija
(
	Ime nvarchar(30) NOT NULL,
	Prezime nvarchar(30) NOT NULL,
	Titula nvarchar(15) NULL,
	Telefon nvarchar(20) NULL,
	Email nvarchar(50) NULL
);


-- 2.
/*
U prethodno kreiranu tabelu, primjenom podupita, importovati 10000 osoba iz baze podataka
AdventureWorks2014, a zatim testirati rad upita (testni upiti) provjeravaju�i aktualni plan izvr�enja.
*/

INSERT INTO Komisija (Ime, Prezime, Titula, Telefon, Email)
	SELECT TOP 10000 P.FirstName, P.LastName, P.Title, PP.PhoneNumber, EA.EmailAddress
	FROM AdventureWorks2014.Person.Person AS P
			INNER JOIN AdventureWorks2014.Person.PersonPhone AS PP
			ON P.BusinessEntityID = PP.BusinessEntityID
			INNER JOIN AdventureWorks2014.Person.EmailAddress AS EA
			ON P.BusinessEntityID = EA.BusinessEntityID

SELECT *
FROM Komisija


-- 3.
/*
U tabelu Komisija dodati primarni klju� pod nazivom ClanKomisijeID, automatski generator vrijednosti,
a zatim testirati izvr�enje prethodno kreiranih upita, te provjeriti aktualni plan izvr�enja. U komentaru
zapisati razlike uo�ene u planu izvr�enja upita!
*/

ALTER TABLE Komisija
ADD ClanKomisijeID int IDENTITY(1,1) CONSTRAINT PK_ClanKomisije PRIMARY KEY
GO

SELECT *
FROM Komisija

--Kada tabela posjeduje primarni klju� ona automatski posjeduje i Clustered Index pa je zbog toga 
--izvr�enje upita br�e


-- 4.
/*
Tabelu Komisija povezati sa tabelom Testovi many-to-many relacijom, te importovati testne podatke
kao �lanove komisije za odre�ene testove.
*/

CREATE TABLE TestoviKomisija
(
	TestID int NOT NULL CONSTRAINT FK_TestID FOREIGN KEY REFERENCES Testovi(TestID),
	ClanKomisijeID int  NOT NULL CONSTRAINT FK_Komisija FOREIGN KEY REFERENCES Komisija(ClanKomisijeID)
);

INSERT INTO TestoviKomisija(TestID, ClanKomisijeID)
VALUES (4, 1),
	   (4, 2),
	   (4, 3),
	   (4, 4),
	   (4, 5)

SELECT *
FROM TestoviKomisija


-- 5.
/*
Kreirati jednostavan non-clustered indeks nad tabelom Komisija (npr. polje Prezime) i upitima testirati
primjenu indeksa, provjeravaju�i aktualni plan izvr�enja.
*/

CREATE NONCLUSTERED INDEX IX_Prezime
ON Komisija (Prezime ASC)
GO

SELECT Ime 
FROM Komisija
WHERE Prezime LIKE 'Duffy'


-- 6.
/*
Kreirati kompozitni non-clustered indeks nad tabelom Komisija (npr. polja Ime i Prezime) i upitima
testirati primjenu indeksa, provjeravaju�i aktualni plan izvr�enja.
*/

select*
from Komisija

CREATE NONCLUSTERED INDEX IX_Ime_Prezime
ON Komisija (Ime ASC, Prezime ASC)

SELECT Ime, Prezime
FROM Komisija
WHERE Ime like 'Aaron' OR Prezime LIKE 'Margheim'
-- 7.
/*
Kreirati kompozitni non-clustered indeks sa uklju�enim dodatnim kolonama nad tabelom Komisija i
upitima testirati primjenu indeksa, provjeravaju�i aktualni plan izvr�enja.
*/

CREATE NONCLUSTERED INDEX IX_Prezime_Ime
ON Komisija (Prezime ASC, Ime ASC)
INCLUDE (Titula)

SELECT Ime, Prezime, Titula
FROM Komisija
WHERE Titula IS NOT NULL

-- 8.
/*
Kreirati unique non-clustered indeks nad tabelom Komisija, polje Email. INSERT komandom testirati
funkcionalnost prethodno kreiranog indeksa.
*/

CREATE UNIQUE NONCLUSTERED INDEX IX_Email
ON Komisija (Email)

INSERT INTO Komisija (Ime, Prezime, Titula, Telefon, Email)
VALUES ('Emir', '�ator', 'Mr', '062-000-000', 'ken0@adventure-works.com')

--Unique indeks ne dozvoljava ponavljanje e-mail adresa


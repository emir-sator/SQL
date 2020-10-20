CREATE DATABASE Integralni16102016


USE Integralni16102016

CREATE TABLE Proizvodi
(
ProizvodID int NOT NULL IDENTITY(1,1) CONSTRAINT PK_ProizvodID PRIMARY KEY,
Sifra nvarchar(10) NOT NULL,
Naziv nvarchar(50) NOT NULL,
Cijena decimal NOT NULL
)


CREATE TABLE Skladista
(
SkladisteID int NOT NULL IDENTITY(1,1) CONSTRAINT PK_SkladisteID PRIMARY KEY,
Naziv nvarchar(50) NOT NULL,
Oznaka nvarchar(10) NOT NULL CONSTRAINT UQ_Oznaka UNIQUE,
Lokacija nvarchar(50) NOT NULL
)

CREATE TABLE SkladisteProizvodi
(
Stanje decimal NOT NULL,
SkladisteID int NOT NULL CONSTRAINT FK_SkladisteID FOREIGN KEY REFERENCES Skladista(SkladisteID),
ProizvodID int NOT NULL CONSTRAINT FK_ProizvodID FOREIGN KEY REFERENCES Proizvodi(ProizvodID),
CONSTRAINT PK_SkladisteProizvodi  PRIMARY KEY (SkladisteID,ProizvodID) 
)

INSERT INTO Skladista
VALUES('Bingo','BN','Konjic'),
      ('Konzum','KZ','Sarajevo'),
	  ('Mepas','MP','Mostar')

SELECT *
FROM Skladista

/*  b) Koriste�i bazu podataka AdventureWorks2014, preko INSERT i SELECT komande importovati 
10 najprodavanijih bicikala (kategorija proizvoda 'Bikes' i to sljede�e kolone:
I. Broj proizvoda (ProductNumber) - > Sifra,
II. Naziv bicikla (Name) -> Naziv,
III. Cijena po komadu (ListPrice) -> Cijena,
*/

INSERT INTO Proizvodi(Sifra,Naziv,Cijena)
SELECT TOP 10 PP.ProductNumber, PP.Name, PP.ListPrice
FROM AdventureWorks2014.Production.Product AS PP INNER JOIN AdventureWorks2014.Sales.SalesOrderDetail AS SOD
ON PP.ProductID=SOD.ProductID INNER JOIN AdventureWorks2014.Production.ProductSubcategory AS PSC
ON PP.ProductSubcategoryID=PSC.ProductSubcategoryID INNER JOIN AdventureWorks2014.Production.ProductCategory AS PC
ON PSC.ProductCategoryID=PC.ProductCategoryID
WHERE PC.Name LIKE '%Bikes%'
GROUP BY PP.ProductNumber,PP.Name, PP.ListPrice
ORDER BY SUM(SOD.OrderQty) DESC

SELECT *
FROM Proizvodi

/*
c) Putem INSERT i SELECT komandi u tabelu SkladisteProizvodi za sva dodana skladista importovati sve proizvode tako da stanje bude 100

*/

INSERT INTO SkladisteProizvodi(Stanje,SkladisteID,ProizvodID)
SELECT 100,1,ProizvodID
FROM Proizvodi AS P

SELECT *
FROM SkladisteProizvodi

INSERT INTO SkladisteProizvodi(Stanje,SkladisteID,ProizvodID)
SELECT 95,2,ProizvodID
FROM Proizvodi AS P

INSERT INTO SkladisteProizvodi(Stanje,SkladisteID,ProizvodID)
SELECT 33,3,ProizvodID
FROM Proizvodi AS P

SELECT *
FROM SkladisteProizvodi

/*
3. Kreirati uskladi�tenu proceduru koja �e 
vr�iti pove�anje stanja skladi�ta za odre�eni proizvod na odabranom skladi�tu. Provjeriti ispravnost procedure.
*/


CREATE PROCEDURE usp_StanjePovecanje
(
@Kolicina int,
@ProizvodID int,
@SkladisteID int
)
AS
BEGIN
UPDATE SkladisteProizvodi
SET Stanje=Stanje+@Kolicina
WHERE ProizvodID=@ProizvodID AND SkladisteID=@SkladisteID
END

SELECT *
FROM Proizvodi

EXEC usp_StanjePovecanje @Kolicina=5,
                         @ProizvodID=10,
						 @SkladisteID=1  

SELECT *
FROM SkladisteProizvodi
/*
Kreiranje indeksa u bazi podataka nad tabelama
a) Non-clustered indeks nad tabelom Proizvodi. Potrebno je indeksirati Sifru i Naziv. Tako�er, potrebno je uklju�iti kolonu Cijena
b) Napisati proizvoljni upit nad tabelom Proizvodi koji u potpunosti iskori�tava indeks iz prethodnog koraka
c) Uradite disable indeksa iz koraka a)
*/


CREATE NONCLUSTERED INDEX NIC_Proizvod
ON Proizvodi(Sifra,Naziv)
INCLUDE (Cijena)

SELECT Sifra,Naziv,Cijena
FROM Proizvodi


ALTER INDEX NIC_Proizvod 
ON Proizvodi
DISABLE;


/*
5. Kreirati view sa sljede�om definicijom. Objekat treba 
da prikazuje sifru, naziv i cijenu proizvoda, oznaku, naziv i lokaciju skladi�ta, te stanje na skladi�tu.
*/

CREATE VIEW Pogled
AS
SELECT P.Sifra, P.Naziv AS 'Proizvod', P.Cijena, S.Oznaka, S.Naziv AS 'Skladiste', S.Lokacija, SP.Stanje
FROM Proizvodi AS P INNER JOIN SkladisteProizvodi AS SP
ON P.ProizvodID=SP.ProizvodID INNER JOIN Skladista AS S
ON SP.SkladisteID=S.SkladisteID

SELECT *
FROM Pogled

/*
6. Kreirati uskladi�tenu proceduru koja �e na osnovu unesene �ifre proizvoda prikazati 
ukupno stanje zaliha na svim skladi�tima.
 U rezultatu prikazati sifru, naziv i cijenu proizvoda te ukupno stanje zaliha. 
U proceduri koristiti prethodno kreirani view. Provjeriti ispravnost kreirane procedure.
*/

CREATE PROCEDURE usp_StanjeZaliha
(
@SifraProizvoda nvarchar(10)
)
AS
BEGIN
SELECT Sifra, Proizvod, Cijena, SUM(Stanje) AS 'Ukupno'
FROM Pogled
WHERE Sifra=@SifraProizvoda
GROUP BY Sifra,Proizvod,Cijena
END

SELECT *
FROM Proizvodi

EXEC usp_StanjeZaliha @SifraProizvoda='BK-M68B-38'

/*
7. Kreirati uskladi�tenu proceduru koja �e vr�iti upis novih proizvoda, te kao stanje zaliha 
za uneseni proizvod postaviti na 0 za sva skladi�ta. Provjeriti ispravnost kreirane procedure
*/
SELECT *
FROM SkladisteProizvodi

CREATE PROCEDURE usp_ProizvodiInsert
(
@Sifra nvarchar(10),
@Naziv nvarchar(50),
@Cijena decimal 
)
AS
BEGIN
INSERT INTO Proizvodi(Sifra,Naziv,Cijena)
VALUES(@Sifra,@Naziv,@Cijena)
INSERT INTO SkladisteProizvodi(Stanje,SkladisteID,ProizvodID)
VALUES(0,1,(SELECT MAX(P.ProizvodID)
            FROM Proizvodi AS P)),
	  (0,2,(SELECT MAX(P.ProizvodID)
            FROM Proizvodi AS P)),
	  (0,3,(SELECT MAX(P.ProizvodID)
            FROM Proizvodi AS P))
END

EXEC usp_ProizvodiInsert @Sifra='123AB',
	                     @Naziv='Cokolada',
					     @Cijena='5'

SELECT *
FROM Proizvodi

SELECT *
FROM SkladisteProizvodi

/* 8. Kreirati uskladi�tenu proceduru koja �e za unesenu �ifru proizvoda 
vr�iti brisanje proizvoda uklju�uju�i stanje na svim skladi�tima. 
Provjeriti ispravnost procedure. */



CREATE PROCEDURE usp_ProizvodiDelete
(
@SifraProizvoda nvarchar(10)
)
AS
BEGIN
DELETE FROM SkladisteProizvodi 
FROM Proizvodi AS P INNER JOIN SkladisteProizvodi AS SP
ON P.ProizvodID=SP.ProizvodID
WHERE @SifraProizvoda=P.Sifra
				
DELETE FROM Proizvodi
WHERE Sifra=@SifraProizvoda
END


EXEC usp_ProizvodiDelete @SifraProizvoda='123AB'

SELECT *
FROM SkladisteProizvodi
				
SELECT *
FROM Proizvodi

/*
9. Kreirati uskladi�tenu proceduru koja �e za unesenu �ifru proizvoda, oznaku skladi�ta ili lokaciju skladi�ta 
vr�iti pretragu prethodno kreiranim view-om (zadatak 5).
 Procedura obavezno treba da vra�a rezultate bez obrzira da li su vrijednosti parametara postavljene. 
 Testirati ispravnost procedure u sljede�im situacijama:
a) Nije postavljena vrijednost niti jednom parametru (vra�a sve zapise)
b) Postavljena je vrijednost parametra �ifra proizvoda, a ostala dva parametra nisu
c) Postavljene su vrijednosti parametra �ifra proizvoda i oznaka skladi�ta, a lokacija nije
d) Postavljene su vrijednosti parametara �ifre proizvoda i lokacije, a oznaka skladi�ta nije
e) Postavljene su vrijednosti sva tri parametra
*/

CREATE PROCEDURE usp_PogledPretraga
(
@Sifra nvarchar(10)=NULL,
@Oznaka nvarchar(10)=NULL,
@Lokacija nvarchar(50)=NULL
)
AS
BEGIN
SELECT * 
FROM Pogled
WHERE (@Sifra IS NULL OR Sifra=@Sifra) AND (@Oznaka IS NULL OR Oznaka=@Oznaka) AND (@Lokacija IS NULL OR Lokacija=@Lokacija)
END

-- a) 
-- Vra�a sve zapise po�to nije postavljena vrijednost niti jednog parametra
EXEC usp_PogledPretraga 

-- b) 
-- Vra�a zapise koji imaju proslije�enu �ifru
EXEC usp_PogledPretraga @Sifra='BK-M68B-38'

-- c)
-- Vra�a zapise koji imaju proslije�enu �ifru i lokaciju 
EXEC usp_PogledPretraga @Sifra='BK-M68B-38',
                        @Oznaka='BN'


-- d) Vra�a zapise koji imaju proslije�enu �ifru i lokaciju 

EXEC usp_PogledPretraga @Sifra='BK-M68B-38', 
                        @Lokacija='Konjic'


-- e)
-- Postavljene su vrijednosti sva tri parametra
EXEC usp_PogledPretraga @Sifra='BK-M68B-38', 
                        @Lokacija='Konjic',
						@Oznaka='BN'

-- 10. Napraviti full i diferencijalni backup baze podataka na default lokaciju servera:

BACKUP DATABASE Integralni16102016 TO
DISK='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\integralni4.bak'

BACKUP DATABASE Integralni16102016 TO
DISK='C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\integralni4Diff.bak'
WITH DIFFERENTIAL;

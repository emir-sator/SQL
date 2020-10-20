/*
1. Napraviti bazu podataka s nazivom svog dosijea s defaultnim postavkama.
2. Kreirati sljedeće tabele:
a) Pacijenti:
- PacijentID, automatski generator, obavezan unos,
- Ime, polje za unos 50 karaktera, obavezan unos,
- Prezime, polje za unos 50 karaktera, obavezan unos,
- JMBG, polje za unos 13 karaktera, obavezan unos i jedinstvena vrijednost,
- DatumRodjenja, polje za unos datuma, obavezan unos,
- Dijagnoza, polje za unos duzeg teksta.
b) Ljekari:
- LjekarID, automatski generator, obavezan unos,
- Ime, polje za unos 50 karaktera, obavezan unos,
- Prezime, polje za unos 50 karaktera, obavezan unos,
- Specijalizacija, polje za unos 30 karaktera, obavezan unos,
- RadniStaz, polje za unos cijelog broja.
c) Terapije:
- Lijek, polje za unos 30 karaktera, obavezan unos.
*/

CREATE DATABASE IB19092016

USE IB19092016

--a) Pacijenti:
--- PacijentID, automatski generator, obavezan unos,
--- Ime, polje za unos 50 karaktera, obavezan unos,
--- Prezime, polje za unos 50 karaktera, obavezan unos,
--- JMBG, polje za unos 13 karaktera, obavezan unos i jedinstvena vrijednost,
--- DatumRodjenja, polje za unos datuma, obavezan unos,
--- Dijagnoza, polje za unos duzeg teksta.
CREATE TABLE Pacijenti
(
PacijentID int NOT NULL IDENTITY(1,1) CONSTRAINT PK_PacijentID PRIMARY KEY,
Ime nvarchar(50) NOT NULL,
Prezime nvarchar(50) NOT NULL,
JMBG nvarchar(13) NOT NULL CONSTRAINT UQ_JMBG UNIQUE,
DatumRodjenja datetime NOT NULL,
Dijagnoza nvarchar(250)
)
/*
b) Ljekari:
- LjekarID, automatski generator, obavezan unos,
- Ime, polje za unos 50 karaktera, obavezan unos,
- Prezime, polje za unos 50 karaktera, obavezan unos,
- Specijalizacija, polje za unos 30 karaktera, obavezan unos,
- RadniStaz, polje za unos cijelog broja.
*/
CREATE TABLE Ljekari
(
LjekarID int NOT NULL IDENTITY(1,1) CONSTRAINT PK_LjekarID PRIMARY KEY,
Ime nvarchar(50) NOT NULL,
Prezime nvarchar(50) NOT NULL,
Specijalizacija nvarchar(30) NOT NULL,
RadniStaz int NULL
)

/*

c) Terapije:
- Lijek, polje za unos 30 karaktera, obavezan unos.

*/

/*
Napomena: Jedan pacijent može imati više ljekara, za različite bolesti, 
a jedan ljekar može liječiti više pacijenata. Pacijenta za određenu bolest liječi isključivo jedan ljekar.
*/

CREATE TABLE Terapije
(
Lijek nvarchar(30) NOT NULL,
PacijentID int NOT NULL CONSTRAINT FK_PacijentID FOREIGN KEY REFERENCES Pacijenti(PacijentID),
LjekarID int NOT NULL CONSTRAINT FK_LjekarID FOREIGN KEY REFERENCES Ljekari(LjekarID),
CONSTRAINT PK_Terapije PRIMARY KEY(PacijentID,LjekarID)
)

/*
3. Putem komande INSERT sa podupitom, u tabelu pacijenti ubaciti 10 kupaca iz baze AdwentureWorks2014,
 na polje JMBG ubaciti prvih 13 karaktera iz kolone rowguid i to crtice zamijeniti 0.
*/


INSERT INTO Pacijenti(Ime,Prezime,Jmbg,DatumRodjenja)
SELECT TOP 10 P.FirstName, P.LastName, REPLACE(RIGHT(SC.rowguid,13),'-','0'),
              P.ModifiedDate
FROM AdventureWorks2014.Person.Person AS P
INNER JOIN AdventureWorks2014.Sales.Customer AS SC
ON P.BusinessEntityID=SC.PersonID
ORDER BY NEWID()

SELECT *
FROM Pacijenti

-- 4. U tabelu ljekari ubaciti 3 proizvoljna zapisa.

INSERT INTO Ljekari(Ime,Prezime,Specijalizacija)
VALUES('Emir','Šator','ginekologija'),
      ('Almedin','Alikadić','pedijatar'),
	  ('Adnan','Mujkić','ginekologija')

SELECT *
FROM Ljekari

-- 5. U tabelu Terapije dodati 10 zapisa sa proizvoljnim podacima.
INSERT INTO Terapije(Lijek,PacijentID,LjekarID)
VALUES('Paracetamol',1,2),
      ('Brufen',2,3),
      ('Lexilium',3,1),
      ('Analgin',4,1),
	  ('Paracetamol',5,2),
	  ('Analgin',6,2),
	  ('Brufen',7,1),
	  ('Paracetamol',8,1),
	  ('Kafetin',9,3),
	  ('Paracetamol',10,3)

SELECT *
FROM Terapije

-- 6. Kreirati procedure za dodavanje zapisa u sve tri tabele. – testirati procedure.
GO
CREATE Procedure usp_PacijentInsert
(
@Ime nvarchar(50),
@Prezime nvarchar(50),
@JMBG nvarchar(13),
@DatumRodjenja datetime,
@Dijagnozna nvarchar(250)=NULL
)
AS
BEGIN
INSERT INTO Pacijenti(Ime,Prezime,JMBG,DatumRodjenja,Dijagnoza)
VALUES(@Ime,@Prezime,@JMBG,@DatumRodjenja,@Dijagnozna)
END

EXEC usp_PacijentInsert @Ime='Omar',
                        @Prezime='Sahinovic',
						@JMBG='2111234567894',
						@DatumRodjenja='05/24/1994'
						    
							SELECT *
							FROM Pacijenti
							
CREATE PROCEDURE usp_LjekariInsert
(
@Ime nvarchar(50),
@Prezime nvarchar(50),
@Specijalizacija nvarchar(30),
@RadniStaz int=NULL
)
AS
BEGIN
INSERT INTO Ljekari(Ime,Prezime,Specijalizacija,RadniStaz)
VALUES(@Ime,@Prezime,@Specijalizacija,@RadniStaz)
END

EXEC usp_LjekariInsert @Ime='Neira',
			           @Prezime='Omerika',
				       @Specijalizacija='ginekologija'

SELECT *
FROM Ljekari												 


	
CREATE PROCEDURE usp_TerapijeInsert
(
@Lijek nvarchar(30),
@PacijentID int,
@LjekarID int
)
AS
BEGIN
INSERT INTO Terapije(Lijek,PacijentID,LjekarID)
VALUES(@Lijek,@PacijentID,@LjekarID)
END

EXEC usp_TerapijeInsert @Lijek='Aspirin',
					    @PacijentID=11,
						@LjekarID=3
SELECT *
FROM Terapije


--7. Kreirati procedure za modifikovanje zapisa u sve tri tabele. – testirati procedure.
	
CREATE PROCEDURE usp_LjekarUpdate
(
@Ime nvarchar(50),
@Prezime nvarchar(50),
@Specijalizacija nvarchar(30),
@RadniStaz int=NULL,
@LjekarID int
)
AS
BEGIN
UPDATE Ljekari
SET Ime=@Ime, Prezime=@Prezime, Specijalizacija=@Specijalizacija, RadniStaz=@RadniStaz
WHERE LjekarID=@LjekarID
END

EXEC usp_LjekarUpdate @Ime='Merisa',
			          @Prezime='Mulac',
					  @Specijalizacija='pedijatar',
					  @RadniStaz =14,
					  @LjekarID=4
					 

SELECT *
FROM Ljekari



GO
CREATE PROCEDURE usp_PacijentiUpdate
(
@Ime nvarchar(50),
@Prezime nvarchar(50),
@Jmbg nvarchar(13),
@DatumRodjenja datetime,
@Dijagnoza nvarchar(250)=NULL,
@PacijentID int
)
AS
BEGIN
UPDATE Pacijenti
SET Ime=@Ime,Prezime=@Prezime, JMBG=@Jmbg, DatumRodjenja=@DatumRodjenja, Dijagnoza=@Dijagnoza
WHERE PacijentID=@PacijentID
END

EXEC usp_PacijentiUpdate @Ime='Nejra',
                         @Prezime='Sahinovic',
						 @Jmbg='1456789654123',
						 @DatumRodjenja='04/12/1994',
						 @Dijagnoza='Povisena temperatura',
						 @PacijentID=11

SELECT *
FROM Pacijenti

	
CREATE PROCEDURE usp_TerapijeUpdate
(
@Lijek nvarchar(30),
@PacijentID int,
@LjekarID int
)
AS
BEGIN
UPDATE Terapije
SET Lijek=@Lijek
WHERE PacijentID=@PacijentID and LjekarID=@LjekarID
END

sELECT *
FROM Terapije

EXEC usp_TerapijeUpdate @Lijek='Brufen',
					    @PacijentID=10,
						@LjekarID=3

/*
8. Kreirati pogled koji će ispisivati ime i prezime pacijenta, ime i prezime liječnika
, JMBG pacijenta, Datum rođenja, Specijalizaciju liječnika te propisani lijek.
*/

GO
CREATE VIEW Pogled
AS
SELECT P.Ime + '' + P.Prezime AS 'Pacijent',
       Lj.Ime + '' + Lj.Prezime AS 'Ljekar',
	   P.JMBG, P.DatumRodjenja, Lj.Specijalizacija, T.Lijek
       FROM Pacijenti AS P
INNER JOIN Terapije AS T
ON P.PacijentID=T.PacijentID
INNER JOIN Ljekari AS Lj
ON T.LjekarID=Lj.LjekarID


SELECT *
FROM Pogled

/*
9. Kreirati proceduru koja će ispisivati sve pacijente koje liječi određeni liječnik. 
Pretragu podataka vršiti nad prethodno kreiranim pogledom.
*/

GO
CREATE PROCEDURE usp_PacijentiSelect
(
@Ljekar nvarchar(100)
)
AS
BEGIN
SELECT Pacijent, Ljekar
FROM Pogled
WHERE Ljekar=@Ljekar
END

EXEC usp_PacijentiSelect @Ljekar='AlmedinAlikadic'

/*
10. Kreirati proceduru koja će vratiti broj pacijenata koje liječi liječnik sa određenim imenom i prezimenom.
*/

GO
CREATE PROCEDURE usp_UkupnoPacijenata
(
@Ime nvarchar(50),
@Prezime nvarchar(50),
@UkupnoPacijenata int OUTPUT
)
AS
BEGIN
SELECT @UkupnoPacijenata=COUNT(P.PacijentID) AS 'Ukupno pacijenata'
FROM Ljekari AS LJ INNER JOIN Terapije AS T
ON LJ.LjekarID=T.LjekarID INNER JOIN Pacijenti AS P
ON T.PacijentID=P.PacijentID
WHERE LJ.Ime=@Ime AND LJ.Prezime=@Prezime
END

DECLARE @Ime nvarchar(50), @Prezime nvarchar(50), @UkupnoPacijenata int
SET @Ime='Almedin'
SET @Prezime='Alikadic'

EXEC usp_UkupnoPacijenata @Ime, @Prezime, @UkupnoPacijenata OUTPUT
SELECT @UkupnoPacijenata 

/*
11. Kreirati proceduru koja će na osnovu JMBG-a ispisati sve podatke o pacijentu, uključujući sve njegove terapije.
*/

EXEC usp_PacijentiUpdate @Ime='Randy',
                         @Prezime='Lin',
						 @Jmbg='0B05FE22422E3',
						 @DatumRodjenja='2013-08-09 00:00:00.000',
                         @Dijagnoza='Povisena temperatura', 
                         @PacijentID=5

						
GO

CREATE PROCEDURE usp_PacijentiSelect1
(
@Jmbg nvarchar(13)
)
AS
BEGIN
SELECT *
FROM Pacijenti AS P INNER JOIN Terapije AS T
ON P.PacijentID=T.PacijentID
WHERE P.JMBG=@Jmbg
END

SELECT *
FROM Pacijenti

SELECT *
FROM Terapije

EXEC usp_PacijentiSelect1 @Jmbg='0B05FE22422E3'

/*
12. Kreirati proceduru koja će vršiti promjenu dijagnoze pacijentu.

*/

GO
CREATE PROCEDURE usp_PacijentUpdate1
(
@Dijagnoza nvarchar(250),
@PacijentID int
)
AS
BEGIN
UPDATE Pacijenti
SET Dijagnoza=@Dijagnoza
WHERE PacijentID=@PacijentID
END

EXEC usp_PacijentUpdate1 @Dijagnoza='Viroza',
@PacijentID=1

SELECT *
FROM Pacijenti

-- 13. Kreirati proceduru koja će ispisati ime i prezime pacijenta koji je imao najviše bolesti.

GO

CREATE PROCEDURE usp_PacijentiBolest
AS
BEGIN
SELECT TOP 1 P.Ime, P.Prezime, COUNT(T.PacijentID) AS 'Broj terapija'
FROM Pacijenti AS P INNER JOIN Terapije AS T
ON P.PacijentID=T.PacijentID
GROUP BY P.Ime,P.Prezime
ORDER BY COUNT(T.PacijentID) DESC
END

EXEC usp_PacijentiBolest

SELECT *
FROM Terapije

SELECT *
FROM Pacijenti

/*
14. Kreirati proceduru koja će vršiti pretragu pacijenata na osnovu imena, prezimena te dijagnoze. Omogućiti pretragu i ako nisu 
postavljeni svi parametri – sve varijacije. Također, omogućiti unos imena, prezimena i dijagnoze djelimično.
*/

GO
CREATE PROCEDURE usp_PacijentiPretraga
(
@Ime nvarchar(50)=NULL,
@Prezime nvarchar(50)=NULL,
@Dijagnoza nvarchar(250)=NULL
)
AS
BEGIN
SELECT *
FROM Pacijenti
WHERE (@Ime IS NULL OR Ime LIKE @Ime + '%' OR Ime LIKE @Ime) AND (@Prezime IS NULL OR Prezime LIKE @Prezime + '%' OR Prezime LIKE @Prezime) AND 
(@Dijagnoza IS NULL OR Dijagnoza LIKE @Dijagnoza + '%' OR Dijagnoza LIKE @Dijagnoza)
END

EXEC usp_PacijentiPretraga


EXEC usp_PacijentiPretraga @Ime='L'

EXEC usp_PacijentiPretraga @Ime='Ce',
                           @Prezime='G'

EXEC usp_PacijentiPretraga @Ime='Ce',
                           @Prezime='Gu',
						   @Dijagnoza='Vir'

EXEC usp_PacijentiPretraga @Dijagnoza='Viroza'


--  15. Kreirati proceduru koja će vršiti pretragu lječnika po imenu i prezimenu i/ili specijalizaciji.

GO
CREATE PROCEDURE usp_Pretraga
(
@Ime nvarchar(50),
@Prezime nvarchar(50),
@Specijalizacija nvarchar(30)=NULL
)
AS
BEGIN
SELECT *
FROM Ljekari
WHERE Ime=@Ime AND Prezime=@Prezime AND (@Specijalizacija IS NULL OR Specijalizacija=@Specijalizacija)
END


EXEC usp_Pretraga @Ime='Adnan',
                  @Prezime='Mujkic'

EXEC usp_Pretraga @Ime='Adnan',
                  @Prezime='Mujkic',
				  @Specijalizacija='ginekologija'


-- 16. Kreirati proceduru koja će omogućiti brisanje ljekara.
				  
GO
CREATE PROCEDURE usp_LjekarDelete
(
@LjekarID int
)
AS
BEGIN
DELETE FROM Terapije
WHERE LjekarID=@LjekarID
DELETE FROM Ljekari
WHERE LjekarID=@LjekarID
END

EXEC usp_LjekarDelete  @LjekarID=2

SELECT *
FROM Terapije

SELECT *
FROM Ljekari

-- 17. Kreirati proceduru koja će brisati određenog pacijenta te sve njegove zabilježene terapije.



CREATE PROCEDURE usp_PacijentDelete
(
@PacijentID int
)
AS
BEGIN
DELETE FROM Terapije
WHERE PacijentID=@PacijentID

DELETE FROM Pacijenti
WHERE PacijentID=@PacijentID
END

EXEC usp_PacijentDelete @PacijentID=11

SELECT *
FROM Terapije

SELECT *
FROM Pacijenti

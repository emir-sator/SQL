


3. Kreiranje indeksa u bazi podataka nada tabelama:
a) Non-clustered indeks nad tabelom Klijenti. Potrebno je indeksirati Ime i Prezime. Takoðer, 
potrebno je ukljuèiti kolonu BrojRacuna.
b) Napisati proizvoljni upit nad tabelom Klijenti koji u potpunosti iskorištava indeks iz prethodnog koraka.
 Upit obavezno mora imati filter.
c) Uraditi disable indeksa iz koraka a) 5 bodova

4. Kreirati uskladištenu proceduru koja æe vršiti upis novih klijenata. Kao parametre proslijediti sva polja.
 Provjeriti ispravnost kreirane procedure. 10 bodova

5. Kreirati view sa sljedeæom definicijom. Objekat treba da prikazuje datum transakcije, tip transakcije,
 ime i prezime pošiljaoca (spojeno), broj raèuna pošiljaoca, ime i prezime primaoca (spojeno),
  broj raèuna primaoca, svrhu i iznos transakcije.
10 bodova

6. Kreirati uskladištenu proceduru koja æe na osnovu unesenog broja raèuna pošiljaoca prikazivati sve
 transakcije koje su provedene sa raèuna klijenta. U proceduri koristiti prethodno kreirani view.
  Provjeriti ispravnost kreirane procedure.


7. Kreirati upit koji prikazuje sumaran iznos svih transakcija po godinama, sortirano po godinama.
 U rezultatu upita prikazati samo dvije kolone: kalendarska godina i ukupan iznos transakcija u godini.
10 bodova

8. Kreirati uskladištenu proceduru koje æe vršiti brisanje klijenta ukljuèujuæi sve njegove transakcije, 
bilo da je za transakciju vezan kao pošiljalac ili kao primalac. Provjeriti ispravnost kreirane procedure.
10 bodova

9. Kreirati uskladištenu proceduru koja æe na osnovu unesenog broja raèuna ili prezimena pošiljaoca
 vršiti pretragu nad prethodno kreiranim view-om (zadatak 5). Testirati ispravnost procedure u sljedeæim situacijama:
a) Nije postavljena vrijednost niti jednom parametru (vraæa sve zapise)
b) Postavljena je vrijednost parametra broj raèuna,
c) Postavljena je vrijednost parametra prezime,
d) Postavljene su vrijednosti oba parametra.


10. Napraviti full i diferencijalni backup baze podataka na default lokaciju servera:
a) C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\Backup*/



/*1. Kroz SQL kod, napraviti bazu podataka koja nosi ime vašeg broja dosijea. U postupku kreiranja u obzir uzeti samo DEFAULT postavke.

Unutar svoje baze podataka kreirati tabele sa sljedeæom strukturom:
a) Klijenti
i. KlijentID, automatski generator vrijednosti i primarni kljuè
ii. Ime, polje za unos 30 UNICODE karaktera (obavezan unos)
iii. Prezime, polje za unos 30 UNICODE karaktera (obavezan unos)
iv. Telefon, polje za unos 20 UNICODE karaktera (obavezan unos)
v. Mail, polje za unos 50 UNICODE karaktera (obavezan unos), jedinstvena vrijednost
vi. BrojRacuna, polje za unos 15 UNICODE karaktera (obavezan unos)
vii. KorisnickoIme, polje za unos 20 UNICODE karaktera (obavezan unos)
viii. Lozinka, polje za unos 20 UNICODE karaktera (obavezan unos)

b) Transakcije
i. TransakcijaID, automatski generator vrijednosti i primarni kljuè
ii. Datum, polje za unos datuma i vremena (obavezan unos)
iii. TipTransakcije, polje za unos 30 UNICODE karaktera (obavezan unos)
iv. PosiljalacID, referenca na tabelu Klijenti (obavezan unos)
v. PrimalacID, referenca na tabelu Klijenti (obavezan unos)
vi. Svrha, polje za unos 50 UNICODE karaktera (obavezan unos)
vii. Iznos, polje za unos decimalnog broja (obavezan unos) 10 bodova

2. Popunjavanje tabela podacima:
a) Koristeæi bazu podataka AdventureWorks2014, preko INSERT i SELECT komande importovati 10 kupaca u tabelu Klijenti.
 Ime, prezime, telefon, mail i broj raèuna (AccountNumber) preuzeti od kupca, korisnièko
  ime generisati na osnovu imena i prezimena u formatu ime.prezime, a lozinku generisati na osnovu polja PasswordHash,
   i to uzeti samo zadnjih 8 karaktera.
b) Putem jedne INSERT komande u tabelu Transakcije dodati minimalno 10 transakcija.
CREATE DATABASE Integralni25092016
*/

CREATE DATABASE Integralni050916

use Integralni050916

CREATE TABLE Klijenti
(
KlijentID INT NOT NULL IDENTITY(1,1) CONSTRAINT PK_Klijent PRIMARY KEY,
Ime NVARCHAR(30) NOT NULL,
Prezime NVARCHAR(30) NOT NULL,
Telefon NVARCHAR(20) NOT NULL,
Mail NVARCHAR(50) NOT NULL CONSTRAINT UQ_Mail UNIQUE,
BrojRacuna NVARCHAR(15) NOT NULL,
KorisnickoIme NVARCHAR(20) NOT NULL,
Lozinka NVARCHAR(20) NOT NULL,

)


CREATE TABLE Transakcije
(
TransakcijaID INT NOT NULL IDENTITY(1,1) Constraint PK_Transakcija PRIMARY KEY,
Datum DATETIME NOT NULL,
TipTransakcije NVARCHAR(30) NOT NULL,
Svrha NVARCHAR(50) NOT NULL,
Iznos DECIMAL(18,2) NOT NULL
)

alter table Transakcije
ADD PosiljalacID INT NOT NULL CONSTRAINT FK_Posiljalac_Transakcija FOREIGN KEY (PosiljalacID) REFERENCES Klijenti(KlijentID),
PrimalacID INT NOT NULL CONSTRAINT FK_Primalac_Transakcija FOREIGN KEY (PrimalacID) REFERENCES Klijenti(KlijentID)

/*2. Popunjavanje tabela podacima:
a) Koristeæi bazu podataka AdventureWorks2014, preko INSERT i SELECT komande importovati 10 kupaca u tabelu Klijenti.
 Ime, prezime, telefon, mail i broj raèuna (AccountNumber) preuzeti od kupca, korisnièko
  ime generisati na osnovu imena i prezimena u formatu ime.prezime, a lozinku generisati na osnovu polja PasswordHash,
   i to uzeti samo zadnjih 8 karaktera.
b) Putem jedne INSERT komande u tabelu Transakcije dodati minimalno 10 transakcija.*/

--a)
USE AdventureWorks2014
Select*
FROM Person.Person as P INNER JOIN Sales.Customer AS C
ON P.BusinessEntityID=C.PersonID

select*
from Person.Person 
INSERT INTO [Integralni050916].[dbo].[Klijenti] (Ime,Prezime,Telefon, Mail,BrojRacuna,KorisnickoIme,Lozinka)
SELECT TOP 10 P.FirstName ,P.LastName,left(PPP.PhoneNumber,20), E.EmailAddress, CONVERT(VARCHAR,Right(C.AccountNumber,8)), 
 SUBSTRING(E.EmailAddress,0,CHARINDEX('@',E.EmailAddress)), CONVERT(VARCHAR,RIGHT(pp.PasswordHash,8))
FROM Person.Person as P INNER JOIN Sales.Customer AS C
ON P.BusinessEntityID=C.PersonID INNER JOIN Person.EmailAddress as E
ON P.BusinessEntityID= E.BusinessEntityID INNER JOIN Person.[Password] as PP
ON P.BusinessEntityID= PP.BusinessEntityID  INNER JOIN Person.PersonPhone as PPP
ON PPP.BusinessEntityID=P.BusinessEntityID
ORDER BY LastName 


use Integralni050916
GO
select * 

INSERT INTO Transakcije (Datum,TipTransakcije,PosiljalacID,PrimalacID,Svrha,Iznos)
VALUES ('09.12.2014', 'HITNO', 2,3,'jkaskgal', 450), 
('09.12.2016', 'HITNO', 4,6,'jkaskgal', 350),
('09.12.2014', 'HITNO', 3,3,'jkaskgal', 350),
('09.12.2013', 'HITNO', 8,3,'jkaskgal', 350),
('09.12.2012', 'HITNO', 7,5,'jkaskgal', 350),
('09.12.2011', 'HITNO', 2,3,'jkaskgal', 350),
('09.12.2010', 'HITNO', 4,3,'jkaskgal', 350),
('09.12.2009', 'HITNO', 9,10,'jkaskgal', 350)



SELECT *
FROM Transakcije 


/*3. Kreiranje indeksa u bazi podataka nada tabelama:
a) Non-clustered indeks nad tabelom Klijenti. Potrebno je indeksirati Ime i Prezime. Takoðer, 
potrebno je ukljuèiti kolonu BrojRacuna.
b) Napisati proizvoljni upit nad tabelom Klijenti koji u potpunosti iskorištava indeks iz prethodnog koraka.
 Upit obavezno mora imati filter.
c) Uraditi disable indeksa iz koraka a) 5 bodova*/

--a)
CREATE NONCLUSTERED INDEX IX_Klijent ON Klijenti
(
Ime, Prezime)
INCLUDE
(
BrojRacuna)
--b)
SELECT Ime,Prezime, BrojRacuna
FROM Klijenti
WHERE Ime like 'A%'

--c
ALTER INDEX IX_Klijent on Klijenti
DISABLE

/*4. Kreirati uskladištenu proceduru koja æe vršiti upis novih klijenata. Kao parametre proslijediti sva polja.
 Provjeriti ispravnost kreirane procedure.*/

 drop Procedure UnosKlijenata
 CREATE PROCEDURE UnosKlijenata
 (
 @Ime NVARCHAR(30),
 @Prezime NVARCHAR(30),
 @Telefon NVARCHAR(20),
 @Mail NVARCHAR (50),
 @BrojRacuna NVARCHAR(15),
 @KorisnickoIme NVARCHAR(20),
 @Lozinka NVARCHAR(20)

 )
 AS BEGIN
INSERT INTO Klijenti(Ime,Prezime,Telefon, Mail,BrojRacuna, KorisnickoIme, Lozinka)
VALUES(@Ime, @Prezime,@Telefon, @Mail, @BrojRacuna, @KorisnickoIme, @Lozinka)
 END

EXEC UnosKlijenata 'Emir','Šator','062-111-222','emir@fit.ba','2131313121','Fixor','ksS-l2w'

select*
from Klijenti
  /*5. Kreirati view sa sljedeæom definicijom. Objekat treba da prikazuje datum transakcije, tip transakcije,
 ime i prezime pošiljaoca (spojeno), broj raèuna pošiljaoca, ime i prezime primaoca (spojeno),
  broj raèuna primaoca, svrhu i iznos transakcije.
10 bodova*/


CREATE  VIEW viewKlijentiTransakcije
AS
SELECT T.Datum, T.TipTransakcije, K.Ime+ ' '+ K.Prezime as 'Ime i Prezime Posiljaoca',K.BrojRacuna as 'Broj racuna posiljaoca' ,
K1.Ime+ ' '+ K1.Prezime as 'Ime i Prezime Primaoca', K1.BrojRacuna AS 'Broj Racuna Primaoca', T.Svrha, T.Iznos
FROM Klijenti as K INNER JOIN Transakcije as T
ON K.KlijentID=T.PosiljalacID inner join Klijenti as K1
ON K1.KlijentID =T.PrimalacID

select *
from viewKlijentiTransakcije
/*6. Kreirati uskladištenu proceduru koja æe na osnovu unesenog broja raèuna pošiljaoca prikazivati sve
 transakcije koje su provedene sa raèuna klijenta. U proceduri koristiti prethodno kreirani view.
  Provjeriti ispravnost kreirane procedure.*/
drop procedure PrikazTransakcija

create PROCEDURE PrikazTransakcija
(
@BrojRacunaPosiljaoca NVARCHAR(15)
)
as 
begin
select *
from viewKlijentiTransakcije
where @BrojRacunaPosiljaoca IN (Select K.BrojRacuna
FROM Klijenti as K INNER JOIN Transakcije as T
ON K.KlijentID=T.PosiljalacID inner join Klijenti as K1
ON K1.KlijentID =T.PrimalacID
WHERE @BrojRacunaPosiljaoca=K.BrojRacuna)
--WHERE @BrojRacunaPosiljaoca=K.BrojRacuna)

end

exec PrikazTransakcija '00029484'

 /*7. Kreirati upit koji prikazuje sumaran iznos svih transakcija po godinama, sortirano po godinama.
 U rezultatu upita prikazati samo dvije kolone: kalendarska godina i ukupan iznos transakcija u godini.
10 bodova*/
SELECT year(Datum), SUM(Iznos) as 'Ukupan iznos trans. po godinama'
FROM Transakcije
group by year(Datum)
order by 1

/*8. Kreirati uskladištenu proceduru koje æe vršiti brisanje klijenta ukljuèujuæi sve njegove transakcije, 
bilo da je za transakciju vezan kao pošiljalac ili kao primalac. Provjeriti ispravnost kreirane procedure.
10 bodova*/
CREATE PROCEDURE BrisanjeKlijenta
(
@KlijentID INT
)
AS
BEGIN
DELETE FROM Transakcije
FROM Klijenti as K inner join Transakcije as T
on K.KlijentID=T.PosiljalacID INNER JOIN Klijenti as K1
ON K1.KlijentID=T.PrimalacID
where @KlijentID=K.KlijentID

DELETE FROM Klijenti
where @KlijentID=KlijentID

END
SELECT *
FROM viewKlijentiTransakcije
EXEC BrisanjeKlijenta 2
/*9. Kreirati uskladištenu proceduru koja æe na osnovu unesenog broja raèuna ili prezimena pošiljaoca
 vršiti pretragu nad prethodno kreiranim view-om (zadatak 5). Testirati ispravnost procedure u sljedeæim situacijama:
a) Nije postavljena vrijednost niti jednom parametru (vraæa sve zapise)
b) Postavljena je vrijednost parametra broj raèuna,
c) Postavljena je vrijednost parametra prezime,
d) Postavljene su vrijednosti oba parametra.
*/
create PROCEDURE PretragraPrekoViewaSaParametrima
(
@BrojRacuna NVARCHAR(15)=null,
@Prezime NVARCHAR(30)=null
)
AS
BEGIN
select*
from viewKlijentiTransakcije
where ( [Broj racuna posiljaoca] LIKE @BrojRacuna  or  [Broj racuna posiljaoca]  like @BrojRacuna + '%' 
 or @BrojRacuna is null) AND
([Ime i Prezime Posiljaoca] LIKE @Prezime  or  [Ime i Prezime Posiljaoca]  like @Prezime + '%'  or @Prezime is null)

END

exec PretragraPrekoViewaSaParametrima 
exec PretragraPrekoViewaSaParametrima'00029484'
exec PretragraPrekoViewaSaParametrima @Prezime ='Ad'
exec PretragraPrekoViewaSaParametrima @BrojRacuna='00029484',@Prezime ='Gustavo Achong'



/*
10. Napraviti full i diferencijalni backup baze podataka na default lokaciju servera:
a) C:\Program Files\Microsoft SQL Server\MSSQL12.MSSQLSERVER\MSSQL\Backup*/

BACKUP DATABASE Integralni050916
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\mojbackup.bak'

BACKUP DATABASE Integralni050916
TO DISK= 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\mojbackupDIF.bak'
WITH DIFFERENTIAL




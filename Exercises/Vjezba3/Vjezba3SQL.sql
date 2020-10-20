/*Vje�ba 3 :: AdventureWorks2017*/
USE AdventureWorks2017

--1. Za sve osobe koje imaju unesenu titulu kreirati poruku dobrodo�lice u sljede�em formatu:
--Dobrodo�li [titula] [ime i prezime], trenutno je [trenutno vrijeme] sati
--Upit napisati minimalno na 3 na�ina kombiniraju�i razli�ite T-SQL funkcije!
SELECT 'dobrodosli'+ ' '+ Title+ ' '+ FirstName+' '+LastName+'trenutno je'+ CONVERT(NVARCHAR,DATEPART(HOUR,GETDATE()),104)+':'+
CONVERT(NVARCHAR,DATEPART(MINUTE,GETDATE()),104)
FROM Person.Person
WHERE Title IS NOT NULL

--2. Prikazati minimalnu, maksimalnu i prosje�nu cijenu proizvoda ali samo onih gdje je cijena ve�a od 0 KM.
SELECT MIN(ListPrice) as 'Minimalna cijena' , MAX(ListPrice) AS 'Maksimalna cijena', avg(ListPrice) AS 'Prosjecna cijena' 
FROM Production.Product
WHERE ListPrice >0

--3. Kreirati upit koji prikazuje ukupan broj kupaca po teritoriji. Lista treba da sadr�i
-- sljede�e kolone: ID teritorije, ukupan broj kupaca. Uzeti u obzir samo teritorije gdje ima vi�e od 1000 kupaca.
select TerritoryID, COUNT(PersonID) AS 'Ukupan broj kupaca'
from Sales.Customer
group by TerritoryID
having COUNT(PersonID)>1000

--4. Prikazati ukupan broj proizvoda po modelu. Lista treba da sadr�i ID modela proizvoda i ukupan broj proizvoda.
-- Uslov je da proizvod pripada nekom modelu i da je ukupan broj proizvoda po modelu ve�i od 1. 
-- Tako�er, prebrojati samo proizvode �iji naziv po�inje slovom 'S'.
 SELECT ProductModelID, count(ProductID) AS 'Ukupan broj proizvoda'
 FROM Production.Product 
 WHERE ProductModelID IS NOT NULL AND Name LIKE '[S]%'
 GROUP BY ProductModelID
 HAVING COUNT(ProductID)>1


--5. Kreirati upit koji prikazuje 10 najprodavanijih proizvoda. Lista treba da sadr�i ID proizvoda
-- i ukupnu koli�inu prodaje. Provjeriti da li ima proizvoda sa istom koli�inom prodaje kao zapis pod rednim brojem 10?
 SELECT top 10 with ties ProductID, COUNT(OrderQty) AS 'Ukupna kolicina prodaje'
 FROM SALES.SalesOrderDetail
 GROUP BY ProductID
 ORDER BY COUNT(OrderQty) DESC



--6. Kreirati upit koji prikazuje zaradu od prodaje proizvoda. Lista treba da sadr�i ID proizvoda,
-- ukupnu zaradu bez ura�unatog popusta i ukupnu zaradu sa ura�unatim popustom. 
--  zarade zaokru�iti na dvije decimale. Uslov je da se prika�e zarada samo za stavke gdje je bilo popusta.
--   Listu sortirati po zaradi opadaju�im redoslijedom.
SELECT  ProductID, ROUND(SUM(UnitPrice*OrderQty),2) as 'Ukupna zarada od  prodaje bez popusta',
ROUND(SUM(UnitPrice*OrderQty-UnitPrice*OrderQty*UnitPriceDiscount),2) as 'Ukupna zarada od  prodaje sa popustom'
FROM Sales.SalesOrderDetail 
WHERE UnitPriceDiscount >0
GROUP BY ProductID
ORDER by 2 DESC


--7. Prikazati broj narud�be, datum narud�be i datum isporuke za narud�be koje su isporu�ene
----u Kanadu u 7. mjesecu 2014. godine. Uzeti u obzir samo narud�be koje nisu pla�ene kreditnom karticom.
--  Datume formatirati u sljede�em obliku: dd.mm.yyyy
--I nacin
SELECT SalesOrderNumber, CONVERT(varchar,OrderDate,4) AS 'Datum narud�be' ,CONVERT(varchar,ShipDate,4) AS 'Datum isporuke'
FROM SALES.SalesOrderHeader 
WHERE TerritoryID=6 AND CreditCardID IS NULL AND YEAR(ShipDate)=2014 AND MONTH(ShipDate)=7

--II nacin
SELECT SalesOrderNumber, 

	CONVERT(nvarchar, DATEPART(DAY, OrderDate)) + '.' + 
	CONVERT(nvarchar, DATEPART(MONTH, OrderDate)) + '.' + 
	CONVERT(nvarchar, DATEPART(YEAR, OrderDate)) AS 'Datum narud�be', 
	
	CONVERT(nvarchar, DATEPART(DAY, ShipDate)) + '.' + 
	CONVERT(nvarchar, DATEPART(MONTH, ShipDate)) + '.' + 
	CONVERT(nvarchar, DATEPART(YEAR, ShipDate)) AS 'Datum isporuke'	
FROM Sales.SalesOrderHeader
WHERE TerritoryID = 6 AND CreditCardID IS NULL AND 
	DATEPART(MONTH, ShipDate) = 7 AND DATEPART(YEAR, ShipDate) = 2014


--8. Kreirati upit koji prikazuje minimalnu, maksimalnu, prosje�nu te ukupnu zaradu po mjesecima u 2013. godini.
SELECT  MIN(SubTotal) as 'Minimalna cijena' , MAX(SubTotal) AS 'Maksimalna cijena', avg(SubTotal) AS 'Prosjecna cijena' 
FROM sales.SalesOrderHeader
WHERE YEAR(OrderDate)=2013
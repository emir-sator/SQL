/*Vježba 3 :: AdventureWorks2017*/
USE AdventureWorks2017

--1. Za sve osobe koje imaju unesenu titulu kreirati poruku dobrodošlice u sljedeæem formatu:
--Dobrodošli [titula] [ime i prezime], trenutno je [trenutno vrijeme] sati
--Upit napisati minimalno na 3 naèina kombinirajuæi razlièite T-SQL funkcije!
SELECT 'dobrodosli'+ ' '+ Title+ ' '+ FirstName+' '+LastName+'trenutno je'+ CONVERT(NVARCHAR,DATEPART(HOUR,GETDATE()),104)+':'+
CONVERT(NVARCHAR,DATEPART(MINUTE,GETDATE()),104)
FROM Person.Person
WHERE Title IS NOT NULL

--2. Prikazati minimalnu, maksimalnu i prosjeènu cijenu proizvoda ali samo onih gdje je cijena veæa od 0 KM.
SELECT MIN(ListPrice) as 'Minimalna cijena' , MAX(ListPrice) AS 'Maksimalna cijena', avg(ListPrice) AS 'Prosjecna cijena' 
FROM Production.Product
WHERE ListPrice >0

--3. Kreirati upit koji prikazuje ukupan broj kupaca po teritoriji. Lista treba da sadrži
-- sljedeæe kolone: ID teritorije, ukupan broj kupaca. Uzeti u obzir samo teritorije gdje ima više od 1000 kupaca.
select TerritoryID, COUNT(PersonID) AS 'Ukupan broj kupaca'
from Sales.Customer
group by TerritoryID
having COUNT(PersonID)>1000

--4. Prikazati ukupan broj proizvoda po modelu. Lista treba da sadrži ID modela proizvoda i ukupan broj proizvoda.
-- Uslov je da proizvod pripada nekom modelu i da je ukupan broj proizvoda po modelu veæi od 1. 
-- Takoðer, prebrojati samo proizvode èiji naziv poèinje slovom 'S'.
 SELECT ProductModelID, count(ProductID) AS 'Ukupan broj proizvoda'
 FROM Production.Product 
 WHERE ProductModelID IS NOT NULL AND Name LIKE '[S]%'
 GROUP BY ProductModelID
 HAVING COUNT(ProductID)>1


--5. Kreirati upit koji prikazuje 10 najprodavanijih proizvoda. Lista treba da sadrži ID proizvoda
-- i ukupnu kolièinu prodaje. Provjeriti da li ima proizvoda sa istom kolièinom prodaje kao zapis pod rednim brojem 10?
 SELECT top 10 with ties ProductID, COUNT(OrderQty) AS 'Ukupna kolicina prodaje'
 FROM SALES.SalesOrderDetail
 GROUP BY ProductID
 ORDER BY COUNT(OrderQty) DESC



--6. Kreirati upit koji prikazuje zaradu od prodaje proizvoda. Lista treba da sadrži ID proizvoda,
-- ukupnu zaradu bez uraèunatog popusta i ukupnu zaradu sa uraèunatim popustom. 
--  zarade zaokružiti na dvije decimale. Uslov je da se prikaže zarada samo za stavke gdje je bilo popusta.
--   Listu sortirati po zaradi opadajuæim redoslijedom.
SELECT  ProductID, ROUND(SUM(UnitPrice*OrderQty),2) as 'Ukupna zarada od  prodaje bez popusta',
ROUND(SUM(UnitPrice*OrderQty-UnitPrice*OrderQty*UnitPriceDiscount),2) as 'Ukupna zarada od  prodaje sa popustom'
FROM Sales.SalesOrderDetail 
WHERE UnitPriceDiscount >0
GROUP BY ProductID
ORDER by 2 DESC


--7. Prikazati broj narudžbe, datum narudžbe i datum isporuke za narudžbe koje su isporuèene
----u Kanadu u 7. mjesecu 2014. godine. Uzeti u obzir samo narudžbe koje nisu plaæene kreditnom karticom.
--  Datume formatirati u sljedeæem obliku: dd.mm.yyyy
--I nacin
SELECT SalesOrderNumber, CONVERT(varchar,OrderDate,4) AS 'Datum narudžbe' ,CONVERT(varchar,ShipDate,4) AS 'Datum isporuke'
FROM SALES.SalesOrderHeader 
WHERE TerritoryID=6 AND CreditCardID IS NULL AND YEAR(ShipDate)=2014 AND MONTH(ShipDate)=7

--II nacin
SELECT SalesOrderNumber, 

	CONVERT(nvarchar, DATEPART(DAY, OrderDate)) + '.' + 
	CONVERT(nvarchar, DATEPART(MONTH, OrderDate)) + '.' + 
	CONVERT(nvarchar, DATEPART(YEAR, OrderDate)) AS 'Datum narudžbe', 
	
	CONVERT(nvarchar, DATEPART(DAY, ShipDate)) + '.' + 
	CONVERT(nvarchar, DATEPART(MONTH, ShipDate)) + '.' + 
	CONVERT(nvarchar, DATEPART(YEAR, ShipDate)) AS 'Datum isporuke'	
FROM Sales.SalesOrderHeader
WHERE TerritoryID = 6 AND CreditCardID IS NULL AND 
	DATEPART(MONTH, ShipDate) = 7 AND DATEPART(YEAR, ShipDate) = 2014


--8. Kreirati upit koji prikazuje minimalnu, maksimalnu, prosjeènu te ukupnu zaradu po mjesecima u 2013. godini.
SELECT  MIN(SubTotal) as 'Minimalna cijena' , MAX(SubTotal) AS 'Maksimalna cijena', avg(SubTotal) AS 'Prosjecna cijena' 
FROM sales.SalesOrderHeader
WHERE YEAR(OrderDate)=2013
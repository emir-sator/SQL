/*Vježba 4 :: AdventureWorks2017

Iz vježbe 3, zadatke od broja 3-7 uraditi primjenom JOIN operatora!
*/
USE AdventureWorks2017

--3.
SELECT ST.TerritoryID, ST.Name, COUNT(C.PersonID) as 'Ukupan broj kupaca'
FROM person.Person AS P INNER JOIN SALES.Customer AS C
ON P.BusinessEntityID=C.PersonID INNER JOIN Sales.SalesTerritory AS ST
ON C.TerritoryID=ST.TerritoryID
group by ST.TerritoryID, ST.Name 
having COUNT(C.PersonID)>1000

--4.
 SELECT PM.ProductModelID, COUNT(P.ProductID) AS 'Ukupan broj proizvoda'
 FROM Production.Product AS P INNER JOIN Production.ProductModel AS PM
 ON P.ProductModelID=PM.ProductModelID
 WHERE P.ProductModelID IS NOT NULL AND p.Name LIKE '[S]%'
 GROUP BY PM.ProductModelID
 HAVING COUNT(ProductID)>1

 --5
 SELECT top 10 with ties P.ProductID, COUNT(SOD.OrderQty) AS 'Ukupna kolicina prodaje'
FROM Production.Product AS P INNER JOIN SALES.SalesOrderDetail AS SOD
ON P.ProductID=SOD.ProductID
GROUP BY P.ProductID
ORDER BY COUNT(OrderQty) DESC

--6
SELECT  P.ProductID, ROUND(SUM(SOD.UnitPrice*SOD.OrderQty),2) as 'Ukupna zarada od  prodaje bez popusta', 
ROUND(SUM(SOD.UnitPrice*SOD.OrderQty-SOD.UnitPrice*SOD.OrderQty*SOD.UnitPriceDiscount),2) as 'Ukupna zarada od  prodaje sa popustom'
FROM Sales.SalesOrderDetail  AS SOD INNER JOIN Production.Product AS P
ON SOD.ProductID=P.ProductID
WHERE SOD.UnitPriceDiscount >0
GROUP BY P.ProductID
ORDER by 2 DESC

--7
SELECT SOH.SalesOrderNumber, CONVERT(varchar,SOH.OrderDate,104) AS 'Datum narudžbe' ,CONVERT(varchar,SOH.ShipDate,104) AS 'Datum isporuke'
FROM SALES.SalesOrderHeader AS SOH INNER JOIN Sales.SalesTerritory as ST
ON SOH.TerritoryID=ST.TerritoryID left join Sales.CreditCard AS CC
ON CC.CreditCardID=SOH.CreditCardID
WHERE ST.TerritoryID=6 AND SOH.CreditCardID IS NULL AND YEAR(SOH.ShipDate)=2014 AND MONTH(SOH.ShipDate)=7


select SOH.SalesOrderNumber, CONVERT(varchar,SOH.OrderDate,104) AS 'Datum narudžbe', CONVERT(varchar,SOH.ShipDate,104) AS 'Datum isporuke'
from Sales.SalesOrderHeader AS SOH INNER JOIN Sales.SalesTerritory AS ST
ON ST.TerritoryID=SOH.TerritoryID
WHERE ST.Name LIKE 'Canada' and  SOH.CreditCardID IS NULL AND SOH.TerritoryID=6 AND YEAR(SOH.ShipDate)=2014 AND MONTH(SOH.ShipDate)=7

SELECT SalesOrderNumber, 

	CONVERT(nvarchar, DATEPART(DAY, SOH.OrderDate)) + '.' + 
	CONVERT(nvarchar, DATEPART(MONTH, SOH.OrderDate)) + '.' + 
	CONVERT(nvarchar, DATEPART(YEAR, SOH.OrderDate)) AS 'Datum narudžbe', 
	
	CONVERT(nvarchar, DATEPART(DAY, SOH.ShipDate)) + '.' + 
	CONVERT(nvarchar, DATEPART(MONTH, SOH.ShipDate)) + '.' + 
	CONVERT(nvarchar, DATEPART(YEAR, SOH.ShipDate)) AS 'Datum isporuke'	
FROM Sales.SalesOrderHeader AS SOH INNER JOIN Sales.SalesTerritory AS ST
ON ST.TerritoryID=SOH.TerritoryID
WHERE ST.Name like 'Canada' AND CreditCardID IS NULL AND 
	DATEPART(MONTH, SOH.ShipDate) = 7 AND DATEPART(YEAR, SOH.ShipDate) = 2014




--1. Kreirati upit koji prikazuje ime i prezime, korisnièko ime (sve iza znaka „\“ u koloni LoginID), 
--dužinu korisnièkog imena, titulu, datum zaposlenja (dd.MM.yyyy), starost i staž zaposlenika.
-- Uslov je da se prikaže 10 najstarijih zaposlenika koji obavljaju bilo koju ulogu menadžera.
 SELECT top 10 with ties P.FirstName+ ' ' +P.LastName AS 'Ime i prezime', substring(LoginID,CHARINDEX('\',LoginID),10) AS 'Korisnicko ime', 
 LEN(substring(LoginID,CHARINDEX('\',LoginID),10)) AS 'Duzina korisnickog imena',
 P.Title, E.HireDate, DATEDIFF(year,E.BirthDate,GETDATE()) AS 'Starost', DATEDIFF(year,HireDate,GETDATE()) AS 'Staz'
 FROM Person.Person as P inner join HumanResources.Employee as E
 ON P.BusinessEntityID=E.BusinessEntityID
 WHERE E.JobTitle like '%Manager%'
 order by 7 DESC

--2. Kreirati upit koji prikazuje 10 najskupljih stavki prodaje (detalji narudžbe)
-- i to sljedeæe kolone: naziv proizvoda, kolièina, cijena, iznos. Cijenu i iznos zaokružiti na dvije decimale
--  Takoðer, kolièinu prikazati u formatu „10 kom.“, a cijenu i iznos u formatu „1000 KM“.
SELECT top 10 P.Name as 'Naziv proizvoda', CONVERT(VARCHAR,SOD.OrderQty)+'kom' AS 'Kolicina', CONVERT(VARCHAR,ROUND(SOD.UnitPrice,2))+'KM' AS 'Cijena', 
CONVERT(VARCHAR,ROUND(SOD.OrderQty*SOD.UnitPrice,2))+'KM' AS 'Iznos'
FROM Sales.SalesOrderDetail AS SOD INNER JOIN Production.Product AS P
ON SOD.ProductID=P.ProductID
GROUP BY P.Name, SOD.OrderQty, SOD.UnitPrice
ORDER BY SOD.OrderQty*SOD.UnitPrice DESC

--3. Kreirati upit koji prikazuje naziv modela i opis modela proizvoda. Uslov je da naziv
-- modela sadrži rijeè „Mountain“, dok je opis potrebno prikazati samo na engleskom jeziku.
 SELECT pm.Name, PD.Description
 FROM Production.Product as P inner join Production.ProductModel AS pm
 ON pm.ProductModelID=p.ProductModelID inner join Production.ProductModelProductDescriptionCulture as PMPDC
 ON PMPDC.ProductModelID=pm.ProductModelID INNER JOIN Production.ProductDescription AS PD
 ON PD.ProductDescriptionID=PMPDC.ProductDescriptionID
 WHERE pm.Name like '%Mountain%' AND PMPDC.CultureID LIKE '%en%'


--4. Kreirati upit koji prikazuje broj, naziv i cijenu proizvoda, te stanje zaliha po lokacijama.
-- Uzeti u obzir samo proizvode koji pripadaju kategoriji „Bikes“. Izlaz sortirati po stanju zaliha u opadajuæem redoslijedu.
SELECT p.ProductNumber, p.Name, p.ListPrice, pi.Quantity, PI.LocationID
FROM Production.Product as P inner join Production.ProductSubcategory as PS
ON PS.ProductSubcategoryID=P.ProductSubcategoryID INNER JOIN Production.ProductCategory AS PC
ON PC.ProductCategoryID=PS.ProductCategoryID INNER JOIN Production.ProductInventory AS PI
ON P.ProductID=PI.ProductID INNER JOIN Production.Location AS L
ON L.LocationID=PI.LocationID 
WHERE pc.Name like '%Bikes%'
--GROUP BY p.ProductNumber, p.Name, p.ListPrice,PI.LocationID
order by pi.Quantity desc

SELECT p.ProductNumber, p.Name, p.ListPrice, sum(pi.Quantity) 'stanje zaliha', PI.LocationID
FROM Production.Product as P inner join Production.ProductSubcategory as PS
ON PS.ProductSubcategoryID=P.ProductSubcategoryID INNER JOIN Production.ProductCategory AS PC
ON PC.ProductCategoryID=PS.ProductCategoryID INNER JOIN Production.ProductInventory AS PI
ON P.ProductID=PI.ProductID INNER JOIN Production.Location AS L
ON L.LocationID=PI.LocationID 
WHERE pc.Name like '%Bikes%'
GROUP BY p.ProductNumber, p.Name, p.ListPrice,PI.LocationID
order by sum(pi.Quantity) desc



--5. Kreirati upit koji prikazuje ukupno ostvarenu zaradu po zaposleniku, na podruèju Evrope, u januaru mjesecu 2014.
-- godine. Lista treba da sadrži ime i prezime zaposlenika, datum zaposlenja (dd.MM.yyyy),
--  mail adresu, te ukupnu ostvarenu zaradu zaokruženu na dvije decimale. Izlaz sortirati po zaradi u opadajuæem redoslijedu.
  select P.FirstName, P.LastName ,CONVERT(VARCHAR,E.HireDate,104) AS 'Datum zaposljenja' , ROUND(SUM(SOD.UnitPrice*SOD.OrderQty),2) AS 'UKUPNA ZARADA'
 from Sales.SalesTerritory as st inner join Sales.SalesPerson as sp
 on sp.TerritoryID=st.TerritoryID inner join HumanResources.Employee as E
 on E.BusinessEntityID=sp.BusinessEntityID inner join Person.Person as P
 on P.BusinessEntityID=E.BusinessEntityID inner join Sales.SalesOrderHeader as soh
 on soh.SalesPersonID=sp.BusinessEntityID inner join Sales.SalesOrderDetail as SOD
 ON SOD.SalesOrderID=soh.SalesOrderID
 where ST.[Group] LIKE 'Europe'  AND YEAR(soh.OrderDate)=2014 AND MONTH(soh.OrderDate)=1 
 group by P.FirstName, P.LastName ,CONVERT(VARCHAR,E.HireDate,104)
 ORDER BY 4 DESC



 --northwind
USE Northwind

--Iz baze podataka Northwind prikati ime i prezime zaposlenika (spojeno) sa ukupnim brojem narudžbi koje je uradio. 
--Listu sortirati od zaposlenika sa najvećim brojem urađenih narudžbi.

--Modifikovati prethodni upistako da se prikaže broj narudžbi koje su urađene u 7. mjesecu 19997. godine,
--a prikazi samo one zaposlenike koji su uradili 5 ili vise narudžbi.
SELECT E.FirstName, E.LastName, COUNT(O.OrderID) AS 'Broj narudžbi'
FROM Employees AS E INNER JOIN Orders AS O
ON E.EmployeeID=O.EmployeeID
group by E.FirstName, E.LastName
order by COUNT(O.OrderID) desc

-- modifikacija
SELECT E.FirstName, E.LastName, COUNT(O.OrderDate) AS 'Broj narudžbi u 7. mjesecu 1997. godine'
FROM Employees AS E INNER JOIN Orders AS O
ON E.EmployeeID=O.EmployeeID
WHERE YEAR(OrderDate)=1997 and month(OrderDate)=7 
group by E.FirstName, E.LastName
having COUNT(O.OrderDate) >5

--Iz baze podataka Northwind prikazati listu proizvoda kojih nema na zalihama. Također, izlaz treba da sadrži naziv dobavljača, 
--broj telefona dobavljača, broj proizvoda na zalihama te koliko je komada prodano.
SELECT s.CompanyName, s.Phone, p.UnitsInStock, sum(OD.Quantity) AS 'Ukupno komada prodano'
FROM Products as p inner join Suppliers as s
on p.SupplierID=S.SupplierID join [Order Details] as OD
ON OD.ProductID=P.ProductID
WHERE p.UnitsInStock=0
group by s.CompanyName, s.Phone, p.UnitsInStock


--Pubs
USE pubs

--Iz baze podataka Pubs prikazati prodaju knjiga po prodavnicama. Izlaz treba da sadrži sljedeće kolone:
--naziv dobavljača, naziv prodavnice, naziv knjige i zaradu od prodaje. Potrebno je prikazati prodaju knjiga izdavača po imenom "New Moon Books".
SELECT P.pub_name, ST.stor_name, T.title, SUM(T.price*s.qty) as 'Ukupna zarada od prodaje'
FROM titles AS T inner join sales as s
on T.title_id=s.title_id inner join stores as ST
ON ST.stor_id=s.stor_id inner join publishers as P
on P.pub_id=T.pub_id
WHERE P.pub_name LIKE 'New Moon Books'
group by ST.stor_name, T.title ,P.pub_name


--adventureWorks2017
USE AdventureWorks2017

--Vaša firma ćeli da sazna neke informacije o svojim kupcima. Svake godine se analizira drugi region. Ove godine je došao red na kupce iz United States.
--Izlaz treba da sadrži: Ime i prezime kupca, ukupan broj narudžbi za prikazanog kupca, ukupnu količinu svih kupljenih proizvoda, region i grad iz kojeg kupac dolazi
--Uslovi su: 
--Pored onih kupaca koji su nesto kupili, lista treba da sadrzi i one koji nisu uradili niti jednu narudžbu.
--Ukoiko u izlazu postoji kolona u kojoj se pojavljuju NULL vrijednosti iste je potrebno zamijenti sa brojm 0
--Pored toga što se traže kupci iz US, na listu je potrebno dodati i one koji dolaze iz grada "Montreal"
SELECT  PP.FirstName + ' ' + PP.LastName as 'Ime i prezime kupca', COUNT(SOH.CustomerID) AS 'Broj narudzbi', 
ISNULL(SUM(sod.OrderQty),0) as 'Ukupna kolicina svih kupljenih proizvoda',sp.CountryRegionCode as 'Region', A.City
FROM Sales.Customer AS C inner join Person.Person as PP
on PP.BusinessEntityID=C.PersonID LEFT JOIN Sales.SalesOrderHeader AS SOH
ON SOH.CustomerID=C.CustomerID LEFT JOIN Sales.SalesOrderDetail AS SOD
ON SOH.SalesOrderID=SOD.SalesOrderID INNER JOIN Person.BusinessEntityAddress AS bes
ON PP.BusinessEntityID=bes.BusinessEntityID inner join Person.Address as A
on A.AddressID=bes.AddressID inner join Person.StateProvince as sp
on sp.StateProvinceID=A.StateProvinceID inner join Person.CountryRegion as cr
on cr.CountryRegionCode=sp.CountryRegionCode
WHERE sp.CountryRegionCode LIKE 'US' OR A.City LIKE 'Montreal'
group by PP.FirstName, PP.LastName, sp.CountryRegionCode, A.City


select *
from Person.[Address]
where City like 'Montreal'

select*
from Person.CountryRegion

SELECT*
FROM Person.StateProvince
WHERE CountryRegionCode LIKE 'US'


--Za kupca sa imenom i prezimenom 'Jordan Green' prikazati tipove i brojeve kartica koje posjeduje,
--te narudžbe koje je uradio koristeći kartice(broj narudžbe, datum narudžbe).
SELECT P.FirstName, P.LastName, cc.CardNumber, SOH.OrderDate, SOH.SalesOrderID, SOH.
FROM Person.Person AS P INNER JOIN Sales.Customer AS C
ON P.BusinessEntityID=C.PersonID INNER JOIN SALES.SalesOrderHeader AS SOH
ON SOH.CustomerID=C.CustomerID INNER JOIN SALES.PersonCreditCard AS PC
ON PC.BusinessEntityID=P.BusinessEntityID INNER JOIN SALES.CreditCard AS CC
ON PC.CreditCardID=CC.CreditCardID
WHERE P.FirstName='Jordan' AND P.LastName='Green' 



/*Vježba 1 :: Northwind*/
USE Northwind

--1. Prikazati listu zaposlenika sa sljedeæim atributima: ID, ime, prezime, država i titula, gdje je ID = 9 
--ili dolaze iz USA.
SELECT EmployeeID, FirstName, LastName,Country, Title
FROM Employees
WHERE EmployeeID=9 OR Country LIKE 'USA'

--2. Prikazati podatke o narudžbama koje su napravljene prije 19.07.1996. godine. Izlaz treba da sadrži 
--sljedeæe kolone: ID narudžbe, datum narudžbe, ID kupca, te grad.
SELECT OrderID, OrderDate, CustomerID, ShipCity
FROM Orders
WHERE OrderDate<'07.19.1996'

--3. Prikazati stavke narudžbe gdje je kolièina narudžbe bila veæa od 100 komada uz odobreni popust.
SELECT OrderID,Quantity
FROM [Order Details]
WHERE Quantity>100 AND Discount>0


--4. Prikazati ime kompanije kupca i kontakt telefon i to samo onih koji u svome imenu posjeduju rijeè „Restaurant“.
-- Ukoliko naziv kompanije sadrži karakter (-), kupce izbaciti iz rezultata upita.
SELECT CompanyName, Phone
FROM Customers
WHERE CompanyName LIKE '%Restaurant%' AND CompanyName NOT LIKE '%-%'

--5. Prikazati proizvode èiji naziv poèinje slovima „C“ ili „G“, drugo slovo može biti bilo koje, a treæe slovo
-- u nazivu je „A“ ili „O“.
SELECT ProductName, UnitPrice
FROM Products
WHERE ProductName LIKE '[CG]%' and ProductName like '__[ao]%'

--6. Prikazati listu proizvoda èiji naziv poèinje slovima „L“ ili „T“, ili je ID proizvoda = 46. Lista treba da
-- sadrži samo one proizvode èija je se cijena po komadu kreæe izmeðu 10 i 50. Upit napisati na dva naèina.

SELECT ProductID, ProductName, UnitPrice
FROM Products
WHERE ProductName LIKE '[LT]%' OR ProductID=46 AND UnitPrice BETWEEN 10 AND 50

--7. Prikazati naziv proizvoda i cijenu gdje je stanje na zalihama manje od naruèene kolièine. Takoðer,
-- u rezultate upita ukljuèiti razliku izmeðu naruèene kolièine i stanja zaliha.
SELECT ProductName, UnitPrice,UnitsOnOrder, UnitsInStock, UnitsOnOrder-UnitsInStock AS 'Razlika'
FROM Products
WHERE UnitsInStock<UnitsOnOrder

--8. Prikazati dobavljaèe koji dolaze iz Španije ili Njemaèke a nemaju unesen broj faxa.
-- Formatirati izlaz NULL vrijednosti. Upit napisati na dva naèina.

-- I nacin
SELECT SupplierID,CompanyName, ContactTitle,Country, ISNULL(Fax,'N/A')
FROM Suppliers
WHERE Country IN ('Spain', 'Germany') AND Fax IS NULL

--II nacin
SELECT SupplierID,CompanyName, ContactTitle,Country, ISNULL(Fax,'N/A')
FROM Suppliers
WHERE (Country LIKE 'Spain' OR Country LIKE  'Germany') AND Fax IS NULL



--sa vjezbi :: AdventureWorks2017
USE AdventureWorks2017

--Napisati upit koji prikazuje broj, naziv, boju i cijenu (ListPrice) prozivoda. Uslovi su da naziv
--proizvoda poèinje karakterima 'S' ili 'T', boja proizvoda je plava ili crna, a cijena je izmeðu 100 i 1000.
--Podatke sortirati po ocijeni opadajuæim redoslijedom. Upisati napisati na dva naèina.

--I nacin 
SELECT ProductNumber, Name, Color, ListPrice
FROM Production.Product
WHERE NAME LIKE '[ST]%' AND Color IN ('Blue', 'Black') AND ListPrice BETWEEN 100 AND 1000
ORDER BY ListPrice DESC
--II nacin
SELECT ProductNumber, Name, Color, ListPrice
FROM Production.Product
WHERE NAME LIKE '[ST]%' AND (Color like 'Blue' or Color like'Black') AND ListPrice BETWEEN 100 AND 1000
ORDER BY ListPrice DESC


--Napisati upit koji prikazuje narudžbe obavljenje u periodu od 01.06.2011. - 31.12.2011. godine. Uslov je
--da se prikau narudžbe gdje je ukupni iznos veæi od 100.000
SELECT SalesOrderID, OrderDate, TotalDue 
FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '07.01.2011' AND '12.31.2011' AND TotalDue> 100000

--Napisati upit koji prikazuje titulu te spojeno ime i prezime osoba koje nemaju uneseno srednje ime.
--Ukoliko titula nije unesena formatirati izlaz kolone kao 'N/A'
SELECT Title, FirstName+ ' ' + LastName AS 'Ime i prezime', ISNULL(MiddleName,'Nije uneseno') AS 'MiddleName'
FROM Person.Person
--WHERE MiddleName is null

--Napisati upit koji prikazuje korisnièko ime uposlenika (sve iza znaka '\' u koloni LoginID), titulu,
--datum zaposlenja, starost i staž zaposlenika. Uslov je da se prikaže 10 najstarijih uposlenika koji
--obavljaju bilo koju ulogu menadžera.
SELECT top 10 SUBSTRING(LoginID,CHARINDEX('\',LoginID) +1,10) AS 'Korisnicko ime',
JobTitle, HireDate, Datediff(YEAR,BirthDate,GETDATE()) AS 'Starost',
DATEDIFF(YEAR,HireDate,GETDATE()) AS 'Staz'
FROM HumanResources.Employee
WHERE JobTitle like '%Manager%'
ORDER BY Starost desc

--Napisati upit koji prikazuje 10 najskupljih stavki prodaje (detalji narudžbe) i to sljedeæe kolone: ID proizvoda
--kolièinu, cijenu, iznos(izraèunati). Cijenu i iznos zaokružizi na dvije decimale. Takoðer, 
--kolièinu prikazati u formatu "10kom", a cijenu i iznos u formatu "1000KM".
SELECT Top 10 ProductID, convert(NVARCHAR,OrderQty)+'kom'AS 'Kolièina',CONVERT(NVARCHAR,ROUND(UnitPrice,2))+'KM' AS 'Cijena',
CONVERT(NVARCHAR,ROUND(LineTotal,2))+'KM' AS 'Iznos'
FROM SALES.SalesOrderDetail
ORDER by LineTotal DESC















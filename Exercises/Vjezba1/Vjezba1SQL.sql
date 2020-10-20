/*Vje�ba 1 :: Northwind*/
USE Northwind

--1. Prikazati listu zaposlenika sa sljede�im atributima: ID, ime, prezime, dr�ava i titula, gdje je ID = 9 
--ili dolaze iz USA.
SELECT EmployeeID, FirstName, LastName,Country, Title
FROM Employees
WHERE EmployeeID=9 OR Country LIKE 'USA'

--2. Prikazati podatke o narud�bama koje su napravljene prije 19.07.1996. godine. Izlaz treba da sadr�i 
--sljede�e kolone: ID narud�be, datum narud�be, ID kupca, te grad.
SELECT OrderID, OrderDate, CustomerID, ShipCity
FROM Orders
WHERE OrderDate<'07.19.1996'

--3. Prikazati stavke narud�be gdje je koli�ina narud�be bila ve�a od 100 komada uz odobreni popust.
SELECT OrderID,Quantity
FROM [Order Details]
WHERE Quantity>100 AND Discount>0


--4. Prikazati ime kompanije kupca i kontakt telefon i to samo onih koji u svome imenu posjeduju rije� �Restaurant�.
-- Ukoliko naziv kompanije sadr�i karakter (-), kupce izbaciti iz rezultata upita.
SELECT CompanyName, Phone
FROM Customers
WHERE CompanyName LIKE '%Restaurant%' AND CompanyName NOT LIKE '%-%'

--5. Prikazati proizvode �iji naziv po�inje slovima �C� ili �G�, drugo slovo mo�e biti bilo koje, a tre�e slovo
-- u nazivu je �A� ili �O�.
SELECT ProductName, UnitPrice
FROM Products
WHERE ProductName LIKE '[CG]%' and ProductName like '__[ao]%'

--6. Prikazati listu proizvoda �iji naziv po�inje slovima �L� ili �T�, ili je ID proizvoda = 46. Lista treba da
-- sadr�i samo one proizvode �ija je se cijena po komadu kre�e izme�u 10 i 50. Upit napisati na dva na�ina.

SELECT ProductID, ProductName, UnitPrice
FROM Products
WHERE ProductName LIKE '[LT]%' OR ProductID=46 AND UnitPrice BETWEEN 10 AND 50

--7. Prikazati naziv proizvoda i cijenu gdje je stanje na zalihama manje od naru�ene koli�ine. Tako�er,
-- u rezultate upita uklju�iti razliku izme�u naru�ene koli�ine i stanja zaliha.
SELECT ProductName, UnitPrice,UnitsOnOrder, UnitsInStock, UnitsOnOrder-UnitsInStock AS 'Razlika'
FROM Products
WHERE UnitsInStock<UnitsOnOrder

--8. Prikazati dobavlja�e koji dolaze iz �panije ili Njema�ke a nemaju unesen broj faxa.
-- Formatirati izlaz NULL vrijednosti. Upit napisati na dva na�ina.

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
--proizvoda po�inje karakterima 'S' ili 'T', boja proizvoda je plava ili crna, a cijena je izme�u 100 i 1000.
--Podatke sortirati po ocijeni opadaju�im redoslijedom. Upisati napisati na dva na�ina.

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


--Napisati upit koji prikazuje narud�be obavljenje u periodu od 01.06.2011. - 31.12.2011. godine. Uslov je
--da se prikau narud�be gdje je ukupni iznos ve�i od 100.000
SELECT SalesOrderID, OrderDate, TotalDue 
FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '07.01.2011' AND '12.31.2011' AND TotalDue> 100000

--Napisati upit koji prikazuje titulu te spojeno ime i prezime osoba koje nemaju uneseno srednje ime.
--Ukoliko titula nije unesena formatirati izlaz kolone kao 'N/A'
SELECT Title, FirstName+ ' ' + LastName AS 'Ime i prezime', ISNULL(MiddleName,'Nije uneseno') AS 'MiddleName'
FROM Person.Person
--WHERE MiddleName is null

--Napisati upit koji prikazuje korisni�ko ime uposlenika (sve iza znaka '\' u koloni LoginID), titulu,
--datum zaposlenja, starost i sta� zaposlenika. Uslov je da se prika�e 10 najstarijih uposlenika koji
--obavljaju bilo koju ulogu menad�era.
SELECT top 10 SUBSTRING(LoginID,CHARINDEX('\',LoginID) +1,10) AS 'Korisnicko ime',
JobTitle, HireDate, Datediff(YEAR,BirthDate,GETDATE()) AS 'Starost',
DATEDIFF(YEAR,HireDate,GETDATE()) AS 'Staz'
FROM HumanResources.Employee
WHERE JobTitle like '%Manager%'
ORDER BY Starost desc

--Napisati upit koji prikazuje 10 najskupljih stavki prodaje (detalji narud�be) i to sljede�e kolone: ID proizvoda
--koli�inu, cijenu, iznos(izra�unati). Cijenu i iznos zaokru�izi na dvije decimale. Tako�er, 
--koli�inu prikazati u formatu "10kom", a cijenu i iznos u formatu "1000KM".
SELECT Top 10 ProductID, convert(NVARCHAR,OrderQty)+'kom'AS 'Koli�ina',CONVERT(NVARCHAR,ROUND(UnitPrice,2))+'KM' AS 'Cijena',
CONVERT(NVARCHAR,ROUND(LineTotal,2))+'KM' AS 'Iznos'
FROM SALES.SalesOrderDetail
ORDER by LineTotal DESC















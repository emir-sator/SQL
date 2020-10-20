/*Vježba 6 :: Northwind
1. U tabelu Customers dodati jednog kupca (testni podaci). Takoðer, u istu tabelu dodati 5 kupaca 
iz baze podataka AdventureWorks2014 (sluèajnim odabirom). Voditi raèuna o kompatibilnosti podataka.*/
USE Northwind
INSERT INTO Customers(CustomerID,CompanyName, City, Country)
VALUES(23,'TEST','Konjic','BIH')

USE AdventureWorks2014
INSERT INTO Northwind.[dbo].[Customers] (CustomerID, CompanyName)
SELECT TOP 5 LEFT(P.Rowguid,5), P.FirstName+' '+P.LastName
FROM PERSON.Person AS P INNER JOIN SALES.Customer AS C
ON P.BusinessEntityID=C.PersonID

select*
FROM PERSON.Person AS P INNER JOIN SALES.Customer AS C
ON P.BusinessEntityID=C.PersonID

select *
from Northwind.[dbo].[Customers]
USE Northwind
SELECT *
FROM Customers

/*2. Dodati novu kategoriju proizvoda i dobavljaèa, te 3 nova proizvoda (testni podaci).
 Proizvode pridružiti prethodno dodanoj kategoriji i dobavljaèu.*/

  --kategorija
 SET IDENTITY_INSERT  Categories OFF

 insert into Categories (CategoryID, CategoryName)
 values (99290,'TESTIC')
 
 --dobavljac
 SET IDENTITY_INSERT Suppliers ON

 INSERT INTO Suppliers(SupplierID,CompanyName)
 VALUES(13133,'EmirSator')

 --proizvodi
 SET IDENTITY_INSERT Products off

 SELECT *
 FROM Categories

 SELECT*
 FROM Suppliers

 INSERT INTO Products(ProductName,SupplierID,CategoryID)
 VALUES ( 'testè',13133,99290),
 ( 'tESTe',13133,99290),
 ( 'tESwT',13133,99290)

 SELECT *
 from Products



 /*
3. U tabelu Employees dodati 2 zaposlenika iz baze podataka AdventureWorks2014 (sluèajnim odabirom).
 Voditi raèuna o kompatibilnosti podataka.*/
 USE AdventureWorks2014
 INSERT INTO Northwind.dbo.Employees(FirstName,LastName, Title)
 SELECT TOP 5  P.FirstName, P.LastName, E.JobTitle
 FROM Person.Person AS P INNER JOIN HumanResources.Employee AS E
 ON P.BusinessEntityID=E.BusinessEntityID
 USE Northwind

 SELECT *
 FROM Employees

/*4. Dodati novu narudžbu. Kao vrijednost polja OrderDate postaviti trenutno vrijeme, 
jednog od kupaca koji je dodan u zadatku 1, te jednog od zaposlenika koji je dodan u zadatku 3.
 Za ostale kolone unijeti testne podatke.*/

 INSERT INTO Orders(CustomerID,EmployeeID,OrderDate)
 VALUES (23,14,getdate())

 SELECT *
 FROM Orders

/*5. Za prethodno dodanu narudžbu dodati detalje (Order Details) ukljuèujuæi sve proizvode koji su dodani u zadatku 2.
 Cijenu, kolièinu i popust postaviti proizvoljno.*/

 select *
 from [Order Details]

 select*
 from Products

 insert into [Order Details](ProductID,OrderID,UnitPrice,Quantity,Discount)
 values (80,11079,20,3,0),
 (81,11079,26,9,0.05),
 (82,11079,30,23,0.1)

 select *
 from [Order Details]


/*6. Nekom od kupaca dodanih u zadatku 1 izmijeniti broj telefona i fax.*/
UPDATE Customers
SET Phone=32442, Fax=24
from Customers
WHERE CustomerID='8609C'

select*
from Customers

/*7. Izmijeniti cijenu za nova 3 proizvoda (dodana u zadatku 2). Cijenu umanjiti za 10
 Takoðer, u svim detaljima narudžbe gdje su se pojavili proizvodi izvršiti umanjenje cijene.*/




UPDATE Products 
SET UnitPrice=20
from Products
where ProductID =80 
UPDATE Products 
SET UnitPrice=11
from Products
where ProductID =81 
UPDATE Products 
SET UnitPrice=18
from Products
where ProductID =82 

UPDATE Products
SET UnitPrice=UnitPrice-UnitPrice*0.1
FROM Products
where ProductID IN (80,81,82)

select * 
from Products

UPDATE [Order Details]
SET UnitPrice=UnitPrice-UnitPrice*0.1
FROM [Order Details]
WHERE ProductID IN (80,81,82)

select *
from [Order Details]


/*8. Obrisati sve zaposlenike koji nisu uradili niti jednu narudžbu.*/


DELETE FROM Employees
WHERE EmployeeID IN (SELECT E.EmployeeID
					FROM Employees AS E LEFT OUTER JOIN Orders AS O
					ON E.EmployeeID = O.EmployeeID
					GROUP BY E.EmployeeID
					HAVING COUNT(O.EmployeeID) < 1)

					select*
					from Employees

/*9. Obrisati sve kupce koji nisu uradili niti jednu narudžbu.*/
DELETE FROM Customers
WHERE CustomerID IN (SELECT C.CustomerID
					FROM Customers AS C LEFT OUTER JOIN Orders AS O
					ON C.CustomerID = O.CustomerID
					GROUP BY C.CustomerID
					HAVING COUNT(O.CustomerID) < 1)

					SELECT*
					FROM Customers

/*10. Obrisati narudžbu koja je dodana u zadatku 4 sa detaljima.*/



DELETE FROM [Order Details]
where OrderID=11079

DELETE FROM Orders
WHERE OrderID = 11079

SELECT* 
FROM Orders

SELECT*
FROM [Order Details]



use AdventureWorks2017
--Kreirati upit koji prikazuje kreditne kartice kojima je plaæeno više od 20 narudžbi. 
--U listu ukljuèiti ime i prezime vlasnika kartice, tip kartice, broj kartice,
--ukupan iznos plaæen karticom.*/
 SELECT PP.[FirstName]+ ' ' + [LastName], SCC.[CardType], SCC.[CardNumber], SUM(SSOD.[TotalDue])
 FROM [Person].[Person] AS PP INNER JOIN [Sales].[PersonCreditCard] as SPC
 ON pp.BusinessEntityID=SPC.BusinessEntityID inner join [Sales].[CreditCard] AS SCC
 ON SPC.CreditCardID=SCC.CreditCardID INNER JOIN [Sales].[SalesOrderHeader] AS SSOD
 ON SCC.CreditCardID=SSOD.CreditCardID
 GROUP BY PP.[FirstName]+ ' ' + [LastName], SCC.[CardType], SCC.[CardNumber]
 having COUNT(SSOD.SalesOrderID)>20



--Kreirati upit koji prikazuje kupce koji su u maju mjesecu 2014. godine naruèili 
--proizvod „Front Brakes“ u kolièini veæoj od 5 komada.*/
SELECT PP.FirstName+' '+LastName, SUM(sod.OrderQty) AS 'UKUPNA KOLICINA'
FROM [Person].[Person] as PP INNER JOIN [Sales].[Customer] AS SC
ON PP.BusinessEntityID=SC.PersonID INNER JOIN [Sales].[SalesOrderHeader] AS SSOD
ON SC.CustomerID=SSOD.CustomerID INNER JOIN [Sales].[SalesOrderDetail] AS SOD
ON SSOD.SalesOrderID=SOD.SalesOrderID inner join [Production].[Product] AS P
ON SOD.ProductID=P.ProductID 
WHERE P.[Name] like 'Front Brakes' AND MONTH(SSOD.OrderDate)=5 AND YEAR(SSOD.OrderDate)=2014
GROUP BY PP.FirstName+' '+LastName
HAVING SUM(SOD.OrderQty)>5


--Kreirati upit koji prikazuje kupce koji su u 7. mjesecu utrošili više od 200.000 KM.
--U listu ukljuèiti ime i prezime kupca te ukupni utrošak. Izlaz sortirati prema utrošku 
--opadajuæim redoslijedo*/
 SELECT PP.FirstName,PP.LastName, SUM(SSOD.TotalDue)
FROM [Person].[Person] as PP INNER JOIN [Sales].[Customer] AS SC
ON PP.BusinessEntityID=SC.PersonID INNER JOIN [Sales].[SalesOrderHeader] AS SSOD
ON SC.CustomerID=SSOD.CustomerID INNER JOIN Sales.SalesOrderDetail AS SOD
ON SSOD.SalesOrderID=SOD.SalesOrderDetailID
WHERE MONTH(ssod.OrderDate)=7
GROUP BY PP.FirstName,PP.LastName
HAVING SUM(sSOD.TotalDue)>200000

--4. Kreirati upit koji prikazuje zaposlenike koji su uradili više od 200 narudžbi.
--U listu ukljuèiti ime i prezime zaposlenika te ukupan broj uraðenih narudžbi. 
--Izlaz sortirati prema broju narudžbi opadajuæim redoslijedom*/
 select P.FirstName, P.LastName, COUNT(SOD.SalesOrderID)
 FROM [Person].[Person] as P INNER JOIN [HumanResources].[Employee] AS E
 on P.BusinessEntityID=E.BusinessEntityID INNER JOIN [Sales].[SalesPerson] as SP
 ON E.BusinessEntityID=SP.BusinessEntityID INNER JOIN [Sales].[SalesOrderHeader] AS SOD
 ON SP.BusinessEntityID=SOD.SalesPersonID
 GROUP BY P.FirstName, P.LastName
 HAVING COUNT(SOD.SalesOrderID)>200




-- Kreirati upit koji prikazuje proizvode kojih na skladištu 
--ima u kolièini manjoj od 30 komada. Lista treba da sadrži naziv proizvoda, naziv skladišta (lokaciju), stanje na skladištu
--i ukupnu prodanu kolièinu. U rezultate upita ukljuèiti i one proizvode koji nikad nisu prodavani.
--Ukoliko je ukupna prodana kolièina prikazana kao NULL vrijednost, izlaz formatirati brojem 0.*/
  
SELECT pp.Name,count(wo.StockedQty)  AS 'Stanje na skladistu',  l.Name, ISNULL(sum(wo.OrderQty),0) AS 'Ukupno prodano'
FROM Production.Product as pp inner join Production.ProductInventory as ppi
on pp.ProductID=ppi.ProductID inner join Production.Location as l 
on l.LocationID=ppi.LocationID left join Production.WorkOrder as wo 
on wo.ProductID=pp.ProductID
GROUP BY pp.Name,l.Name
having COUNT( wo.StockedQty)<30 
order by 4 desc



/*Kreirati upit koji prikazuje podatke o zaposlenicima. Lista treba da sadrži 
sljedeæe kolone: ime i prezime zaposlenika (spojeno), korisnièko ime, novu lozinku, 
starost i staž zaposlenika. Uslovi su sljedeæi:
•	Za korisnièko ime potrebno je koristiti kolonu LoginID (tabela Employees).
 Npr. LoginID zaposlenika sa imenom i prezimenom 'Mary Gibson' je adventure-works\mary0. 
 Korisnièko ime zaposlenika je sve što se nalazi iza znaka \ (backslash) što je u ovom
  primjeru mary0,
•	Nova lozinka se formira koristeæi hešovanu lozinku zaposlenika na sljedeæi naèin:
o	Hešovanu lozinku potrebno je okrenuti obrnuto (npr. dbms2015 -> 5102smbd)
o	Nakon toga preskaèemo prvih 5 i uzimamo narednih 8 karaktera
o	Sljedeæi korak jeste da iz dobivenog stringa poèevši od drugog karaktera naredna dva zamijenimo
 sa X# (npr. ako je dobiveni string dbms2015 izlaz æe biti dX#s2015)
•	Starost i staž se formiraju na osnovu kolona BirthDate i HireDate
Prikazati podatke samo za zaposlenike ženskog spola koji imaju više od 50 godina i više od 5 godina
 staža.*/
SELECT p.FirstName+' '+p.LastName AS 'Ime i prezime', replace(e.LoginID,'adventure-works\', ' ') AS 'username',
DATEDIFF(YEAR,E.BirthDate,GETDATE())as 'starost' ,DATEDIFF(YEAR,E.HireDate,GETDATE()) AS 'Staz',
REVERSE(SUBSTRING(pas.passwordhash,5,8))AS 'password',stuff(reverse(SUBSTRING(pas.passwordhash,5,8)),2,2,'X#') AS'Izmjena'
FROM person.Person AS p inner join HumanResources.Employee AS e on e.BusinessEntityID=p.BusinessEntityID
inner join Person.Password AS pas on pas.BusinessEntityID=p.BusinessEntityID
WHERE e.Gender='F' and DATEPART (YEAR, GETDATE()) - DATEPART (YEAR, E.BirthDate) >50 and
(DATEPART (YEAR, GETDATE()) - DATEPART (YEAR, E.HireDate)) >5





--Prikazati ukupnu kolièinu prodaje i ukupnu zaradu od proizvoda po teritoriji. 
--Uzeti u obzir samo prodaju u sklopu ponuede pod nazivom “Volume Discount 11 to 14”.
SELECT ST.Name ,SUM(SOD.OrderQty) AS 'Ukupna količina',
       ROUND(SUM(SOD.UnitPrice*SOD.OrderQty-sod.UnitPrice*SOD.UnitPriceDiscount),2) AS 'Ukupna zarada'
FROM [Sales].[SalesTerritory] AS ST INNER JOIN [Sales].[SalesOrderHeader] AS SOH
ON ST.TerritoryID=SOH.TerritoryID INNER JOIN [Sales].[SalesOrderDetail] AS SOD
ON SOH.SalesOrderID=SOD.SalesOrderID INNER JOIN [Production].[Product] AS P
ON SOD.ProductID=P.ProductID INNER JOIN [Sales].[SpecialOfferProduct] AS SOP
ON P.ProductID=SOP.ProductID inner join [Sales].[SpecialOffer] AS SO
ON SOP.SpecialOfferID=SO.SpecialOfferID
Where SO.Description LIKE 'Volume Discount 11 to 14'
Group by ST.Name
order by 3 desc





/* Kreirati upit koji prikazuje èetvrtu najveæu platu u preduzeæu (po visini primanja).
 Tabela EmployeePayHistory.*/
SELECT  T.[Ime i prezime],
        T.Plata
FROM    (
            SELECT TOP 10 CONCAT(P.FirstName, ' ', P.LastName) AS [Ime i prezime],
                    EPH.Rate AS Plata,
                    ROW_NUMBER() OVER (ORDER BY EPH.Rate DESC) AS Rbr
            FROM    HumanResources.EmployeePayHistory AS EPH
                INNER JOIN HumanResources.Employee AS E
                    ON E.BusinessEntityID = EPH.BusinessEntityID
                INNER JOIN Person.Person AS P
                    ON E.BusinessEntityID = P.BusinessEntityID
					ORDER BY EPH.Rate DESC --provjera
        ) AS T
		
WHERE   T.Rbr = 4
--ILI
SELECT TOP 1 T.Rate , T.FirstName + ' ' + T.LastName AS 'Ime i prezime'
FROM (SELECT TOP 4 Rate, P.FirstName, P.LastName
      FROM  HumanResources.EmployeePayHistory AS EPH  JOIN HumanResources.Employee AS E
            ON EPH.BusinessEntityID = E.BusinessEntityID JOIN Person.Person AS P
            ON E.BusinessEntityID = P.BusinessEntityID
      ORDER BY Rate DESC) AS T
ORDER BY Rate ASC

/*Kreirati upit koji prikazuje naziv proizvoda, naziv lokacije, 
stanje zaliha na lokaciji,
 ukupno stanje zaliha na svim lokacijama i ukupnu prodanu kolièinu. 
 Uzeti u obzir prodaju samo u 2013. Godini.*/

 SELECT P.Name, L.Name,  ppi.Quantity, SUM(PPI.Quantity) 'Ukupno stanje na zalihama na svim lokacijama', sum(SOd.OrderQty) 'ukupna prodana kolicina'
 FROM Production.Product AS P INNER JOIN [Production].[ProductInventory] AS PPI
 ON P.ProductID= PPI.ProductID INNER JOIN Production.Location AS L
 ON PPI.LocationID=l.LocationID INNER JOIN    Sales.SpecialOfferProduct as sop
 on sop.ProductID=p.ProductID inner join Sales.SalesOrderDetail as SOD
 ON P.ProductID=SOD.ProductID INNER JOIN Sales.SalesOrderHeader AS SOH
 ON SOD.SalesOrderID=SOH.SalesOrderID
 WHERE year(SOH.OrderDate)=2013
 group by P.Name, L.Name,  ppi.Quantity


SELECT  P.Name AS [Naziv proizvoda],
        L.Name AS [Naziv lokacije],
        PI.Quantity AS [Stanje na zalihama],
        (
            SELECT  SUM(P2.Quantity)
            FROM    Production.ProductInventory AS P2
            WHERE   P.ProductID = P2.ProductID
        ) AS [Ukupno na svim lokacijama],
        (
            SELECT  SUM(SOD.OrderQty)
            FROM    Sales.SalesOrderDetail AS SOD
            WHERE   P.ProductID = SOD.ProductID AND  SOD.SalesOrderID IN (
                                                                            SELECT  SOH.SalesOrderID
                                                                            FROM    Sales.SalesOrderHeader AS SOH
                                                                            WHERE   DATEPART(YEAR, SOH.OrderDate) = 2013
                                                                         )
        ) AS [Ukupna prodana kolicina]
FROM    Production.Product AS P
    INNER JOIN  Production.ProductInventory AS PI
        ON P.ProductID = PI.ProductID
    INNER JOIN Production.Location AS L
        ON PI.LocationID = L.LocationID
ORDER BY [Ukupna prodana kolicina] DESC
GO

 /*Kreirati upit koji prikazuje ukupnu kolièinu utrošenog novca po kupcu. 
Izlaz treba da sadrži sljedeæe kolone: ime i prezime kupca, tip kreditne kartice, 
broj kartice i ukupno utrošeno. Pri tome voditi raèuna da izlaz sadrži:
a)	Samo troškove koje su kupci napravili koristeæi kredite kartice,
b)	Samo one kupce koji imaju više od jedne kartice, 
c)	Prikazati i one kartice sa kojima kupac nije obavljao narudžbe,
d)	Ukoliko vrijedost kolone utrošeno bude nepoznata, zamijeniti je brojem 0 (nula),
e)	Izlaz treba biti sortiran po prezimenu kupca abecedno i kolièini utrošenog novca 
opadajuæim redoslijedom.
Tabele: Customer, Person, PersonCreditCard, CreditCard, SalesOrderHeader, SalesOrderDetail
Napomena: Za prikaz rezultata upita izvršiti skriptu AWCreditCardsScript.
*/

SELECT  p.FirstName, p.LastName, CC.CardType ,CC.CardNumber, COALESCE((
                    SELECT  SUM(SOH2.TotalDue)
                    FROM    Sales.SalesOrderHeader AS SOH2
                    WHERE   CC.CreditCardID = SOH2.CreditCardID
                ), 0) AS [Ukupno utroseno]
				--ISNULL(sum(SOH.TotalDue),'0') as 'ukupno utroseno'
FROM Sales.Customer AS C INNER JOIN Person.Person AS P
ON C.PersonID=P.BusinessEntityID INNER JOIN Sales.PersonCreditCard AS PCC
ON P.BusinessEntityID=PCC.BusinessEntityID INNER JOIN Sales.CreditCard AS CC
ON PCC.CreditCardID=CC.CreditCardID INNER JOIN Sales.SalesOrderHeader AS SOH
ON CC.CreditCardID =SOH.CreditCardID INNER JOIN Sales.SalesOrderDetail AS SOD
ON SOH.SalesOrderID=SOD.SalesOrderID 
WHERE SOH.CreditCardID is not null 
GROUP BY p.FirstName, p.LastName, CC.CardType ,CC.CardNumber
having COUNT(pcc.CreditCardID)>1
ORDER BY p.LastName ,SUM(SOH.TotalDue) desc


SELECT  CONCAT(P.FirstName, ' ', P.LastName) AS [Ime i prezime],
        CC.CardType AS [Tip kredidtne kartice],
        CC.CardNumber AS [Broj kreditne kartice],
        COALESCE((
                    SELECT  SUM(SOH2.TotalDue)
                    FROM    Sales.SalesOrderHeader AS SOH2
                    WHERE   CC.CreditCardID = SOH2.CreditCardID
                ), 0) AS [Ukupno utroseno]
FROM    Sales.Customer AS C
    INNER JOIN Person.Person AS P
        ON C.PersonID = P.BusinessEntityID
    INNER JOIN Sales.PersonCreditCard AS PCC
        ON P.BusinessEntityID = PCC.BusinessEntityID
    INNER JOIN Sales.CreditCard AS CC
        ON PCC.CreditCardID = CC.CreditCardID
    INNER JOIN Sales.SalesOrderHeader AS SOH
        ON C.CustomerID = SOH.CustomerID
WHERE   (
            SELECT  COUNT(PCC2.CreditCardID)
            FROM    Sales.PersonCreditCard AS PCC2
            WHERE   P.BusinessEntityID = PCC2.BusinessEntityID
            GROUP BY PCC2.BusinessEntityID
        ) > 1
        AND SOH.CreditCardID IS NOT NULL
GROUP BY P.FirstName, P.LastName, CC.CardType, CC.CardNumber, CC.CreditCardID
ORDER BY    P.LastName,
            [Ukupno utroseno] DESC


--Northwind
use Northwind


--Menadžment firme želi da nagradi kupca koji je utrošio najviše novca u februaru mjesecu. Zbog ograničenih sredstava ovaj put če biti nagrađen
--samo kupac koji dolazi iz londona. Prikazati kupca sa sljedećim podacima: Ime i prezime (ContactName), adresa, telefon i ukupno utrošeno.
--Kolonu ukupno utrošeno formatirati na sljedeći način: 1000KM.
SELECT top 1 C.ContactName, C.Address, c.Phone,convert(VARCHAR,SUM(OD.UnitPrice*OD.Quantity))+'KM' AS 'Ukupno utroseno'
FROM Customers as C inner join Orders AS O
ON O.CustomerID=C.CustomerID INNER JOIN [Order Details] AS OD
ON OD.OrderID=O.OrderID
WHERE c.City like 'London' AND MONTH(O.OrderDate)=2
GROUP BY C.ContactName, C.Address, c.Phone
ORDER BY SUM(OD.UnitPrice*OD.Quantity) desc


--Pubs
USE pubs


--Koristeći bazu podataka pubs, prikazati listu zaposlenika (ime i prezime) sa sljedećim podacima za svakog zaposlenog:
--minimalna, maksimalna, srednja i ukupna količinaq prodatih artikala (knjiga). Uslovi su: ukupna prodaja treba biti veća od 100, 
--a srednja između 20 i 25 uključujići i granične vrijednosti
SELECT E.fname+ ' '+E.lname, MIN(S.qty) as 'Mininalna kolicina prodatih knjiga',
MAX(S.qty) as 'Maksimalna kolicina prodatih knjiga',
AVG(S.qty) as 'Prosjecna kolicina prodatih knjiga',
sum(S.qty) as 'Ukupna kolicina prodatih knjiga'
FROM employee AS E inner join publishers as p
on p.pub_id=E.pub_id INNER JOIN titles as T 
ON p.pub_id=T.pub_id INNER JOIN sales AS S
ON S.title_id=T.title_id
group by E.fname+ ' '+E.lname
HAVING SUM(S.qty) >100 AND AVG(S.qty) between 10 and 50


--adventureWorks2014
USE AdventureWorks2014


--Primjer se radi na adventureWorks2014 bazi. Potrebno je prikazati informacije o kreditnim karticama kupaca. Izlaz treba da sadrži sljedeće kolone:
--ime i prezime kupca, email, adresu, tip kartice, broj kartice i godinu isteka kartice. Uslovi su sljedeći:
--a)Prikazati samo Vista kartice koje ističu u 2008. godini
--b)Na listu uključiti i kupce koji nisu radili niti jednu narudžbu koristeći karticu
--c)Eliminisati duplikate u rezultatima upita
--d)Izlaz sortirati abecedno po prezimenu
SELECT DISTINCT   P.FirstName, P.LastName , e.EmailAddress, cc.CardType, cc.CardNumber,cc.ExpYear
FROM Person.Person AS P INNER JOIN SALES.Customer AS C
ON P.BusinessEntityID=C.PersonID INNER JOIN PERSON.EmailAddress AS E
ON E.BusinessEntityID=P.BusinessEntityID INNER JOIN SALES.PersonCreditCard AS PCC
ON PCC.BusinessEntityID=P.BusinessEntityID INNER  JOIN SALES.CreditCard AS CC
ON CC.CreditCardID=PCC.CreditCardID LEFT JOIN Sales.SalesOrderHeader AS SOH
ON SOH.CreditCardID=CC.CreditCardID
WHERE cc.CardType LIKE 'Vista' AND CC.ExpYear=2008
ORDER BY P.LastName




 







   
   
   
   
   
   
   
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
   SELECT PP.[Name],ISNULL(WO.StockedQty, 0)  AS skladiste,  l.[Name], sum(sod.OrderQty) AS ukupno
FROM Production.Product as PP inner join Production.ProductInventory as PPI 
on PP.ProductID=PPI.ProductID inner join Production.Location as L
on L.LocationID=PPI.LocationID inner join Production.WorkOrder as WO
on WO.ProductID=PP.ProductID left outer join Sales.SalesOrderDetail as SOD 
on sod.ProductID=pp.ProductID
WHERE StockedQty<30 
GROUP BY PP.[Name],ISNULL(wo.StockedQty, 0), l.[Name]











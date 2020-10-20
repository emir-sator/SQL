/*Vježba 2 :: Pubs*/

USE pubs
--1. Prikazati listu autora sa sljedeæim kolonama: ID, ime i prezime (spojeno), 
--grad i to samo one autore èiji ID poèinje brojem 8 ili dolaze iz grada „Salt Lake City“.
--Takoðer autorima status ugovora treba biti 1. Koristiti aliase nad kolonama.
SELECT au_id AS 'ID autora', au_fname + ' '+ au_lname AS 'Ime i prezime autora',city AS 'Grad'
FROM authors
WHERE (au_id LIKE '8%' or city like 'Salt Lake City') AND [contract]=1

--2. Prikazati sve tipove knjiga bez duplikata. Listu sortirati po tipu.

SELECT DISTINCT [type]
FROM titles
ORDER BY [type]


--3. Prikazati listu prodaje knjiga sa sljedeæim kolonama: ID prodavnice, broj narudžbe i kolièinu, 
--ali samo gdje je kolièina izmeðu 10 i 50, ukljuèujuæi i graniène vrijednosti. Rezultat upita sortirati
-- po kolièini opadajuæim redoslijedom. Upit napisati na dva naèina.

--I nacin
SELECT stor_id, ord_num, ord_date, qty
FROM sales
WHERE qty between 10 AND 50 
ORDER BY qty DESC
--II nacin
SELECT stor_id, ord_num, ord_date, qty
FROM sales
WHERE qty >= 10 AND qty <=50 
ORDER BY qty DESC





--4. Prikazati listu knjiga sa sljedeæim kolonama: naslov, tip djela i cijenu. Kao novu kolonu dodati 20% od
-- prikazane cijene (npr. Ako je cijena 19.99 u novoj koloni treba da piše 3,998). Naziv kolone se treba zvati
-- „20% od cijene“. Listu sortirati abecedno po tipu djela i po cijeni opadajuæim redoslijedom.
-- Sa liste eliminisati one vrijednosti koje u polju cijena imaju nepoznatu vrijednost.
--Modifikovati upit tako da prikaže cijenu umanjenu za 20 %. Naziv kolone treba da se zove „Cijena umanjena za 20%“.
SELECT title, [type], price ,  price*0.2 AS '20% od cijene', price-price*0.2 AS 'Cijena umanjena za 20%'
FROM titles
WHERE price is not null
ORDER BY [type], price desc

--5. Prikazati 10 kolièinski najveæih stavki prodaje. Lista treba da sadrži broj narudžbe, datum narudžbe i kolièinu. 
-- da li ima više stavki sa kolièinom kao posljednja u listi.
SELECT top 10 with ties ord_num, ord_date, qty 
FROM sales 
order by qty  desc 

--sa vjezbe 
--
USE Northwind


--Prikazati ime kompanije kupca, grad i fax. Uslov je da kupci u svome imenu posjeduju riječ "Restaurant" ili dolaze iz Madrida. 
--Također, uslov je da kupci imaju unesen fax. Listu sortirati abecedno po imenu kompanije. (5 zapisa).
SELECT CompanyName, Fax, City
FROM Customers
WHERE (CompanyName like '%Restaurant%' or City like 'Madrid') AND Fax IS NOT NULL
ORDER BY CompanyName

--Prikazati dobavljače koji dolaze iz Njemačke ili Francuske, a njihovo ime kompanije počinje slovima A, E ili P.
--Upit napisati na dva načina. (3 zapisa)
SELECT SupplierID, Country, CompanyName
FROM Suppliers
WHERE Country IN ('Germany', 'France') AND CompanyName LIKE '[AEP]%'

SELECT SupplierID, Country, CompanyName
FROM Suppliers
WHERE (Country like 'Germany' OR Country like 'France') AND CompanyName LIKE '[AEP]%'

--Pubs
USE pubs

--Prikazati naslov djela, tip djela i cijenu. Kao novu kolonu dodati cijenu sa popustom od 20%. Uslov je da nova cijena (sa popustom) 
--bude između 10 i 20. Listu sortirati abecedno po tipu djela, te po novoj cijeni opadajućim redoslijedom. (9 zapisa)
SELECT title, type, price, price-(price*0.2)  AS 'Cijena sa popustom'
FROM titles
WHERE price-(price*0.2) BETWEEN 10 AND 50
ORDER BY type, 3 DESC

--AdventureWorks2017
use AdventureWorks2017

--Prikazati minimalnuz, prosječnu i maksimalnu cijenu prozivoda
SELECT MIN(ListPrice) AS 'Mininalna cijena',
MAX(ListPrice) as 'Maksimalna cijena',
AVG(ListPrice) AS 'Prosjecna cijena'
FROM Production.Product

--Prikazati 10 najprodavanijih proizvoda i zaradu od prodaje proizvoda ali samo onih gdje je zarada veća od 30.000. (4 zapisa)
SELECT TOP 10 SalesOrderID, SUM(OrderQty),SUM(UnitPrice*OrderQty) AS 'Zarada'
FROM Sales.SalesOrderDetail
group by SalesOrderID
HAVING SUM(UnitPrice*OrderQty)>30000

--Prikazati broj proizvoda po kategoriji. Listu sortirati poadajućim redoslijedom po broju proizvoda.
--Prikazati samo 10 kategorija. Također, provjeriti da li ima kategorija koji imaju isti broj proizvoda kao ona na 10. mjestu.
SELECT top 10 with ties C.ProductCategoryID, COUNT(p.ProductID) AS 'Broj proizvoda'
FROM Production.Product AS P INNER JOIN Production.ProductSubcategory AS PS
ON P.ProductSubcategoryID = PS.ProductSubcategoryID INNER JOIN Production.ProductCategory AS C
ON PS.ProductCategoryID=C.ProductCategoryID
group by C.ProductCategoryID
ORDER BY COUNT(ProductID) DESC

--Kreirati poruku dobrodošlice za kupce u sljedećem formatu: Dobrodošli, [Ime Prezime] trenutno je vrijeme: 12:00 (trenutno vrijeme)
--I nacin
SELECT 'Dobrodosli'+' '+ FirstName+ ' '+ LastName +' '+ 'trenutno je:'+RIGHT(CONVERT(NVARCHAR,GETDATE()),7)
FROM Person.Person 

--II nacin
SELECT 'Dobrodosli'+' '+ FirstName+ ' '+LastName +' '+ 'trenutno je:'+CONVERT(NVARCHAR,datepart(hour,GETDATE()))+ ':' + convert(NVARCHAR,datepart(minute,GETDATE()))
FROM Person.Person 

--Northwind
USE Northwind

--Kompanija je odlučila da svojim zaposlenicima dodijeli mail adrese. Za tu svrhz će iskoristiti postojoće podatke iz baze podataka.
--Izlaz treba biti u formatu tri nove kolone: Email, Lozinka i starost zaposlenika.
--EMAIL - email se formira od podataka u kolonama: LastName, FirstName, City i to u sljedećem formatu: LastName.FirstName@City.com (sve malim slovima)
--LOZINKA - lozinka se formira od podataka iz kolona: Notes, Title i Adress na sljedeći način:
--Spajanjem kolona (Notes, Title i Adress). Sljedeći korak jeste da se sadržaj spajanja okrene obrnuto ( nprs. dmbs2013, 3102sbmd).
--Nakon toga, iz dobivenog stringka preskačemo prvih 10 karakte i uzimamo sljedećih 15. Na pojedinim mjestima će se pojaviti razma, isti je potrebno zamije
--znako '#'. Uzeti zadnjih 8 karaktera.
--STAROST - starost se formima na osnovu kolene BirthDate i trenutnog datuma.
SELECT LOWER(FirstName+'.'+LastName+'@'+City+'.'+'Com') AS 'Email', 
right(REPLACE(SUBSTRING(REVERSE(CONVERT(NVARCHAR,Notes)+Title+Address),10,15),' ','#'),8) AS 'Lozinka',
datediff(YEAR,BirthDate,GETDATE()) AS 'Starost'
FROM Employees













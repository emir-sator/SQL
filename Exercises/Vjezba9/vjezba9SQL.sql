/*
Vježba 9
NAPOMENA: Vježba se radi nad bazom podataka kreiranoj u vježbi 7.
1. Kreirati stored proceduru za upis podataka u tabelu Kandidati. Izvršiti proceduru,
 tj. dodati novog kandidata sa testnim podacima.
2. Kreirati stored proceduru za izmjenu podataka u tabeli Kandidati. Izvršiti proceduru,
 tj. izmijeniti odreðene podatke za prethodno dodanog kandidata.
3. Kreirati stored proceduru za brisanje zapisa iz tabele Kandidati. Izvršiti proceduru,
 tj. obrisati prethodno dodanog kandidata.
4. Modifikovati stored proceduru kreiranu u zadatku 1. U istoj proceduri omoguæiti dodavanje kandidata 
te mu pridružiti rezultate testiranja za dva postojeæa testa (koristiti podupit za preuzimanje neophodnih 
podataka o testovima). U proceduri koristiti dvije INSERT komande (tabele: Kandidati, RezultatiTesta). 
Izvršiti proceduru, tj. dodati novog kandidata sa rezultatima testiranja.
5. Kreirati view (pogled) nad podacima koji æe sadržavati sljedeæa polja: ime i prezime, jmbg,
 telefon i email kandidata, zatim datum, naziv, oznaku, oblast i max. broj bodova na testu, te polje položio,
  osvojene bodove i procentualni rezultat testa.
6. Kreirati stored proceduru koja æe na osnovu proslijeðenih parametara @OznakaTesta i
 @JMBG prikazivati rezultate testiranja. Kao izvor podataka koristiti prethodno kreirani view. 
 Izvršiti proceduru, tj.prikazati rezultate testiranja za odreðenog kandidata.
7. Kreirati trigger koji æe sprijeèiti brisanje rezultata testiranja. Ukoliko se pokuša obrisati zapis 
u tabeli RezultatiTesta ispisati odgovarajuæu poruku.
8. Kreirati stored proceduru za brisanje zapisa u tabeli Testovi ukljuèujuæi sve rezultate testiranja.
 Trigger kreiran u zadatku 7 treba da sprijeèi izvršavanje ove procedure
  ukoliko za odabrani test postoje rezultati testiranja.*/

  USE IB150031
 --1. 
 CREATE PROCEDURE usp_dodaj_kandidata
  (
  @Ime NVARCHAR(30),
  @Prezime NVARCHAR(30),
  @JMBG NVARCHAR(13),
  @DatumRodjenja DATE,
  @MjestoRodjenje NVARCHAR(30),
  @Telefon NVARCHAR(20),
  @Email NVARCHAR(50)
  
  )
  as 
  BEGIN
  INSERT INTO Kandidati
  values(@Ime,@Prezime,@JMBG,@DatumRodjenja,@MjestoRodjenje,@Telefon, @Email)

  END 

  EXEC usp_dodaj_kandidata 'Emir','Sator',1234567891023,'10.04.1996','Konjic', '2244422', 'emir.emir@hotmail.com'

  SELECT*
  FROM Kandidati

  --2.
  create  PROCEDURE usp_izmjeni_kandidata
  (
  @Ime NVARCHAR(30),
  @Prezime NVARCHAR(30),
  @JMBG NVARCHAR(13),
  @DatumRodjenja DATE,
  @MjestoRodjenje NVARCHAR(30)=NULL,
  @Telefon NVARCHAR(20)=NULL,
  @Email NVARCHAR(50)NULL,
  @KandidatID INT
  )
  as 
  BEGIN
  UPDATE  Kandidati
  SET Ime=@Ime,Prezime=@Prezime,JMBG=@JMBG,DatumRodjenja=@DatumRodjenja,
  MjestoRodjenja=@MjestoRodjenje,Telefon=@Telefon, Email=@Email
  WHERE KandidatID=@KandidatID
  
  END 

  EXEC usp_izmjeni_kandidata  'Emir','Sator',1234567891023,'10.05.1996','Konjic', '2211122', 'emir.emir@hotmail.com',11

  select*
  from Kandidati

  --3.


   CREATE PROCEDURE usp_brisanje_kandidata
  (
  @KandidatID INT
  
  )
  AS 
  BEGIN 
  DELETE FROM Kandidati
  WHERE KandidatID=@KandidatID
  END

  EXEC usp_brisanje_kandidata 11

  SELECT*
  FROM Kandidati

  --4.

  drop procedure usp_dodaj_kandidata_test
   CREATE PROCEDURE usp_dodaj_kandidata_test
  (
  @Ime NVARCHAR(30),
  @Prezime NVARCHAR(30),
  @JMBG NVARCHAR(13),
  @DatumRodjenja DATE,
  @MjestoRodjenje NVARCHAR(30),
  @Telefon NVARCHAR(20),
  @Email NVARCHAR(50),

  @TestID INT,
  @KandidatID INT,
  @Polozio BIT,
  @OsvojeniBodovi DECIMAL,
  @Napomena NVARCHAR(MAX)

  )
  as 
  BEGIN
  INSERT INTO Kandidati
  values(@Ime,@Prezime,@JMBG,@DatumRodjenja,@MjestoRodjenje,@Telefon, @Email)

  set @KandidatID=SCOPE_IDENTITY()
   
  INSERT INTO RezultatiTesta
  values(@TestID,SCOPE_IDENTITY() ,@Polozio ,@OsvojeniBodovi,@Napomena)
  END 

  EXEC usp_dodaj_kandidata_test 'tEST9','Tes1t9',135577955234,'10.05.1997','TESTNO1','123445', 'test.test9@hotmail.com', 5,0, 1,10,'TEST'
  



  SELECT*
  FROM RezultatiTesta

  select*
  from Kandidati
  delete from Kandidati
  where KandidatID IN (18,20,21)
  select*
  from Testovi


  --ili kao sto je trazeno u zadatku
  --4.
 CREATE PROCEDURE Unos_Kandidata_Testa

@Ime nvarchar(20),
@Prezime nvarchar(20),
@JMBG nvarchar(13),
@DatumRodjenja date,
@MjestoRodjenja nvarchar(20),
@Telefon nvarchar(20),
@Email nvarchar(50),

@Polozio bit,
@OsvojeniBodovi decimal,
@Napomena text

AS

BEGIN

INSERT INTO Kandidati (Ime, Prezime, JMBG, DatumRodjenja, MjestoRodjenja, Telefon, Email)
VALUES (@Ime, @Prezime, @JMBG, @DatumRodjenja, @MjestoRodjenja, @Telefon, @Email)

INSERT INTO RezultatiTesta (TestID, KandidatID, Polozio, OsvojeniBodovi, Napomena)
SELECT TOP 2 TestID, (SELECT TOP 1 KandidatID FROM Kandidati ORDER BY KandidatID DESC),
 @Polozio, @OsvojeniBodovi, @Napomena
FROM Testovi
ORDER BY TestID

END;

EXEC Unos_Kandidata_Testa'Emir', 'Sator', '1234567891239', '1995-9-12', 'Konjic',
 '062-000-000', 'emir@mail.com', 1, 15, 'Napomena';

SELECT *
FROM Kandidati

GO

SELECT*
FROM Testovi
SELECT *
FROM RezultatiTesta
GO

-- 5.
/*5. Kreirati view (pogled) nad podacima koji æe sadržavati sljedeæa polja: ime i prezime, jmbg,
 telefon i email kandidata, zatim datum, naziv, oznaku, oblast i max. broj bodova na testu, te polje položio,
  osvojene bodove i procentualni rezultat testa.*/
  CREATE VIEW Pogled
  AS
  SELECT K.Ime+' '+K.Prezime AS 'Ime i prezime', K.JMBG, K.Telefon,K.Email, T.Datum,T.Naziv,T.Oznaka, T.MaxBrojBodova, RT.Polozio,RT.OsvojeniBodovi,
  (RT.OsvojeniBodovi/T.MaxBrojBodova)*100 as 'Procenat'
  FROM Kandidati as K inner join RezultatiTesta AS RT
  ON K.KandidatID= RT.KandidatID INNER JOIN Testovi AS T
  ON T.TestID=RT.TestID
  
SELECT *
FROM Pogled


/*6. Kreirati stored proceduru koja æe na osnovu proslijeðenih parametara @OznakaTesta i
 @JMBG prikazivati rezultate testiranja. Kao izvor podataka koristiti prethodno kreirani view. */
 CREATE PROCEDURE usp_PrikazNaOsnovuParametara
 (
 @JMBG NVARCHAR(13)=NULL,
 @Oznaka NVARCHAR(10)=NULL
 
 
 )
AS
BEGIN
SELECT *
FROM Pogled 
WHERE JMBG=@JMBG AND Oznaka=@Oznaka

END 

SELECT*
FROM Pogled

EXEC  usp_PrikazNaOsnovuParametara '0E996A570AED9', 'T2'


/*
7. Kreirati trigger koji æe sprijeèiti brisanje rezultata testiranja. Ukoliko se pokuša obrisati zapis 
u tabeli RezultatiTesta ispisati odgovarajuæu poruku*/

ALTER TABLE RezultatiTesta
DROP CONSTRAINT FK_Test

ALTER TABLE RezultatiTesta
ADD CONSTRAINT FK_Test FOREIGN KEY (TestID) REFERENCES Testovi(TestID) 

CREATE TRIGGER Brisanje ON RezultatiTesta
INSTEAD OF DELETE
AS 
BEGIN 
PRINT ('Nije dozvoljeno brisanje zapisa u tabeli')
ROLLBACK
END 

SELECT*
FROM RezultatiTesta

--testiranje
DELETE FROM RezultatiTesta
WHERE TestID=4

/*8. Kreirati stored proceduru za brisanje zapisa u tabeli Testovi ukljuèujuæi sve rezultate testiranja.
 Trigger kreiran u zadatku 7 treba da sprijeèi izvršavanje ove procedure
  ukoliko za odabrani test postoje rezultati testiranja.*/

  CREATE PROCEDURE usp_brisanje_testa
  (
  @TestID INT
 )
  as
  begin

  DELETE FROM Testovi
  where TestID=@TestID

  DELETE FROM RezultatiTesta
  WHERE TestID=@TestID
  END

  EXEC usp_brisanje_testa 5
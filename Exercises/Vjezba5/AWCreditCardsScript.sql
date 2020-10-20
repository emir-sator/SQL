-- Dodavanje nove dvije kreditne kartice i dodjeljivanje kartica kupcima
USE AdventureWorks2014
INSERT INTO Sales.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) VALUES ('Visa', '11111111111111', '7', '2014')
INSERT INTO Sales.PersonCreditCard (BusinessEntityID, CreditCardID, ModifiedDate) VALUES (745, 19238, '2016-03-22 00:00:00.000')
INSERT INTO Sales.CreditCard (CardType, CardNumber, ExpMonth, ExpYear) VALUES ('Maestro', '22222222222222', '11', '2014')
INSERT INTO Sales.PersonCreditCard (BusinessEntityID, CreditCardID, ModifiedDate) VALUES (2546, 19239, '2016-03-22 00:00:00.000')
Use AP 

-- Kwabena Agyei Boahene And Alex cho 
--item 1--

/*** 
By using a Cascade modifier you can define the actions that SQl takes when 
a user tries to delete or update a key to which existing foreign keys point ***/

--- item 2---

ALTER TABLE InvoiceArchive
ADD PRIMARY KEY (InvoiceID)

ALTER TABLE InvoiceArchive
ADD FOREIGN KEY(VendorID) REFERENCES Vendors (VendorID)

ALTER TABLE InvoiceArchive
ADD FOREIGN KEY(TermsID) REFERENCES Terms (TermsID)

INSERT INTO InvoiceArchive
SELECT * FROM Invoices WHERE PaymentDate IS NOT NULL;
DELETE FROM Invoices WHERE PaymentDate IS NOT NULL;
GO

--item 3--
-- explicitly defining schemabinding didnt work here--
  CREATE VIEW dbo.vAllinvoices AS
   SELECT 'C' AS 'InvoiceType',
		Invoices.invoiceID, 
		VendorName,  
		InvoiceSequence As ItemNumber, 
		InvoiceTotal,
		InvoiceDueDate,
		TermsDescription, 
		InvoiceLineItemDescription 
FROM InvoicesArchives JOIN Terms
ON Invoices.TermsID = Terms.TermsID
JOIN Vendors
ON Invoices.VendorID = Vendors.VendorID
JOIN InvoiceLineItems
ON Invoices.InvoiceID = InvoiceLineItems.InvoiceID

   UNION 

 SELECT 'A' AS 'InvoiceType',
	Invoices.invoiceID, 
	VendorName,  
	InvoiceSequence AS ItemNumber, 
	InvoiceTotal, 
	InvoiceDueDate,
	TermsDescription, 
	InvoiceLineItemDescription 
FROM InvoicesArchives JOIN Terms
ON Invoices.TermsID = Terms.TermsID
JOIN Vendors
ON Invoices.VendorID = Vendors.VendorID
JOIN InvoiceLineItems
ON Invoices.InvoiceID = InvoiceLineItems.InvoiceID
 
 Go             

/**3 Question 1: We didnt try. You cannot delete, update, or insert with a view. 
A view is a portion of data from a table so editing it is impossible. 
The only way to change the content is to edit the underlying table
**/
-- item 4--
use AdventureWorks2012
go 

-- item 5--
CREATE VIEW vRetirement AS
SELECT FirstName + ' ' + MiddleName + ' ' + LastName AS 'FullName', BirthDate
FROM HumanResources.Employee Join Person.Person
ON Employee.BusinessEntityID = Person.BusinessEntityID
WHERE DATEDIFF(year, HumanResources.Employee.BirthDate, GETDATE()) <= 52;
GO

SELECT count(*) * 120000
FROM vRetirement
GO
-- Total package cost is $27,360,000

-- item 6--
CREATE VIEW vPayHistMore AS
Select Employee.BusinessEntityID,
		LoginID,
		Max(rate) As 'HighestPayRate',
		Count(Employee.BusinessEntityID) AS 'TotalRatechanges'
FROM HumanResources.Employee JOIN HumanResources.EmployeePayHistory
ON Employee.BusinessEntityID = EmployeePayHistory.BusinessEntityID
Group By LoginID,
		Employee.BusinessEntityID
GO
Select * From vPayHistMore
go 

--- Item 7 --
CREATE VIEW vHRempList AS
SELECT LoginID,
	AddressLine1,
	City,
	StateProvinceCode
FROM HumanResources.Employee Join Person. BusinessEntityAddress
ON Employee.BusinessEntityID = BusinessEntityAddress.BusinessEntityID
Join Person.Address
ON Address.AddressID = BusinessEntityAddress.AddressID
Join Person.StateProvince
ON Address.StateProvinceID = StateProvince.StateProvinceID
GO

SELECT * FROM vHRempList
GO

--item 8--

 
-- Script Item 8
CREATE VIEW VMultipleAddresses As
SELECT BusinessEntityID
 , City
 , psp.StateProvinceCode
 , CountryRegionCode
FROM Person.StateProvince psp
 JOIN Person.Address pa
  ON psp.StateProvinceID = pa.StateProvinceID
 JOIN Person.BusinessEntityAddress pbea
  ON pa.AddressID = pbea.AddressID
GROUP BY BusinessEntityID
 , City
 , psp.StateProvinceCode
 , CountryRegionCode
HAVING COUNT(BusinessEntityID) > 1
GO
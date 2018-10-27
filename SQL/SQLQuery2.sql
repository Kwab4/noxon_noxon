
--Kwabena Agyei BOahene 
--Homework 3
--1a.

USE AP
GO
SELECT * FROM Vendors


SELECT DISTINCT
	Invoices.VendorID,
	VendorName
FROM 
	Invoices
JOIN 
	Vendors
ON 
	Invoices.VendorID = Vendors.VendorID




SELECT DISTINCT
	Invoices.VendorID,
	VendorName
FROM 
	Invoices
JOIN 
	Vendors
ON 
	Invoices.VendorID = Vendors.VendorID
WHERE InvoiceID IS NOT NULL


SELECT DISTINCT
	VendorName
FROM 
	Invoices
JOIN 
	Vendors
ON 
	Invoices.VendorID = Vendors.VendorID


SELECT DISTINCT
	VendorName
FROM 
	Invoices
JOIN 
	Vendors
ON 
	Invoices.VendorID = Vendors.VendorID
WHERE InvoiceID IS NOT NULL


 -- B

SELECT 
	InvoiceNumber,
	InvoiceTotal
	
FROM Invoices
WHERE PaymentTotal > (SELECT Min(PaymentTotal) FROM Invoices)
AND PaymentTotal < (SELECT AVG(PaymentTotal) FROM Invoices)


-- C
WITH InvCnt AS (

SELECT
	VendorID,
	COUNT (*) AS InvCnt
FROM Invoices
GROUP BY VendorID)

SELECT 
	Invoices.VendorID,
	InvoiceNumber,
	InvoiceTotal,
	InvCnt.InvCnt
FROM Invoices
JOIN InvCnt ON Invoices.VendorID = InvCnt.VendorID
WHERE PaymentTotal > (SELECT Min(PaymentTotal) FROM Invoices)
AND PaymentTotal < (SELECT AVG(PaymentTotal) FROM Invoices)




--2
USE AdventureWorks2012
GO

SELECT 
	BillOfMaterialsID,
	BOMLevel,
	ProductAssemblyID,
	ComponentID,
	PerAssemblyQty
FROM Production.BillOfMaterials
WHERE ProductAssemblyID = 728
ORDER BY ProductAssemblyID DESC

--Extra Credit   -- ,took a shot at this it is not wholly right 
SELECT 
	BillOfMaterialsID,
	BOMLevel,
	pdt.Name AS 'Assembly',
	ProductAssemblyID,
	ComponentID,
	PerAssemblyQty
FROM Production.BillOfMaterials bom JOIN
	Production.Product pdt
	ON bom.ComponentID = pdt.ProductID
WHERE ProductAssemblyID <= 728
ORDER BY ProductAssemblyID DESC

WITH ProductCTE AS
( --Anchor Assembly

UNION ALL
--Recursive Assemblies

)
SELECT *
FROM ProductCTE
ORDER BY BOMLevel

SELECT * FROM Production.Product
SELECT * FROM Production.BillOfMaterials
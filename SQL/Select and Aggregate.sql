--- Que1 

USE AP;

SELECT v.VendorState 
,v.VendorName
,i.VendorID 
, SUM(i. PaymentTotal)  AS PaymentSum
FROM Invoices i INNER JOIN Vendors v
	ON i.VendorID = v.VendorID
GROUP BY  v.VendorState , v.VendorName, i.VendorID ;


---- Que 2



 USE AP;
 go

SELECT GLAccounts.AccountDescription, 
		
		COUNT(*) AS LineItemCount,
		Avg(InvoiceLineItemAmount) AS AverageLineItem
      , SUM(InvoiceLineItemAmount) AS LineItemSum
FROM GLAccounts JOIN InvoiceLineItems
  ON GLAccounts.AccountNo = InvoiceLineItems.AccountNo
GROUP BY GLAccounts.AccountDescription
HAVING COUNT(*) > 1
ORDER BY LineItemCount DESC;




--- Que 3 



USE pubs ;
GO

SELECT job_lvl , count (*) "Number of E"
FROM employee
GROUP by job_lvl
ORDER BY "Number of E" DESC


SELECT job_lvl ,COUNT( hire_date ) as "HireDateCount" 
FROM employee
--WHERE hire_date BETWEEN '1995' AND '2016'
GROUP BY job_lvl , hire_date
--HAVING  COUNT (hire_date) >2 
	--AND SUM( job_lvl) > 100
ORDER BY HireDateCount ASC; 


SELECT job_lvl , hire_date , COUNT (*) as Qtydate
FROM employee
GROUP BY  ( job_lvl,hire_date)
--HAVING  COUNT (hire_date) >2 
ORDER BY job_lvl ASC , hire_date ASC;



-- Que 4
-- thank you Pat you just had to say one thing to point us towards the right direction 
SELECT job_lvl

       , COUNT(job_lvl) AS "Count"

       , MIN(hire_date) AS "Least"

FROM employee

GROUP BY job_lvl

HAVING COUNT(*)>2

ORDER BY [Least] ASC

GO

/*
Sales Analysis of SuperStore
*/

/*Displaying top 10 rows from Customer table in Superstore_Sales database*/

Select TOP 10 * from Superstore_Sales.dbo.Customer 

/*Displaying top 10 rows from Product table in Superstore_Sales database*/

SELECT TOP 10 * FROM Superstore_Sales..Product 

/*Inserting, deleting and updating details in Product table*/

Delete from Superstore_Sales..Product  
WHERE OrderID = 'CA-2018-100314'
Insert into Superstore_Sales..Product values('CA-2018-100314','OFF-LA-10001569','Office Supplies','Labels','Avery 499',null)
Update Superstore_Sales..Product
set Sales='7.968' WHERE OrderID = 'CA-2018-100314'

/*Lists the Category of products with the highest sales amount*/

Select Category,SUM(Sales) as TotalSalesAmount from Superstore_Sales.dbo.Product
group by Category
Order by TotalSalesAmount desc

/* Total selling price of products on different States */

Select State,sum(Sales) as TotalSalesAmount from Superstore_Sales.dbo.Customer cs
INNER JOIN Superstore_Sales..Product pt
ON cs.[OrderID]=pt.[OrderID] 
group by State 
order by TotalSalesAmount desc


/* Top 10 customers with highest purchase amount */

With Customers as(
Select top 10 CustomerName,sum(Sales) as Purchased_Amount from Superstore_Sales.dbo.Customer cs
INNER JOIN Superstore_Sales..Product pt
ON cs.[OrderID]=pt.[OrderID] 
group by CustomerName 
order by Purchased_Amount desc)
select * from Customers

/*Count of products sold in terms of subcategory*/

select SubCategory,Count(SubCategory) as TotalSold from Superstore_Sales.dbo.Customer cs
INNER JOIN Superstore_Sales..Product pt
ON cs.[OrderID]=pt.[OrderID] 
Group by SubCategory
order by TotalSold desc


/* Months having biggest sales */

Create View MonthlySalesAmount as
Select DATENAME(month,OrderDate) AS Months,sum(Sales) as Purchased_Amount from Superstore_Sales.dbo.Customer cs
INNER JOIN Superstore_Sales..Product pt
ON cs.[OrderID]=pt.[OrderID] 
group by DATENAME(month,OrderDate)

Select * from MonthlySalesAmount order by Purchased_Amount desc

/*Top 5 items sold during november and december*/

Select Top 5 SubCategory,sum(sales) as TotalSalesAmount from Superstore_Sales..Product where OrderID IN
(select OrderID from Superstore_Sales..Customer where OrderDate between '2018-11-01' and '2018-12-31')
group by SubCategory
order by TotalSalesAmount desc

/*Categorizing sales of each Product in to huge ,medium and low based on the total amount sold*/

Create Procedure Sales_Info 
as
Drop table if exists Sales_Type
Create table Sales_Type (SubCategory nvarchar(40),SalesCategory nvarchar(40))
Insert into Sales_Type 
select SubCategory,
CASE 
     WHEN SUM(Sales) >20000 then 'Huge Sales'
	 WHEN SUM(Sales) >=10000 then 'Medium Sales'
	 WHEN SUM(Sales) <10000 then 'Low Sales'
END AS SalesCategory
from Superstore_Sales..Customer cs
INNER JOIN Superstore_Sales..Product pt
ON cs.[OrderID]=pt.[OrderID] 
group by SubCategory
select * from Sales_Type order by SalesCategory

Exec Sales_Info

select * from [project 110]..[customer]

--Creating a column with total price based on stock code
alter table customer add total_cost float;

update customer 
set total_cost = quantity*unitprice

-------------------------------------------------------------
--What is the distribution of order values across all customers in the dataset?

select customerid, sum(total_cost) as customer_spent_money
from [project 110]..[customer ]
where total_cost >0 and CustomerID is not null
group by CustomerID 
order by sum(total_cost) desc

-----------------------------------------------------------------------------------


--How many unique products has each customer purchased?

SELECT CustomerID, COUNT(DISTINCT StockCode) AS UniqueProductCount
FROM [project 110]..[customer]
WHERE StockCode IS NOT NULL AND CustomerID IS NOT NULL
GROUP BY CustomerID
order by COUNT(DISTINCT StockCode) desc

--we can filter the data like we want customers who bought more than 1000 unique products

SELECT CustomerID, COUNT(DISTINCT StockCode) AS UniqueProductCount
FROM [project 110]..[customer]
WHERE StockCode IS NOT NULL AND CustomerID IS NOT NULL
GROUP BY CustomerID
having COUNT(DISTINCT StockCode) >1000


--------------------------------------------------------------------------------------

--Which customers have only made a single purchase from the company?

select * from [project 110]..[customer]

SELECT distinct CustomerID, COUNT(DISTINCT invoiceNo) AS UniqueProductCount
FROM [project 110]..[customer]
WHERE StockCode IS NOT NULL AND CustomerID IS NOT NULL
GROUP BY CustomerID
having COUNT(DISTINCT invoiceNo) =1
order by customerid



-------------------------------------------------------------------------------------------------

--Which products are most commonly purchased together by customers in the dataset?

select * from [project 110]..[customer]

WITH TransactionPairs AS (
    SELECT
        t1.StockCode AS Product1,
        t2.StockCode AS Product2,
        COUNT(*) AS PurchaseCount
    FROM
        [project 110]..[customer ] t1
    JOIN
        [project 110]..[customer ] t2
    ON
        t1.CustomerID = t2.CustomerID
        AND t1.InvoiceNo <> t2.InvoiceNo 
    GROUP BY
        t1.StockCode,
        t2.StockCode
    HAVING
        COUNT(*) >= 2 
)

SELECT
    Product1,
    Product2,
    count(*)
FROM
    TransactionPairs
ORDER BY
    count(*) DESC
LIMIT 10 

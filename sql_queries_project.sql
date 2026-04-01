-- Create Database ---

CREATE DATABASE retail_sales_db;

-- Use Database ---

USE retail_sales_db;

-- Create Table And Drop of Already Exits ----

DROP TABLE IF EXISTS retail_sales; 
CREATE TABLE retail_sales 
     (
       transactions_id INT PRIMARY KEY,
       sale_date DATE,
	   sale_time TIME,
	   customer_id	INT,
	   gender VARCHAR(10),
       age VARCHAR(50),
	   category VARCHAR (50),	
	   quantity INT,	
	   price_per_unit FLOAT,	
	   cogs	FLOAT,
	   total_sale FLOAT
	 );
     
SELECT * FROM retail_sales;
  
-- Count Rows in Sql Data Table--

   SELECT 
   count(*)
  FROM retail_sales;
  
   -- DATA CLEANING---1
   
-- Check for null rows---

  Select * from retail_sales
  where transactions_id is null;
  
-- Check Missing IDs Number Ascending Order ---
  select transactions_id from retail_sales
  order by transactions_id;
  
-- Now 3 rows missings so we have to find those rows

SELECT t1.transactions_id +1 As missing_id
from retail_sales t1
Left Join  retail_sales t2
On t1.transactions_id +1 = t2.transactions_id
Where t2.transactions_id is null
and t1.transactions_id < (select max(transactions_id) from retail_sales);

/* Now i find three rows that have missing value
First i truncate (Truncate table retail_sales;) the table deletes the data from retail_sales table
then i go to the excel csv file  fill those rows and then Again Save CSV file 
And Import Again CSV file in table---*/

Truncate table retail_sales;

-- now  Run select count query to see all rows---

select  count(*) from retail_sales;

-- we can do check also by this query---
-- or we can do Data Cleaning like this also--

SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE sale_time IS NULL;

-- All columns check at one time by using OR conditions ---

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
/* we find 3 rows missing data and 
then we truncate the table and go to the 
excel fill the data and then again save csv 
file and re Import the data 
So alternate iswe can delete those 3 rows
if the data is not important by using
this query---*/

DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- above query delete the data where is null value---

-- Data Exploration --
-- 1. How many sales we have ?
Select count(*) as total_sale from retail_sales;

-- 2. How many unique customers we have ?
select count(distinct customer_id) as unique_customers from retail_sales;

-- 3. How many category we have ?
select distinct category from retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

 
 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT * FROM retail_sales
WHERE category = 'Clothing'
    AND 
    DATE_FORMAT(sale_date, '%Y-%m') = '2022-11' -- DATE_FROMAT - CONVERT DATE INTO STRING
    AND
    quantity >= 4;
    
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
    ROUND(AVG(age), 0) as avg_age  -- 0 is taken because in round format if i write 2 so age  comes in point---
FROM retail_sales
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT category, 
	   gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP BY 
    category,
    gender
ORDER BY category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT year,
       month,
       avg_sale
FROM (    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date)
                 ORDER BY AVG(total_sale) DESC) As rnk
FROM retail_sales
GROUP BY year, month
) As t1
WHERE rnk = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT customer_id,
       SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.


SELECT category,    
       COUNT(DISTINCT customer_id) as unique_customers
FROM retail_sales
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;

-- End of Project








 

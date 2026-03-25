-- ============================================================
-- Project 2: Customer Retention Analytics
-- Author: Sanele Siyabonga Thusi
-- Tool: SQL Server (T-SQL)
-- Database: Project2_CustomerRetention
-- Dataset: 497,862 orders | 5,000 customers | 2021-2025
-- Countries: South Africa, USA, UK, Australia, Canada
-- ============================================================


-- ============================================================
-- SECTION 1: BASIC ANALYSIS
-- Skills: SELECT, SUM, COUNT, GROUP BY, DISTINCT, CTE
-- ============================================================


-- B1. How many total orders are in the system?
-- -------------------------------------------------------
SELECT
    COUNT(order_id) AS Total_Orders
FROM dbo.fact_orders;
-- Result: 497,862 orders


-- B2. What is the total revenue across all orders?
-- -------------------------------------------------------
SELECT
    SUM(sales_amount) AS Total_Revenue
FROM dbo.fact_orders;
-- Result: R340,717,636.10


-- B3. How many customers do we have per country?
-- -------------------------------------------------------
SELECT
    country,
    COUNT(customer_id) AS Total_Customers
FROM dbo.dim_customers
GROUP BY country
ORDER BY Total_Customers DESC;
-- Result: South Africa (highest) | Australia (lowest)


-- B4. What payment methods are available?
-- -------------------------------------------------------
SELECT payment_method
FROM dbo.dim_payment
GROUP BY payment_method;
-- Result: Bank Transfer, Buy Now Pay Later, Cash on Delivery,
--         Credit Card, Cryptocurrency, Debit Card, PayPal


-- B5. How many orders were returned and what is the return rate?
-- -------------------------------------------------------
WITH FoundationalCTE AS (
    SELECT
        SUM(is_return)  AS Total_Returns,
        COUNT(order_id) AS Total_Orders
    FROM dbo.fact_orders
),
ReturningRateCTE AS (
    SELECT
        *,
        CAST((Total_Returns * 1.0) / Total_Orders * 100 AS DECIMAL(5,2)) AS Return_Rate_Pct
    FROM FoundationalCTE
)
SELECT *
FROM ReturningRateCTE;
-- Result: ~4.99% return rate


-- ============================================================
-- SECTION 2: INTERMEDIATE ANALYSIS
-- Skills: JOINs, GROUP BY, HAVING, CTEs, ROW_NUMBER()
-- ============================================================


-- I1. How many new customers joined each year?
-- -------------------------------------------------------
SELECT
    YEAR(join_date)     AS Year_Joined,
    COUNT(customer_id)  AS New_Customers
FROM dbo.dim_customers
GROUP BY YEAR(join_date)
ORDER BY YEAR(join_date) ASC;
-- Result: Consistent acquisition across 2021-2024


-- I2. Which payment method generates the most revenue?
-- -------------------------------------------------------
SELECT
    pay.payment_method,
    SUM(ord.sales_amount)   AS Total_Revenue,
    COUNT(ord.order_id)     AS Total_Orders
FROM dbo.fact_orders ord
JOIN dbo.dim_payment pay
    ON ord.payment_id = pay.payment_id
GROUP BY pay.payment_method
ORDER BY Total_Revenue DESC;
-- Result: Credit Card leads revenue | Cash on Delivery lowest


-- I3. What is the total revenue per customer segment?
-- -------------------------------------------------------
SELECT
    cus.segment,
    SUM(ord.sales_amount) AS Total_Revenue
FROM dbo.fact_orders ord
JOIN dbo.dim_customers cus
    ON ord.customer_id = cus.customer_id
GROUP BY cus.segment
ORDER BY Total_Revenue DESC;
-- Result: Occasional and At Risk segments generate most revenue


-- I4. Who are the top 10 customers by total spend?
-- -------------------------------------------------------
WITH CustomerRevenue AS (
    SELECT
        cus.customer_name,
        cus.country,
        cus.segment,
        SUM(ord.sales_amount) AS Total_Revenue
    FROM dbo.fact_orders ord
    JOIN dbo.dim_customers cus
        ON ord.customer_id = cus.customer_id
    GROUP BY
        cus.customer_name,
        cus.country,
        cus.segment
),
RankedData AS (
    SELECT
        *,
        ROW_NUMBER() OVER(ORDER BY Total_Revenue DESC) AS Rankings
    FROM CustomerRevenue
)
SELECT *
FROM RankedData
WHERE Rankings <= 10
ORDER BY Rankings;
-- Result: Top customer: Ethan Nkosi (USA) R249,278.05


-- I5. What is the average number of orders per customer?
-- -------------------------------------------------------
SELECT
    CAST(
        COUNT(order_id) * 1.0 / COUNT(DISTINCT customer_id)
    AS DECIMAL(10,2)) AS Avg_Orders_Per_Customer
FROM dbo.fact_orders;
-- Result: ~99.57 orders per customer


-- I6. Which product category do repeat customers buy most?
-- -------------------------------------------------------
WITH RepeatCustomers AS (
    SELECT customer_id
    FROM dbo.fact_orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
),
CategoryRevenue AS (
    SELECT
        pro.category,
        COUNT(ord.order_id)   AS Total_Orders,
        SUM(ord.sales_amount) AS Total_Revenue
    FROM dbo.fact_orders ord
    JOIN dbo.dim_products pro
        ON ord.product_id = pro.product_id
    WHERE ord.customer_id IN (SELECT customer_id FROM RepeatCustomers)
    GROUP BY pro.category
)
SELECT *
FROM CategoryRevenue
ORDER BY Total_Orders DESC;
-- Result: Electronics dominates repeat purchase behaviour


-- ============================================================
-- SECTION 3: ADVANCED ANALYSIS
-- Skills: DATEDIFF, LAG(), PARTITION BY, CASE, Window Functions
-- ============================================================


-- A1. What was each customer's first and last purchase date?
-- -------------------------------------------------------
SELECT
    cus.customer_name,
    cus.country,
    MIN(dat.order_date)                                             AS First_Purchase,
    MAX(dat.order_date)                                             AS Last_Purchase,
    DATEDIFF(DAY, MIN(dat.order_date), MAX(dat.order_date))        AS Days_As_Customer,
    COUNT(ord.order_id)                                             AS Total_Orders
FROM dbo.fact_orders ord
JOIN dbo.dim_customers cus
    ON ord.customer_id = cus.customer_id
JOIN dbo.dim_dates dat
    ON ord.date_id = dat.date_id
GROUP BY
    cus.customer_name,
    cus.country
ORDER BY Days_As_Customer DESC;
-- Result: Shows full customer lifecycle from first to last purchase


-- A2. How many customers made only one purchase vs repeat buyers?
-- -------------------------------------------------------
WITH CustomerOrders AS (
    SELECT
        customer_id,
        COUNT(order_id) AS Total_Orders
    FROM dbo.fact_orders
    GROUP BY customer_id
)
SELECT
    CASE
        WHEN Total_Orders = 1 THEN 'One-Time Buyer'
        ELSE 'Repeat Buyer'
    END AS Customer_Type,
    COUNT(customer_id) AS Total_Customers,
    CAST(
        COUNT(customer_id) * 100.0 /
        SUM(COUNT(customer_id)) OVER()
    AS DECIMAL(5,2)) AS Pct_of_Total
FROM CustomerOrders
GROUP BY
    CASE
        WHEN Total_Orders = 1 THEN 'One-Time Buyer'
        ELSE 'Repeat Buyer'
    END;
-- Result: Majority are repeat buyers — healthy retention signal


-- A3. What is the Customer Lifetime Value (CLV) per segment?
-- -------------------------------------------------------
WITH SegmentRevenue AS (
    SELECT
        cus.segment,
        COUNT(DISTINCT cus.customer_id) AS Total_Customers,
        SUM(ord.sales_amount)           AS Total_Revenue
    FROM dbo.fact_orders ord
    JOIN dbo.dim_customers cus
        ON ord.customer_id = cus.customer_id
    GROUP BY cus.segment
)
SELECT
    segment,
    Total_Customers,
    Total_Revenue,
    CAST(Total_Revenue / Total_Customers AS DECIMAL(18,2)) AS CLV_Per_Customer
FROM SegmentRevenue
ORDER BY CLV_Per_Customer DESC;
-- Result: Champion and High Value segments show highest CLV


-- A4. What is the month-over-month new customer acquisition trend?
-- -------------------------------------------------------
WITH MonthlyAcquisition AS (
    SELECT
        YEAR(join_date)     AS Year,
        MONTH(join_date)    AS Month,
        COUNT(customer_id)  AS New_Customers
    FROM dbo.dim_customers
    GROUP BY
        YEAR(join_date),
        MONTH(join_date)
),
GrowthCalc AS (
    SELECT
        *,
        LAG(New_Customers) OVER(ORDER BY Year, Month) AS Previous_Month
    FROM MonthlyAcquisition
)
SELECT
    Year,
    Month,
    New_Customers,
    Previous_Month,
    CAST(
        (New_Customers - Previous_Month) * 1.0
        / Previous_Month * 100
    AS DECIMAL(5,2)) AS MoM_Growth_Pct
FROM GrowthCalc
WHERE Previous_Month IS NOT NULL
ORDER BY Year, Month;
-- Result: Seasonal peaks in Q4 — November and December highest


-- A5. Who are the top 3 customers per country by total spend?
-- -------------------------------------------------------
WITH CustomerRevenue AS (
    SELECT
        cus.customer_name,
        cus.country,
        cus.city,
        cus.segment,
        SUM(ord.sales_amount) AS Total_Revenue
    FROM dbo.fact_orders ord
    JOIN dbo.dim_customers cus
        ON ord.customer_id = cus.customer_id
    GROUP BY
        cus.customer_name,
        cus.country,
        cus.city,
        cus.segment
),
RankedCustomers AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY country
            ORDER BY Total_Revenue DESC
        ) AS Country_Rank
    FROM CustomerRevenue
)
SELECT *
FROM RankedCustomers
WHERE Country_Rank <= 3
ORDER BY country, Country_Rank;
-- Result: Top 3 spenders identified across all 5 countries


-- ============================================================
-- END OF ANALYSIS
-- Author: Sanele Siyabonga Thusi
-- GitHub: https://github.com/STCybersec
-- ============================================================

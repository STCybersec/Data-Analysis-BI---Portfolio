-- ============================================================
-- Project 1: Sales Intelligence Dashboard
-- Author: Sanele Siyabonga Thusi
-- Tool: SQL Server (T-SQL)
-- Database: Project1_SalesBI
-- Dataset: 500,000 transactions | 2021 - 2025
-- Description: End-to-end sales analysis covering revenue,
--              product performance, regional breakdown,
--              customer spend, and growth trends.
-- ============================================================


-- ============================================================
-- SECTION 1: BASIC ANALYSIS
-- Skills: SELECT, SUM, COUNT, GROUP BY, DISTINCT
-- ============================================================


-- B1. What is the total revenue generated across all sales?
-- -------------------------------------------------------
SELECT 
    SUM(sales_amount) AS Total_Revenue
FROM dbo.fact_sales;
-- Result: R571,370,401.85


-- B2. How many total orders have been placed?
-- -------------------------------------------------------
SELECT 
    COUNT(order_id) AS Total_Orders
FROM dbo.fact_sales;
-- Result: 500,000 orders


-- B3. What is the total quantity of items sold?
-- -------------------------------------------------------
SELECT 
    SUM(quantity) AS Total_Items_Sold
FROM dbo.fact_sales;
-- Result: 2,749,608 items


-- B4. List all unique product categories
-- -------------------------------------------------------
SELECT DISTINCT category
FROM dbo.dim_products;
-- Result: Appliances, Books, Clothing, Electronics, 
--         Furniture, Health, Sports (7 categories)


-- B5. How many customers do we have per country?
-- -------------------------------------------------------
SELECT 
    country,
    COUNT(customer_name) AS Number_of_Customers
FROM dbo.dim_customers
GROUP BY country
ORDER BY Number_of_Customers DESC;
-- Result: South Africa: 2308 | USA: 1731 | UK: 961


-- ============================================================
-- SECTION 2: INTERMEDIATE ANALYSIS
-- Skills: JOINs, GROUP BY, HAVING, DATE Functions, RANK()
-- ============================================================


-- I1. What is the total revenue per product category?
-- -------------------------------------------------------
SELECT
    pro.category,
    SUM(fac.sales_amount) AS Total_Revenue
FROM dbo.fact_sales fac
JOIN dbo.dim_products pro 
    ON fac.product_id = pro.product_id
GROUP BY pro.category
ORDER BY Total_Revenue DESC;
-- Result: Electronics R287,818,354.32 (highest)
--         Books R6,846,112.75 (lowest)


-- I2. Which are the top 5 best-selling products by revenue?
-- -------------------------------------------------------
WITH RevenueCTE AS (
    SELECT
        pro.product_name,
        SUM(fac.sales_amount) AS Total_Revenue
    FROM dbo.fact_sales fac
    JOIN dbo.dim_products pro 
        ON fac.product_id = pro.product_id
    GROUP BY pro.product_name
),
RankedProducts AS (
    SELECT
        *,
        RANK() OVER(ORDER BY Total_Revenue DESC) AS Rankings
    FROM RevenueCTE
)
SELECT *
FROM RankedProducts
WHERE Rankings <= 5;
-- Result: 1. Desktop  2. Laptop  3. Sofa  
--         4. Smartphone  5. Wardrobe


-- I3. What is the total revenue per region?
-- -------------------------------------------------------
SELECT
    reg.region_name,
    SUM(fac.sales_amount) AS Total_Revenue
FROM dbo.fact_sales fac
JOIN dbo.dim_regions reg 
    ON fac.region_id = reg.region_id
GROUP BY reg.region_name
ORDER BY Total_Revenue DESC;
-- Result: International R96,137,469.07 (highest)
--         Central R93,532,671.50 (lowest)


-- I4. What is the monthly revenue trend across all years?
-- -------------------------------------------------------
SELECT
    YEAR(dat.order_date)  AS Year,
    MONTH(dat.order_date) AS Month,
    SUM(fac.sales_amount) AS Total_Revenue
FROM dbo.fact_sales fac
JOIN dbo.dim_dates dat 
    ON fac.date_id = dat.date_id
GROUP BY 
    YEAR(dat.order_date),
    MONTH(dat.order_date)
ORDER BY Year, Month ASC;
-- Result: Consistent upward trend 2021 through 2025
--         December consistently highest each year


-- I5. Which customers have spent the most? (Top 10)
-- -------------------------------------------------------
WITH CustomerRevenue AS (
    SELECT
        cus.customer_name,
        SUM(fac.sales_amount) AS Total_Revenue
    FROM dbo.fact_sales fac
    JOIN dbo.dim_customers cus 
        ON fac.customer_id = cus.customer_id
    GROUP BY cus.customer_name
),
RankedCustomers AS (
    SELECT
        *,
        ROW_NUMBER() OVER(ORDER BY Total_Revenue DESC) AS Rankings
    FROM CustomerRevenue
)
SELECT *
FROM RankedCustomers
WHERE Rankings <= 10;
-- Result: #1 Nkosi Perez R651,824.09
--         #10 Benjamin Davies R501,791.61


-- I6. What is the average order value per region?
-- -------------------------------------------------------
SELECT
    reg.region_name,
    CAST(
        SUM(fac.sales_amount) / COUNT(fac.order_id) 
    AS DECIMAL(10,2)) AS Avg_Order_Value
FROM dbo.fact_sales fac
JOIN dbo.dim_regions reg 
    ON fac.region_id = reg.region_id
GROUP BY reg.region_name
ORDER BY Avg_Order_Value DESC;


-- ============================================================
-- SECTION 3: ADVANCED ANALYSIS
-- Skills: Window Functions, LAG(), PARTITION BY, CTEs
-- ============================================================


-- A1. Rank products by total revenue within each category
-- -------------------------------------------------------
WITH RevenueCTE AS (
    SELECT
        pro.product_name,
        pro.category,
        SUM(fac.sales_amount) AS Total_Revenue
    FROM dbo.fact_sales fac
    JOIN dbo.dim_products pro 
        ON fac.product_id = pro.product_id
    GROUP BY 
        pro.product_name,
        pro.category
),
RankedProducts AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY category 
            ORDER BY Total_Revenue DESC
        ) AS Rankings
    FROM RevenueCTE
)
SELECT *
FROM RankedProducts
ORDER BY category, Rankings;
-- Result: Top product per category ranked
--         Electronics #1: Desktop
--         Furniture #1: Sofa


-- A2. What is the month-over-month revenue growth?
-- -------------------------------------------------------
WITH MonthlyRevenue AS (
    SELECT
        YEAR(dat.order_date)  AS Year,
        MONTH(dat.order_date) AS Month,
        SUM(fac.sales_amount) AS Total_Revenue
    FROM dbo.fact_sales fac
    JOIN dbo.dim_dates dat 
        ON fac.date_id = dat.date_id
    GROUP BY 
        YEAR(dat.order_date),
        MONTH(dat.order_date)
),
GrowthCalc AS (
    SELECT
        *,
        LAG(Total_Revenue) OVER(
            ORDER BY Year, Month
        ) AS Previous_Month_Revenue
    FROM MonthlyRevenue
)
SELECT
    Year,
    Month,
    Total_Revenue,
    Previous_Month_Revenue,
    CAST(
        (Total_Revenue - Previous_Month_Revenue) 
        / Previous_Month_Revenue * 100 
    AS DECIMAL(5,2)) AS MoM_Growth_Pct
FROM GrowthCalc
WHERE Previous_Month_Revenue IS NOT NULL
ORDER BY Year, Month;
-- Result: Month-over-month % growth across all 60 months
--         Negative growth visible in off-peak months


-- A3. Who are the top 3 customers per country by total spend?
-- -------------------------------------------------------
WITH CustomerRevenue AS (
    SELECT
        cus.customer_name,
        cus.country,
        SUM(fac.sales_amount) AS Total_Revenue
    FROM dbo.fact_sales fac
    JOIN dbo.dim_customers cus 
        ON fac.customer_id = cus.customer_id
    GROUP BY 
        cus.customer_name,
        cus.country
),
RankedCustomers AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY country 
            ORDER BY Total_Revenue DESC
        ) AS Rankings
    FROM CustomerRevenue
)
SELECT *
FROM RankedCustomers
WHERE Rankings <= 3
ORDER BY country, Rankings;
-- Result: Top 3 spenders identified per country
--         SA, USA and UK each show distinct top customers


-- A4. What percentage of total revenue does each category contribute?
-- -------------------------------------------------------
WITH CategoryRevenue AS (
    SELECT
        pro.category,
        SUM(fac.sales_amount) AS Total_Revenue
    FROM dbo.fact_sales fac
    JOIN dbo.dim_products pro 
        ON fac.product_id = pro.product_id
    GROUP BY pro.category
)
SELECT
    category,
    Total_Revenue,
    CAST(
        Total_Revenue / SUM(Total_Revenue) OVER() * 100 
    AS DECIMAL(5,2)) AS Pct_Contribution
FROM CategoryRevenue
ORDER BY Pct_Contribution DESC;
-- Result: Electronics 50.37% | Sports 12.8% | Furniture 11.9%
--         Books 1.2% (lowest contributor)


-- A5. Which year had the highest revenue and by how much 
--     did it beat the previous year?
-- -------------------------------------------------------
WITH YearlyRevenue AS (
    SELECT
        YEAR(dat.order_date) AS Years,
        SUM(fac.sales_amount) AS Total_Revenue
    FROM dbo.fact_sales fac
    JOIN dbo.dim_dates dat 
        ON fac.date_id = dat.date_id
    GROUP BY YEAR(dat.order_date)
),
YearComparison AS (
    SELECT
        *,
        LAG(Total_Revenue) OVER(
            ORDER BY Years
        ) AS Previous_Year_Revenue
    FROM YearlyRevenue
)
SELECT
    Years,
    Total_Revenue,
    Previous_Year_Revenue,
    CAST(
        (Total_Revenue - Previous_Year_Revenue) 
    AS DECIMAL(18,2)) AS Difference,
    CAST(
        (Total_Revenue - Previous_Year_Revenue) 
        / Previous_Year_Revenue * 100
    AS DECIMAL(5,2)) AS YoY_Growth_Pct
FROM YearComparison
ORDER BY Years ASC;
-- Result: 2025 was the strongest year
--         Beat 2024 by R717,054.45


-- ============================================================
-- END OF ANALYSIS
-- Author: Sanele Siyabonga Thusi
-- GitHub: https://github.com/STCybersec
-- ============================================================

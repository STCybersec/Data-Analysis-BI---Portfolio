-- ============================================================
-- Project 6: Fintech Revenue Analytics
-- Author: Sanele Siyabonga Thusi
-- Tool: SQL Server (T-SQL)
-- Database: Project6_Fintech
-- Dataset: 500,000 transactions | 2021-2025
-- Markets: South Africa, UAE, UK, USA
-- ============================================================


-- ============================================================
-- SECTION 1:
-- Skills: SELECT, COUNT, SUM, AVG, GROUP BY, ORDER BY
-- ============================================================


-- B1. How many total transactions are recorded?
-- -------------------------------------------------------
SELECT
    COUNT(transaction_id) AS Total_Transactions
FROM dbo.fact_transactions;
-- Result: 500,000


-- B2. What is the total gross revenue and platform fee revenue?
-- -------------------------------------------------------
SELECT
    CAST(SUM(transaction_amount) AS DECIMAL(18,2)) AS Gross_Revenue,
    CAST(SUM(fee_amount)         AS DECIMAL(18,2)) AS Platform_Fee_Revenue,
    CAST(SUM(net_amount)         AS DECIMAL(18,2)) AS Total_Net_To_Merchants
FROM dbo.fact_transactions;
-- Result: Gross R2.66bn | Fee R66.40M | Net R2.59bn to merchants


-- B3. What is the transaction status breakdown?
-- -------------------------------------------------------
SELECT
    transaction_status,
    COUNT(transaction_id) AS Total_Transactions,
    CAST(
        COUNT(transaction_id) * 1.0 / SUM(COUNT(transaction_id)) OVER() * 100
    AS DECIMAL(5,2)) AS Pct_of_Total
FROM dbo.fact_transactions
GROUP BY transaction_status
ORDER BY Total_Transactions DESC;
-- Result: Completed 82.03% | Failed 7.94% | Reversed 6.12% | Pending 4.02%
-- Insight: 7.94% failed rate is above the 5% benchmark


-- B4. What is the overall fraud rate?
-- -------------------------------------------------------
SELECT
    SUM(is_fraud)         AS Total_Fraud_Transactions,
    COUNT(transaction_id) AS Total_Transactions,
    CAST(
        SUM(is_fraud) * 1.0 / COUNT(transaction_id) * 100
    AS DECIMAL(5,2))      AS Fraud_Rate_Pct
FROM dbo.fact_transactions;
-- Result: 2.02% fraud rate — above the 2% target


-- B5. What is the transaction split by device type?
-- -------------------------------------------------------
SELECT
    device_type,
    COUNT(transaction_id) AS Total_Transactions,
    CAST(
        COUNT(transaction_id) * 1.0 / SUM(COUNT(transaction_id)) OVER() * 100
    AS DECIMAL(5,2)) AS Pct_of_Total,
    CAST(SUM(fee_amount) AS DECIMAL(18,2)) AS Fee_Revenue
FROM dbo.fact_transactions
GROUP BY device_type
ORDER BY Total_Transactions DESC;
-- Result: Mobile 55% | Web 30% | POS 15%
-- Insight: Mobile-first platform — digital wallet investment is priority


-- ============================================================
-- SECTION 2: 
-- Skills: JOINs, AVG, GROUP BY, CASE WHEN, CTEs, RANK()
-- ============================================================


-- I1. Which country generates the most platform fee revenue?
-- -------------------------------------------------------
SELECT
    loc.country,
    COUNT(fac.transaction_id)                       AS Total_Transactions,
    CAST(SUM(fac.fee_amount) AS DECIMAL(18,2))      AS Fee_Revenue,
    CAST(SUM(fac.transaction_amount) AS DECIMAL(18,2)) AS Gross_Revenue
FROM dbo.fact_transactions fac
JOIN dbo.dim_locations loc ON fac.location_id = loc.location_id
GROUP BY loc.country
ORDER BY Fee_Revenue DESC;
-- Result: USA leads fee revenue | UK lowest despite merchant presence


-- I2. Which payment method generates the most revenue?
-- -------------------------------------------------------
SELECT
    pay.payment_type_name,
    pay.payment_category,
    COUNT(fac.transaction_id)                  AS Total_Transactions,
    CAST(SUM(fac.fee_amount) AS DECIMAL(18,2)) AS Fee_Revenue
FROM dbo.fact_transactions fac
JOIN dbo.dim_payment_types pay ON fac.payment_type_id = pay.payment_type_id
GROUP BY pay.payment_type_name, pay.payment_category
ORDER BY Fee_Revenue DESC;
-- Result: Digital payment methods dominate fee revenue


-- I3. Which merchant category drives the most fee revenue?
-- -------------------------------------------------------
SELECT
    mer.merchant_category,
    COUNT(fac.transaction_id)                       AS Total_Transactions,
    CAST(SUM(fac.fee_amount) AS DECIMAL(18,2))      AS Fee_Revenue,
    CAST(AVG(fac.transaction_amount) AS DECIMAL(10,2)) AS Avg_Transaction_Value
FROM dbo.fact_transactions fac
JOIN dbo.dim_merchants mer ON fac.merchant_id = mer.merchant_id
GROUP BY mer.merchant_category
ORDER BY Fee_Revenue DESC;
-- Result: Travel category highest avg transaction value (Emirates, Airbnb)


-- I4. What is the fee revenue per customer tier?
-- -------------------------------------------------------
SELECT
    cus.customer_tier,
    COUNT(DISTINCT fac.customer_id)            AS Total_Customers,
    COUNT(fac.transaction_id)                  AS Total_Transactions,
    CAST(SUM(fac.fee_amount) AS DECIMAL(18,2)) AS Fee_Revenue,
    CAST(
        SUM(fac.fee_amount) / COUNT(DISTINCT fac.customer_id)
    AS DECIMAL(10,2))                          AS Fee_Revenue_Per_Customer
FROM dbo.fact_transactions fac
JOIN dbo.dim_customers cus ON fac.customer_id = cus.customer_id
GROUP BY cus.customer_tier
ORDER BY Fee_Revenue DESC;
-- Result: Standard tier highest volume | Platinum highest per-customer value


-- I5. What is the failed transaction rate per payment method?
-- -------------------------------------------------------
SELECT
    pay.payment_type_name,
    COUNT(fac.transaction_id) AS Total_Transactions,
    SUM(CASE WHEN fac.transaction_status = 'Failed' THEN 1 ELSE 0 END) AS Failed,
    CAST(
        SUM(CASE WHEN fac.transaction_status = 'Failed' THEN 1 ELSE 0 END) * 1.0
        / COUNT(fac.transaction_id) * 100
    AS DECIMAL(5,2)) AS Failed_Rate_Pct
FROM dbo.fact_transactions fac
JOIN dbo.dim_payment_types pay ON fac.payment_type_id = pay.payment_type_id
GROUP BY pay.payment_type_name
ORDER BY Failed_Rate_Pct DESC;
-- Result: Identifies which payment methods have highest failure rates


-- I6. What is the monthly fee revenue trend?
-- -------------------------------------------------------
SELECT
    YEAR(dat.transaction_date)  AS Year,
    MONTH(dat.transaction_date) AS Month,
    COUNT(fac.transaction_id)   AS Total_Transactions,
    CAST(SUM(fac.fee_amount) AS DECIMAL(18,2)) AS Fee_Revenue,
    SUM(CAST(SUM(fac.fee_amount) AS DECIMAL(18,2))) OVER(
        PARTITION BY YEAR(dat.transaction_date)
        ORDER BY MONTH(dat.transaction_date)
    ) AS Running_Year_Total
FROM dbo.fact_transactions fac
JOIN dbo.dim_dates dat ON fac.date_id = dat.date_id
GROUP BY
    YEAR(dat.transaction_date),
    MONTH(dat.transaction_date)
ORDER BY Year, Month ASC;
-- Result: Consistent growth trend | December peaks annually


-- ============================================================
-- SECTION 3:
-- Skills: Composite Scoring, NULLIF, Fraud Analysis,
--         Revenue Concentration, LAG(), RANK()
-- ============================================================


-- A1. Top 10 merchants by fee revenue with performance ranking
-- -------------------------------------------------------
WITH MerchantRevenue AS (
    SELECT
        mer.merchant_name,
        mer.merchant_category,
        mer.country,
        COUNT(fac.transaction_id)                       AS Total_Transactions,
        CAST(SUM(fac.fee_amount) AS DECIMAL(18,2))      AS Fee_Revenue,
        CAST(
            SUM(CASE WHEN fac.transaction_status = 'Failed' THEN 1 ELSE 0 END) * 1.0
            / COUNT(fac.transaction_id) * 100
        AS DECIMAL(5,2))                                AS Failed_Rate_Pct,
        CAST(
            SUM(fac.is_fraud) * 1.0 / COUNT(fac.transaction_id) * 100
        AS DECIMAL(5,2))                                AS Fraud_Rate_Pct
    FROM dbo.fact_transactions fac
    JOIN dbo.dim_merchants mer ON fac.merchant_id = mer.merchant_id
    GROUP BY mer.merchant_name, mer.merchant_category, mer.country
)
SELECT
    *,
    RANK() OVER(ORDER BY Fee_Revenue DESC) AS Revenue_Rank
FROM MerchantRevenue
ORDER BY Revenue_Rank;
-- Result: Emirates Airlines and Airbnb dominate
-- Insight: Top 2 merchants represent significant revenue concentration risk


-- A2. Fraud analysis by country and payment method
-- -------------------------------------------------------
WITH FraudAnalysis AS (
    SELECT
        loc.country,
        pay.payment_type_name,
        COUNT(fac.transaction_id)                       AS Total_Transactions,
        SUM(fac.is_fraud)                               AS Fraud_Count,
        CAST(
            SUM(fac.is_fraud) * 1.0 / COUNT(fac.transaction_id) * 100
        AS DECIMAL(5,2))                                AS Fraud_Rate_Pct,
        CAST(SUM(CASE WHEN fac.is_fraud = 1 THEN fac.transaction_amount ELSE 0 END) AS DECIMAL(18,2)) AS Fraud_Exposure
    FROM dbo.fact_transactions fac
    JOIN dbo.dim_locations loc      ON fac.location_id      = loc.location_id
    JOIN dbo.dim_payment_types pay  ON fac.payment_type_id  = pay.payment_type_id
    GROUP BY loc.country, pay.payment_type_name
)
SELECT *
FROM FraudAnalysis
ORDER BY Fraud_Exposure DESC;
-- Result: Countries and payment methods with highest fraud exposure identified


-- A3. Customer lifetime value by tier and country
-- -------------------------------------------------------
WITH CustomerLTV AS (
    SELECT
        cus.customer_id,
        cus.customer_name,
        cus.customer_tier,
        cus.country,
        COUNT(fac.transaction_id)                  AS Total_Transactions,
        CAST(SUM(fac.transaction_amount) AS DECIMAL(18,2)) AS Lifetime_Spend,
        CAST(SUM(fac.fee_amount) AS DECIMAL(18,2)) AS Lifetime_Fee_Revenue
    FROM dbo.fact_transactions fac
    JOIN dbo.dim_customers cus ON fac.customer_id = cus.customer_id
    GROUP BY cus.customer_id, cus.customer_name, cus.customer_tier, cus.country
),
TierSummary AS (
    SELECT
        customer_tier,
        country,
        COUNT(customer_id)                              AS Total_Customers,
        CAST(AVG(Lifetime_Spend) AS DECIMAL(18,2))      AS Avg_LTV,
        CAST(AVG(Lifetime_Fee_Revenue) AS DECIMAL(10,2)) AS Avg_Fee_Per_Customer
    FROM CustomerLTV
    GROUP BY customer_tier, country
)
SELECT
    *,
    RANK() OVER(PARTITION BY country ORDER BY Avg_Fee_Per_Customer DESC) AS Tier_Rank
FROM TierSummary
ORDER BY country, Tier_Rank;
-- Result: Platinum highest fee per customer in every country
-- Insight: Standard tier upgrade programme would significantly increase platform revenue


-- A4. Revenue concentration risk — top merchant dependency
-- -------------------------------------------------------
WITH MerchantFee AS (
    SELECT
        mer.merchant_name,
        CAST(SUM(fac.fee_amount) AS DECIMAL(18,2)) AS Merchant_Fee_Revenue
    FROM dbo.fact_transactions fac
    JOIN dbo.dim_merchants mer ON fac.merchant_id = mer.merchant_id
    GROUP BY mer.merchant_name
)
SELECT
    merchant_name,
    Merchant_Fee_Revenue,
    CAST(
        Merchant_Fee_Revenue / SUM(Merchant_Fee_Revenue) OVER() * 100
    AS DECIMAL(5,2)) AS Pct_of_Total_Fee_Revenue,
    CAST(
        SUM(Merchant_Fee_Revenue) OVER(ORDER BY Merchant_Fee_Revenue DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
        / SUM(Merchant_Fee_Revenue) OVER() * 100
    AS DECIMAL(5,2)) AS Cumulative_Pct
FROM MerchantFee
ORDER BY Merchant_Fee_Revenue DESC;
-- Result: Shows revenue concentration — how many merchants drive 80% of fee revenue
-- Business insight: Pareto analysis for merchant risk management


-- A5. Month-over-month fee revenue growth trend
-- -------------------------------------------------------
WITH MonthlyRevenue AS (
    SELECT
        YEAR(dat.transaction_date)  AS Year,
        MONTH(dat.transaction_date) AS Month,
        CAST(SUM(fac.fee_amount) AS DECIMAL(18,2)) AS Fee_Revenue
    FROM dbo.fact_transactions fac
    JOIN dbo.dim_dates dat ON fac.date_id = dat.date_id
    GROUP BY
        YEAR(dat.transaction_date),
        MONTH(dat.transaction_date)
),
GrowthCTE AS (
    SELECT
        *,
        LAG(Fee_Revenue) OVER(ORDER BY Year, Month) AS Previous_Month_Revenue
    FROM MonthlyRevenue
)
SELECT
    Year,
    Month,
    Fee_Revenue,
    Previous_Month_Revenue,
    CAST(
        (Fee_Revenue - Previous_Month_Revenue) * 1.0
        / Previous_Month_Revenue * 100
    AS DECIMAL(5,2)) AS MoM_Growth_Pct
FROM GrowthCTE
WHERE Previous_Month_Revenue IS NOT NULL
ORDER BY Year, Month;
-- Result: Consistent MoM growth | December spike each year
-- 2025 shows strongest monthly fee revenue on record


-- ============================================================
-- VALIDATION - Confirm Power BI values match SQL
-- ============================================================
SELECT
    COUNT(transaction_id)                                                           AS Total_Transactions,
    CAST(SUM(transaction_amount) AS DECIMAL(18,2))                                  AS Gross_Revenue,
    CAST(SUM(fee_amount) AS DECIMAL(18,2))                                          AS Platform_Fee_Revenue,
    CAST(AVG(transaction_amount) AS DECIMAL(10,2))                                  AS Avg_Transaction_Value,
    CAST(SUM(is_fraud) * 1.0 / COUNT(transaction_id) * 100 AS DECIMAL(5,2))        AS Fraud_Rate_Pct,
    CAST(
        SUM(CASE WHEN transaction_status = 'Failed' THEN 1 ELSE 0 END) * 1.0
        / COUNT(transaction_id) * 100
    AS DECIMAL(5,2))                                                                AS Failed_Rate_Pct
FROM dbo.fact_transactions;
-- Expected: 500,000 | R2.66bn | R66.40M | R5.31K | 2.02% | 7.94%


-- ============================================================
-- END OF ANALYSIS
-- Author: Sanele Siyabonga Thusi
-- GitHub: https://github.com/STCybersec
-- ============================================================

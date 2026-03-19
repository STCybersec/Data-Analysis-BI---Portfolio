WITH MonthlyAcquisition AS (
    SELECT
        YEAR(join_date)  AS Year,
        MONTH(join_date) AS Month,
        COUNT(customer_id) AS New_Customers
    FROM dbo.dim_customers
    GROUP BY YEAR(join_date), MONTH(join_date)
),
GrowthCalc AS (
    SELECT *,
        LAG(New_Customers) OVER(ORDER BY Year, Month) AS Previous_Month
    FROM MonthlyAcquisition
)
SELECT
    Year, Month, New_Customers, Previous_Month,
    CAST(
        (New_Customers - Previous_Month) * 1.0 
        / Previous_Month * 100 
    AS DECIMAL(5,2)) AS MoM_Growth_Pct
FROM GrowthCalc
WHERE Previous_Month IS NOT NULL
ORDER BY Year, Month;

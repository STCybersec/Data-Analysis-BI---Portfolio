-- ============================================================
-- Project 5: Supply Chain Control Tower
-- Author: Sanele Siyabonga Thusi
-- Tool: SQL Server (T-SQL)
-- Database: Project5_SupplyChain
-- Dataset: 500,000 shipments | 2021-2025
-- Warehouses: SA, UK, USA, Australia, UAE
-- ============================================================


-- ============================================================
-- SECTION 1:
-- Skills: SELECT, COUNT, SUM, AVG, GROUP BY, ORDER BY
-- ============================================================


-- B1. How many total shipments are recorded?
-- -------------------------------------------------------
SELECT
    COUNT(shipment_id) AS Total_Shipments
FROM dbo.fact_shipments;
-- Result: 500,000


-- B2. What is the overall on-time delivery rate?
-- -------------------------------------------------------
SELECT
    SUM(on_time_delivery)   AS Total_On_Time,
    COUNT(shipment_id)      AS Total_Shipments,
    CAST(
        SUM(on_time_delivery) * 1.0 / COUNT(shipment_id) * 100
    AS DECIMAL(5,2))        AS On_Time_Rate_Pct
FROM dbo.fact_shipments;
-- Result: 62.92% — critically below the 85% industry benchmark


-- B3. What is the breakdown of delivery status?
-- -------------------------------------------------------
SELECT
    delivery_status,
    COUNT(shipment_id)  AS Total_Shipments,
    CAST(
        COUNT(shipment_id) * 1.0 / SUM(COUNT(shipment_id)) OVER() * 100
    AS DECIMAL(5,2))    AS Pct_of_Total
FROM dbo.fact_shipments
GROUP BY delivery_status
ORDER BY Total_Shipments DESC;
-- Result: Delivered 70% | Delayed 12% | In Transit 15% | Failed 3%


-- B4. What is the total shipping cost by transport mode?
-- -------------------------------------------------------
SELECT
    car.transport_mode,
    CAST(SUM(fac.shipping_cost) AS DECIMAL(18,2)) AS Total_Shipping_Cost,
    COUNT(fac.shipment_id)                         AS Total_Shipments
FROM dbo.fact_shipments fac
JOIN dbo.dim_carriers car ON fac.carrier_id = car.carrier_id
GROUP BY car.transport_mode
ORDER BY Total_Shipping_Cost DESC;
-- Result: Road R192M | Air R192M | Sea R64M | Rail R64M
-- Insight: Road and Air equal cost — Air being overused for non-urgent shipments


-- B5. What is the overall return rate?
-- -------------------------------------------------------
SELECT
    SUM(return_flag)    AS Total_Returns,
    COUNT(shipment_id)  AS Total_Shipments,
    CAST(
        SUM(return_flag) * 1.0 / COUNT(shipment_id) * 100
    AS DECIMAL(5,2))    AS Return_Rate_Pct
FROM dbo.fact_shipments;
-- Result: 5.00% return rate — on the boundary of the 5% benchmark


-- ============================================================
-- SECTION 2:
-- Skills: JOINs, AVG, GROUP BY, CASE WHEN, CTEs, RANK()
-- ============================================================


-- I1. Which warehouse processes the most shipments?
-- -------------------------------------------------------
SELECT
    war.warehouse_name,
    war.country,
    COUNT(fac.shipment_id)                         AS Total_Shipments,
    CAST(SUM(fac.shipping_cost) AS DECIMAL(18,2))  AS Total_Shipping_Cost
FROM dbo.fact_shipments fac
JOIN dbo.dim_warehouses war ON fac.warehouse_id = war.warehouse_id
GROUP BY war.warehouse_name, war.country
ORDER BY Total_Shipments DESC;
-- Result: Cape Town DC leads despite not being SA primary hub


-- I2. Which carrier has the best on-time delivery rate?
-- -------------------------------------------------------
SELECT
    car.carrier_name,
    car.transport_mode,
    COUNT(fac.shipment_id)  AS Total_Shipments,
    CAST(
        SUM(fac.on_time_delivery) * 1.0 / COUNT(fac.shipment_id) * 100
    AS DECIMAL(5,2))        AS On_Time_Rate_Pct
FROM dbo.fact_shipments fac
JOIN dbo.dim_carriers car ON fac.carrier_id = car.carrier_id
GROUP BY car.carrier_name, car.transport_mode
ORDER BY On_Time_Rate_Pct DESC;
-- Result: All carriers below 85% benchmark — systemic issue not carrier-specific


-- I3. What is the average delay days per transport mode?
-- -------------------------------------------------------
SELECT
    car.transport_mode,
    CAST(
        AVG(CAST(fac.delay_days AS DECIMAL(10,2)))
    AS DECIMAL(5,2))        AS Avg_Delay_Days,
    COUNT(fac.shipment_id)  AS Total_Shipments
FROM dbo.fact_shipments fac
JOIN dbo.dim_carriers car ON fac.carrier_id = car.carrier_id
WHERE fac.delay_days > 0
GROUP BY car.transport_mode
ORDER BY Avg_Delay_Days DESC;
-- Result: All modes averaging 7+ days — confirms systemic delay problem


-- I4. What is the total shipment value by product category?
-- -------------------------------------------------------
SELECT
    pro.category,
    COUNT(fac.shipment_id)                         AS Total_Shipments,
    CAST(SUM(fac.total_value) AS DECIMAL(18,2))    AS Total_Value,
    CAST(SUM(fac.shipping_cost) AS DECIMAL(18,2))  AS Total_Shipping_Cost
FROM dbo.fact_shipments fac
JOIN dbo.dim_products pro ON fac.product_id = pro.product_id
GROUP BY pro.category
ORDER BY Total_Value DESC;
-- Result: Electronics leads by total value due to high unit price


-- I5. Which supplier has the highest shipment volume?
-- -------------------------------------------------------
SELECT
    sup.supplier_name,
    sup.country_of_origin,
    sup.product_category,
    COUNT(fac.shipment_id)                        AS Total_Shipments,
    CAST(SUM(fac.total_value) AS DECIMAL(18,2))   AS Total_Value
FROM dbo.fact_shipments fac
JOIN dbo.dim_suppliers sup ON fac.supplier_id = sup.supplier_id
GROUP BY sup.supplier_name, sup.country_of_origin, sup.product_category
ORDER BY Total_Shipments DESC;


-- I6. What is the monthly shipment trend across all years?
-- -------------------------------------------------------
SELECT
    YEAR(fac.ship_date)   AS Year,
    MONTH(fac.ship_date)  AS Month,
    COUNT(fac.shipment_id) AS Total_Shipments,
    SUM(COUNT(fac.shipment_id)) OVER(
        PARTITION BY YEAR(fac.ship_date)
        ORDER BY MONTH(fac.ship_date)
    )                      AS Running_Year_Total
FROM dbo.fact_shipments fac
GROUP BY
    YEAR(fac.ship_date),
    MONTH(fac.ship_date)
ORDER BY Year, Month ASC;
-- Result: December consistently peaks — holiday season demand spike


-- ============================================================
-- SECTION 3:
-- Skills: Composite Scoring, CASE WHEN, LAG(), RANK(),
--         Cost Analysis, Performance Benchmarking
-- ============================================================


-- A1. Carrier performance scorecard — ranked by on-time rate
-- -------------------------------------------------------
WITH CarrierStats AS (
    SELECT
        car.carrier_name,
        car.transport_mode,
        car.service_type,
        COUNT(fac.shipment_id)                                          AS Total_Shipments,
        CAST(
            SUM(fac.on_time_delivery) * 1.0 / COUNT(fac.shipment_id) * 100
        AS DECIMAL(5,2))                                                AS On_Time_Rate_Pct,
        CAST(AVG(CAST(fac.delay_days AS DECIMAL(10,2))) AS DECIMAL(5,2)) AS Avg_Delay_Days,
        CAST(SUM(fac.shipping_cost) AS DECIMAL(18,2))                   AS Total_Cost
    FROM dbo.fact_shipments fac
    JOIN dbo.dim_carriers car ON fac.carrier_id = car.carrier_id
    GROUP BY car.carrier_name, car.transport_mode, car.service_type
)
SELECT
    *,
    RANK() OVER(ORDER BY On_Time_Rate_Pct DESC) AS Performance_Rank,
    CASE
        WHEN On_Time_Rate_Pct >= 85 THEN 'On Target ✅'
        WHEN On_Time_Rate_Pct >= 70 THEN 'At Risk ⚠️'
        ELSE 'Critical 🔴'
    END AS Performance_Status
FROM CarrierStats
ORDER BY Performance_Rank;
-- Result: All carriers in Critical status — confirms systemic issue


-- A2. Warehouse efficiency — cost per shipment by location
-- -------------------------------------------------------
WITH WarehouseStats AS (
    SELECT
        war.warehouse_name,
        war.country,
        COUNT(fac.shipment_id)                          AS Total_Shipments,
        CAST(SUM(fac.shipping_cost) AS DECIMAL(18,2))   AS Total_Cost,
        CAST(
            SUM(fac.on_time_delivery) * 1.0 / COUNT(fac.shipment_id) * 100
        AS DECIMAL(5,2))                                AS On_Time_Rate_Pct
    FROM dbo.fact_shipments fac
    JOIN dbo.dim_warehouses war ON fac.warehouse_id = war.warehouse_id
    GROUP BY war.warehouse_name, war.country
),
CostEfficiency AS (
    SELECT
        *,
        CAST(Total_Cost / Total_Shipments AS DECIMAL(10,2)) AS Cost_Per_Shipment
    FROM WarehouseStats
)
SELECT
    *,
    RANK() OVER(ORDER BY On_Time_Rate_Pct DESC) AS Efficiency_Rank
FROM CostEfficiency
ORDER BY Efficiency_Rank;
-- Result: Warehouse efficiency league table — identifies best and worst performers


-- A3. Transport mode cost vs performance analysis
-- -------------------------------------------------------
SELECT
    car.transport_mode,
    COUNT(fac.shipment_id)                                              AS Total_Shipments,
    CAST(SUM(fac.shipping_cost) AS DECIMAL(18,2))                       AS Total_Cost,
    CAST(SUM(fac.shipping_cost) / COUNT(fac.shipment_id) AS DECIMAL(10,2)) AS Avg_Cost_Per_Shipment,
    CAST(
        SUM(fac.on_time_delivery) * 1.0 / COUNT(fac.shipment_id) * 100
    AS DECIMAL(5,2))                                                    AS On_Time_Rate_Pct,
    CAST(AVG(CAST(fac.delay_days AS DECIMAL(10,2))) AS DECIMAL(5,2))   AS Avg_Delay_Days
FROM dbo.fact_shipments fac
JOIN dbo.dim_carriers car ON fac.carrier_id = car.carrier_id
GROUP BY car.transport_mode
ORDER BY Total_Cost DESC;
-- Result: Air and Road equal cost but similar on-time rates
-- Key insight: Air not delivering better performance despite premium cost


-- A4. Delay cost impact — estimated premium freight cost
-- -------------------------------------------------------
WITH DelayCost AS (
    SELECT
        war.warehouse_name,
        war.country,
        COUNT(fac.shipment_id)                                          AS Delayed_Shipments,
        CAST(AVG(fac.shipping_cost) AS DECIMAL(10,2))                   AS Avg_Shipping_Cost,
        CAST(SUM(fac.shipping_cost) * 0.15 AS DECIMAL(18,2))           AS Estimated_Delay_Cost
    FROM dbo.fact_shipments fac
    JOIN dbo.dim_warehouses war ON fac.warehouse_id = war.warehouse_id
    WHERE fac.delivery_status = 'Delayed'
    GROUP BY war.warehouse_name, war.country
)
SELECT
    *,
    RANK() OVER(ORDER BY Estimated_Delay_Cost DESC) AS Cost_Impact_Rank
FROM DelayCost
ORDER BY Cost_Impact_Rank;
-- Result: Warehouses ranked by delay cost impact
-- 15% premium applied — standard logistics industry assumption for delayed freight


-- A5. Month-over-month shipment growth trend
-- -------------------------------------------------------
WITH MonthlyShipments AS (
    SELECT
        YEAR(ship_date)   AS Year,
        MONTH(ship_date)  AS Month,
        COUNT(shipment_id) AS Total_Shipments
    FROM dbo.fact_shipments
    GROUP BY YEAR(ship_date), MONTH(ship_date)
),
GrowthCTE AS (
    SELECT
        *,
        LAG(Total_Shipments) OVER(ORDER BY Year, Month) AS Previous_Month
    FROM MonthlyShipments
)
SELECT
    Year,
    Month,
    Total_Shipments,
    Previous_Month,
    CAST(
        (Total_Shipments - Previous_Month) * 1.0
        / Previous_Month * 100
    AS DECIMAL(5,2)) AS MoM_Growth_Pct
FROM GrowthCTE
WHERE Previous_Month IS NOT NULL
ORDER BY Year, Month;
-- Result: Consistent growth trend — December spikes annually


-- ============================================================
-- VALIDATION — Confirm Power BI values match SQL
-- ============================================================
SELECT
    COUNT(shipment_id)                                                          AS Total_Shipments,
    CAST(SUM(on_time_delivery) * 1.0 / COUNT(shipment_id) * 100 AS DECIMAL(5,2)) AS On_Time_Pct,
    CAST(
        SUM(CASE WHEN delivery_status = 'Delayed' THEN 1 ELSE 0 END) * 1.0
        / COUNT(shipment_id) * 100
    AS DECIMAL(5,2))                                                            AS Delay_Rate_Pct,
    CAST(AVG(CAST(delay_days AS DECIMAL(10,2))) AS DECIMAL(5,2))               AS Avg_Delay_Days,
    CAST(SUM(shipping_cost) AS DECIMAL(18,2))                                   AS Total_Shipping_Cost,
    CAST(SUM(return_flag) * 1.0 / COUNT(shipment_id) * 100 AS DECIMAL(5,2))    AS Return_Rate_Pct
FROM dbo.fact_shipments;
-- Expected: 500,000 | 62.92% | 12.02% | 7.03 | R512,086,095.37 | 5.00%


-- ============================================================
-- END OF ANALYSIS
-- Author: Sanele Siyabonga Thusi
-- GitHub: https://github.com/STCybersec
-- ============================================================

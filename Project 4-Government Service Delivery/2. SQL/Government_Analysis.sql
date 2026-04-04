-- ============================================================
-- Project 4: Government Service Delivery Analytics
-- Author: Sanele Siyabonga Thusi
-- Tool: SQL Server (T-SQL)
-- Database: Project4_GovServiceDelivery
-- Dataset: 500,000 service requests | 2021-2025
-- Provinces: Gauteng, Western Cape, KwaZulu-Natal
-- Municipalities: 24 real SA municipalities
-- ============================================================


-- ============================================================
-- SECTION 1:
-- Skills: SELECT, COUNT, SUM, GROUP BY, ORDER BY, CTE
-- ============================================================


-- B1. What is the total number of service requests logged?
-- -------------------------------------------------------
SELECT
    COUNT(request_id) AS Total_Requests
FROM dbo.fact_service_requests;
-- Result: 500,000


-- B2. How many requests per province?
-- -------------------------------------------------------
SELECT
    cit.province,
    COUNT(ser.request_id) AS Total_Requests
FROM dbo.fact_service_requests ser
JOIN dbo.dim_citizens cit ON ser.citizen_id = cit.citizen_id
GROUP BY cit.province
ORDER BY Total_Requests DESC;
-- Result: Gauteng 228,460 | Western Cape 148,556 | KZN 122,984


-- B3. What is the breakdown of requests by status?
-- -------------------------------------------------------
SELECT
    status,
    COUNT(request_id) AS Total_Requests
FROM dbo.fact_service_requests
GROUP BY status
ORDER BY Total_Requests DESC;
-- Result: Resolved 300,341 | Open 99,953 | Closed 50,061 | Escalated 49,645
-- Insight: 60% resolved but 10% escalated — double the 5% benchmark


-- B4. What is the overall SLA compliance rate?
-- -------------------------------------------------------
SELECT
    SUM(sla_met)        AS Total_SLA_Met,
    COUNT(request_id)   AS Total_Requests,
    CAST(SUM(sla_met) * 1.0 / COUNT(request_id) * 100 AS DECIMAL(5,2)) AS SLA_Compliance_Pct
FROM dbo.fact_service_requests;
-- Result: 41.99% — critically below the 70% benchmark


-- B5. What is the total budget allocated vs total budget spent?
-- -------------------------------------------------------
SELECT
    CAST(SUM(budget_allocated) AS DECIMAL(18,2)) AS Total_Budget_Allocated,
    CAST(SUM(budget_spent)     AS DECIMAL(18,2)) AS Total_Budget_Spent,
    CAST(SUM(budget_variance)  AS DECIMAL(18,2)) AS Total_Variance
FROM dbo.fact_service_requests;
-- Result: Allocated R12.6B | Spent R9.9B | Underspent R2.6B
-- Insight: R2.6B underspent = projects not delivered, not savings


-- ============================================================
-- SECTION 2:
-- Skills: JOINs, AVG, NULLIF, CASE WHEN, CTEs, ROW_NUMBER()
-- ============================================================


-- I1. Which municipality has the highest number of requests?
-- -------------------------------------------------------
SELECT
    mun.municipality_name,
    mun.province,
    COUNT(fac.request_id) AS Total_Requests
FROM dbo.fact_service_requests fac
JOIN dbo.dim_municipalities mun ON fac.municipality_id = mun.municipality_id
GROUP BY mun.municipality_name, mun.province
ORDER BY Total_Requests DESC;
-- Result: King Cetshwayo 21,035 (highest) | Knysna 20,526 (lowest)


-- I2. What is the average resolution time per department?
-- -------------------------------------------------------
SELECT
    dep.department_name,
    dep.sla_target_days,
    CAST(AVG(CAST(fac.resolution_days AS DECIMAL(10,2))) AS DECIMAL(10,2)) AS Avg_Resolution_Days
FROM dbo.fact_service_requests fac
JOIN dbo.dim_departments dep ON fac.department_id = dep.department_id
WHERE fac.resolution_days IS NOT NULL
GROUP BY dep.department_name, dep.sla_target_days
ORDER BY Avg_Resolution_Days DESC;
-- Result: Housing slowest at 11+ days | Public Safety fastest
-- Note: NULL resolution_days excluded (open/escalated requests)


-- I3. Which request type is most common?
-- -------------------------------------------------------
SELECT
    req.request_type_name,
    req.department_category,
    COUNT(fac.request_id) AS Total_Requests
FROM dbo.fact_service_requests fac
JOIN dbo.dim_request_types req ON fac.request_type_id = req.request_type_id
GROUP BY req.request_type_name, req.department_category
ORDER BY Total_Requests DESC;
-- Result: Burst Pipe / Water Outage leads with 25,508 requests
-- Insight: Infrastructure decay is the primary citizen complaint


-- I4. What is the average satisfaction score per department?
-- -------------------------------------------------------
SELECT
    dep.department_name,
    CAST(
        AVG(CAST(NULLIF(fac.satisfaction_score, 0) AS DECIMAL(5,2)))
    AS DECIMAL(5,2)) AS Avg_Satisfaction_Score
FROM dbo.fact_service_requests fac
JOIN dbo.dim_departments dep ON fac.department_id = dep.department_id
WHERE fac.satisfaction_score > 0
GROUP BY dep.department_name
ORDER BY Avg_Satisfaction_Score DESC;
-- Note: NULLIF(satisfaction_score, 0) converts zeros to NULL
--       so AVG() ignores unresolved requests automatically


-- I5. What is the escalation rate per province?
-- -------------------------------------------------------
SELECT
    mun.province,
    CAST(
        SUM(CASE WHEN fac.status = 'Escalated' THEN 1 ELSE 0 END) * 1.0
        / COUNT(fac.request_id) * 100
    AS DECIMAL(5,2)) AS Escalation_Rate_Pct
FROM dbo.fact_service_requests fac
JOIN dbo.dim_municipalities mun ON fac.municipality_id = mun.municipality_id
GROUP BY mun.province
ORDER BY Escalation_Rate_Pct DESC;
-- Result: All provinces ~10% escalation rate — double the 5% benchmark


-- I6. What is the monthly request trend across all years?
-- -------------------------------------------------------
SELECT
    YEAR(date_submitted)  AS Year,
    MONTH(date_submitted) AS Month,
    COUNT(request_id)     AS Total_Requests,
    SUM(COUNT(request_id)) OVER(
        PARTITION BY YEAR(date_submitted)
        ORDER BY MONTH(date_submitted)
    )                     AS Running_Year_Total
FROM dbo.fact_service_requests
GROUP BY
    YEAR(date_submitted),
    MONTH(date_submitted)
ORDER BY Year, Month ASC;
-- Result: Consistent monthly volume with Q3 peaks
-- Running total resets each January — shows annual accumulation


-- ============================================================
-- SECTION 3:
-- Skills: Composite Scoring, NULLIF, Budget Variance,
--         Cost per Request, RANK(), LAG()
-- ============================================================


-- A1. Which municipalities are failing SLA targets?
-- -------------------------------------------------------
WITH SLAFailure AS (
    SELECT
        mun.municipality_name,
        mun.province,
        COUNT(fac.request_id)                                               AS Total_Requests,
        SUM(CASE WHEN fac.sla_met = 0 THEN 1 ELSE 0 END)                   AS SLA_Breached,
        CAST(
            SUM(CASE WHEN fac.sla_met = 0 THEN 1 ELSE 0 END) * 1.0
            / COUNT(fac.request_id) * 100
        AS DECIMAL(5,2))                                                    AS SLA_Breach_Rate_Pct
    FROM dbo.fact_service_requests fac
    JOIN dbo.dim_municipalities mun ON fac.municipality_id = mun.municipality_id
    GROUP BY mun.municipality_name, mun.province
)
SELECT
    *,
    RANK() OVER(ORDER BY SLA_Breach_Rate_Pct DESC) AS Failure_Rank
FROM SLAFailure
ORDER BY Failure_Rank;
-- Result: Municipal performance league table — worst to best
-- Bottom performers flagged for Section 139 intervention


-- A2. What is the budget variance per department?
-- -------------------------------------------------------
SELECT
    dep.department_name,
    CAST(SUM(fac.budget_allocated) AS DECIMAL(18,2)) AS Total_Allocated,
    CAST(SUM(fac.budget_spent)     AS DECIMAL(18,2)) AS Total_Spent,
    CAST(SUM(fac.budget_variance)  AS DECIMAL(18,2)) AS Total_Variance,
    CASE
        WHEN SUM(fac.budget_variance) > 0 THEN 'Over Budget 🔴'
        ELSE 'Under Budget 🟢'
    END AS Budget_Status
FROM dbo.fact_service_requests fac
JOIN dbo.dim_departments dep ON fac.department_id = dep.department_id
GROUP BY dep.department_name
ORDER BY Total_Variance DESC;
-- Result: Departments flagged as over or under budget
-- Key insight: Underspend = non-delivery, not efficiency


-- A3. What is the cost per resolved request per municipality?
-- -------------------------------------------------------
WITH DetailsCTE AS (
    SELECT
        mun.municipality_name,
        mun.province,
        SUM(fac.budget_spent)   AS Total_Budget_Spent,
        COUNT(fac.request_id)   AS Total_Resolved
    FROM dbo.fact_service_requests fac
    JOIN dbo.dim_municipalities mun ON fac.municipality_id = mun.municipality_id
    WHERE fac.status = 'Resolved'
    GROUP BY mun.municipality_name, mun.province
),
CostPerRequest AS (
    SELECT
        *,
        CAST(Total_Budget_Spent / Total_Resolved AS DECIMAL(10,2)) AS Cost_Per_Request
    FROM DetailsCTE
)
SELECT *
FROM CostPerRequest
ORDER BY Cost_Per_Request DESC;
-- Result: Municipalities ranked by cost efficiency
-- Higher cost per request = less efficient service delivery


-- A4. Rank municipalities by overall performance score
-- -------------------------------------------------------
WITH PerformanceCTE AS (
    SELECT
        mun.municipality_name,
        mun.province,
        CAST(
            SUM(fac.sla_met) * 1.0 / COUNT(fac.request_id) * 100
        AS DECIMAL(5,2))                                            AS SLA_Compliance_Pct,
        CAST(
            AVG(CAST(NULLIF(fac.satisfaction_score, 0) AS DECIMAL(5,2)))
        AS DECIMAL(5,2))                                            AS Avg_Satisfaction
    FROM dbo.fact_service_requests fac
    JOIN dbo.dim_municipalities mun ON fac.municipality_id = mun.municipality_id
    GROUP BY mun.municipality_name, mun.province
),
ScoredCTE AS (
    SELECT
        *,
        -- Composite: SLA weighted 60%, Satisfaction weighted 40%
        CAST(
            (SLA_Compliance_Pct * 0.60) +
            (Avg_Satisfaction * 20 * 0.40)
        AS DECIMAL(5,2))                                            AS Performance_Score
    FROM PerformanceCTE
)
SELECT
    *,
    RANK() OVER(ORDER BY Performance_Score DESC)                    AS Performance_Rank
FROM ScoredCTE
ORDER BY Performance_Rank;
-- Result: Municipal performance league table
-- Top performers should mentor bottom performers


-- A5. What is the month-over-month request growth trend?
-- -------------------------------------------------------
WITH MonthlyRequests AS (
    SELECT
        YEAR(date_submitted)  AS Year,
        MONTH(date_submitted) AS Month,
        COUNT(request_id)     AS Total_Requests
    FROM dbo.fact_service_requests
    GROUP BY
        YEAR(date_submitted),
        MONTH(date_submitted)
),
GrowthCTE AS (
    SELECT
        *,
        LAG(Total_Requests) OVER(ORDER BY Year, Month) AS Previous_Month
    FROM MonthlyRequests
)
SELECT
    Year,
    Month,
    Total_Requests,
    Previous_Month,
    CAST(
        (Total_Requests - Previous_Month) * 1.0
        / Previous_Month * 100
    AS DECIMAL(5,2)) AS MoM_Growth_Pct
FROM GrowthCTE
WHERE Previous_Month IS NOT NULL
ORDER BY Year, Month;
-- Result: MoM growth trend across 60 months
-- Positive % = more requests that month vs previous


-- ============================================================
-- END OF ANALYSIS
-- Author: Sanele Siyabonga Thusi
-- GitHub: https://github.com/STCybersec
-- ============================================================

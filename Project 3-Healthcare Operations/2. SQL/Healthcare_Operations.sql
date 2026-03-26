-- ============================================================
-- Project 3: Healthcare Operations Dashboard
-- Author: Sanele Siyabonga Thusi
-- Tool: SQL Server (T-SQL)
-- Database: Project3_Healthcare_Operations
-- Dataset: 1,000,000 admissions | 50,000 patients | 2021-2025
-- Facilities: Public Hospitals, Private Hospitals, Clinics
-- Provinces: All 9 South African Provinces
-- ============================================================


-- ============================================================
-- SECTION 1: BASIC ANALYSIS
-- Skills: SELECT, COUNT, SUM, AVG, GROUP BY, ORDER BY
-- ============================================================


-- B1. How many total admissions are recorded?
-- -------------------------------------------------------
SELECT
    COUNT(admission_id) AS Total_Admissions
FROM dbo.fact_admissions;
-- Result: 1,000,000


-- B2. How many patients do we have per province?
-- -------------------------------------------------------
SELECT
    province,
    COUNT(patient_id) AS Total_Patients
FROM dbo.dim_patients
GROUP BY province
ORDER BY Total_Patients DESC;
-- Result: Gauteng leads with 17,535 | Northern Cape lowest with 962


-- B3. What is the split between Emergency, Planned and Referral admissions?
-- -------------------------------------------------------
SELECT
    admission_type,
    COUNT(admission_id) AS Total_Admissions
FROM dbo.fact_admissions
GROUP BY admission_type
ORDER BY Total_Admissions DESC;
-- Result: Emergency 400,960 | Planned 349,566 | Referral 249,474


-- B4. How many admissions per facility type?
-- -------------------------------------------------------
SELECT
    dep.facility_type,
    COUNT(adm.admission_id) AS Total_Admissions
FROM dbo.fact_admissions adm
JOIN dbo.dim_departments dep
    ON adm.department_id = dep.department_id
GROUP BY dep.facility_type
ORDER BY Total_Admissions DESC;
-- Result: Public Hospital 533,880 | Private Hospital 332,452 | Clinic 133,668


-- B5. What is the overall readmission rate?
-- -------------------------------------------------------
SELECT
    SUM(readmission)    AS Total_Readmissions,
    COUNT(admission_id) AS Total_Admissions,
    CAST(
        SUM(readmission) * 1.0 / COUNT(admission_id) * 100
    AS DECIMAL(5,2))    AS Readmission_Rate_Pct
FROM dbo.fact_admissions;
-- Result: 8.00% readmission rate — above the 7% target


-- ============================================================
-- SECTION 2: INTERMEDIATE ANALYSIS
-- Skills: JOINs, AVG, GROUP BY, CTEs, ROW_NUMBER(), YEAR(), MONTH()
-- ============================================================


-- I1. What is the average length of stay per department?
-- -------------------------------------------------------
SELECT
    dep.department_name,
    dep.facility_type,
    CAST(AVG(adm.length_of_stay) AS DECIMAL(5,2)) AS Avg_Length_of_Stay
FROM dbo.fact_admissions adm
JOIN dbo.dim_departments dep
    ON adm.department_id = dep.department_id
GROUP BY
    dep.department_name,
    dep.facility_type
ORDER BY Avg_Length_of_Stay DESC;
-- Result: ICU and Oncology show highest average stays


-- I2. Which diagnosis has the highest number of admissions?
-- -------------------------------------------------------
SELECT
    dia.illness_name,
    COUNT(adm.admission_id) AS Total_Admissions
FROM dbo.fact_admissions adm
JOIN dbo.dim_diagnoses dia
    ON adm.diagnosis_id = dia.diagnosis_id
GROUP BY dia.illness_name
ORDER BY Total_Admissions DESC;
-- Result: Kidney Disease leads with 50,361 admissions


-- I3. What is the average wait time per facility type?
-- -------------------------------------------------------
SELECT
    dep.facility_type,
    CAST(AVG(adm.wait_time_hours) AS DECIMAL(5,2)) AS Avg_Wait_Time_Hours
FROM dbo.fact_admissions adm
JOIN dbo.dim_departments dep
    ON adm.department_id = dep.department_id
GROUP BY dep.facility_type
ORDER BY Avg_Wait_Time_Hours DESC;
-- Result: All facilities average ~12.26 hours — critically above 8hr target


-- I4. How many admissions per age group?
-- -------------------------------------------------------
SELECT
    pat.age_group,
    COUNT(adm.admission_id) AS Total_Admissions
FROM dbo.fact_admissions adm
JOIN dbo.dim_patients pat
    ON adm.patient_id = pat.patient_id
GROUP BY pat.age_group
ORDER BY Total_Admissions DESC;
-- Result: Middle Aged 221,605 (highest) | Adolescent 55,839 (lowest)


-- I5. Which doctor has handled the most admissions?
-- -------------------------------------------------------
WITH DoctorAdmissionsCTE AS (
    SELECT
        doc.doctor_name,
        doc.specialization,
        COUNT(adm.admission_id) AS Total_Admissions
    FROM dbo.fact_admissions adm
    JOIN dbo.dim_doctors doc
        ON adm.doctor_id = doc.doctor_id
    GROUP BY
        doc.doctor_name,
        doc.specialization
),
RankedDoctorsCTE AS (
    SELECT
        *,
        ROW_NUMBER() OVER(ORDER BY Total_Admissions DESC) AS Rankings
    FROM DoctorAdmissionsCTE
)
SELECT *
FROM RankedDoctorsCTE
WHERE Rankings <= 10;
-- Result: Top doctor: Dr. Sarah Mokoena with 30,119 admissions


-- I6. What is the monthly admission trend across all years?
-- -------------------------------------------------------
SELECT
    YEAR(dat.admission_date)  AS Year,
    MONTH(dat.admission_date) AS Month,
    COUNT(adm.admission_id)   AS Total_Admissions
FROM dbo.fact_admissions adm
JOIN dbo.dim_dates dat
    ON adm.date_id = dat.date_id
GROUP BY
    YEAR(dat.admission_date),
    MONTH(dat.admission_date)
ORDER BY Year, Month ASC;
-- Result: Consistent volume across months | December peaks annually


-- ============================================================
-- SECTION 3: ADVANCED ANALYSIS
-- Skills: CASE WHEN, DATEDIFF, LAG(), PARTITION BY, 
--         Occupancy Rate Formula, Mortality Rate
-- ============================================================


-- A1. What is the bed occupancy rate per department?
-- -------------------------------------------------------
WITH BedOccupancyCTE AS (
    SELECT
        dep.department_name,
        dep.facility_type,
        dep.total_beds,
        COUNT(adm.admission_id) AS Current_Admitted
    FROM dbo.fact_admissions adm
    JOIN dbo.dim_departments dep
        ON adm.department_id = dep.department_id
    WHERE adm.status = 'Admitted'
    AND   dep.total_beds > 0
    GROUP BY
        dep.department_name,
        dep.facility_type,
        dep.total_beds
)
SELECT
    department_name,
    facility_type,
    total_beds,
    Current_Admitted,
    CAST(
        Current_Admitted * 1.0 / total_beds * 100
    AS DECIMAL(5,2)) AS Bed_Occupancy_Pct
FROM BedOccupancyCTE
ORDER BY Bed_Occupancy_Pct DESC;
-- Result: ICU and Emergency show highest occupancy rates
-- Note: Clinics excluded (0 beds) to prevent divide by zero


-- A2. What is the readmission rate per diagnosis?
-- -------------------------------------------------------
WITH IllnessAdmissionsCTE AS (
    SELECT
        dia.illness_name        AS Illness,
        dia.illness_category    AS Category,
        SUM(adm.readmission)    AS Total_Readmissions,
        COUNT(adm.admission_id) AS Total_Admissions
    FROM dbo.fact_admissions adm
    JOIN dbo.dim_diagnoses dia
        ON adm.diagnosis_id = dia.diagnosis_id
    GROUP BY
        dia.illness_name,
        dia.illness_category
),
ReadmissionRateCTE AS (
    SELECT
        *,
        CAST(
            Total_Readmissions * 1.0 / Total_Admissions * 100
        AS DECIMAL(5,2)) AS Readmission_Rate_Pct
    FROM IllnessAdmissionsCTE
)
SELECT *
FROM ReadmissionRateCTE
ORDER BY Readmission_Rate_Pct DESC;
-- Result: All diagnoses cluster around 8% — chronic diseases most impactful by volume


-- A3. What is the average length of stay per age group and illness category?
-- -------------------------------------------------------
SELECT
    pat.age_group           AS Age_Group,
    dia.illness_category    AS Illness_Category,
    CAST(AVG(adm.length_of_stay) AS DECIMAL(5,2)) AS Avg_Length_of_Stay
FROM dbo.fact_admissions adm
JOIN dbo.dim_patients pat
    ON adm.patient_id = pat.patient_id
JOIN dbo.dim_diagnoses dia
    ON adm.diagnosis_id = dia.diagnosis_id
GROUP BY
    pat.age_group,
    dia.illness_category
ORDER BY Avg_Length_of_Stay DESC;
-- Result: Elderly + Chronic combination shows longest average stay
-- Business insight: Highest cost segment — targeted for early intervention


-- A4. Which province has the highest mortality rate?
-- -------------------------------------------------------
WITH ProvinceMortalityCTE AS (
    SELECT
        pat.province,
        COUNT(adm.admission_id) AS Total_Admissions,
        SUM(CASE WHEN adm.status = 'Deceased' THEN 1 ELSE 0 END) AS Total_Deceased
    FROM dbo.fact_admissions adm
    JOIN dbo.dim_patients pat
        ON adm.patient_id = pat.patient_id
    GROUP BY pat.province
)
SELECT
    province,
    Total_Admissions,
    Total_Deceased,
    CAST(
        Total_Deceased * 1.0 / Total_Admissions * 100
    AS DECIMAL(5,2)) AS Mortality_Rate_Pct
FROM ProvinceMortalityCTE
ORDER BY Mortality_Rate_Pct DESC;
-- Result: Provinces show ~2% mortality rate
-- Note: Gauteng leads in volume but rate analysis reveals true risk provinces
-- Key function: CASE WHEN inside SUM() — counts only rows matching condition


-- A5. What is the month-over-month admission growth trend?
-- -------------------------------------------------------
WITH MonthlyAdmissions AS (
    SELECT
        YEAR(dat.admission_date)  AS Year,
        MONTH(dat.admission_date) AS Month,
        COUNT(adm.admission_id)   AS Total_Admissions
    FROM dbo.fact_admissions adm
    JOIN dbo.dim_dates dat
        ON adm.date_id = dat.date_id
    GROUP BY
        YEAR(dat.admission_date),
        MONTH(dat.admission_date)
),
GrowthCTE AS (
    SELECT
        *,
        LAG(Total_Admissions) OVER(
            ORDER BY Year, Month
        ) AS Previous_Month_Admissions
    FROM MonthlyAdmissions
)
SELECT
    Year,
    Month,
    Total_Admissions,
    Previous_Month_Admissions,
    CAST(
        (Total_Admissions - Previous_Month_Admissions) * 1.0
        / Previous_Month_Admissions * 100
    AS DECIMAL(5,2)) AS MoM_Growth_Pct
FROM GrowthCTE
WHERE Previous_Month_Admissions IS NOT NULL
ORDER BY Year, Month ASC;
-- Result: Admission volume growing year-on-year
-- 2025 shows highest monthly averages on record


-- ============================================================
-- BONUS: VALIDATION QUERIES
-- ============================================================


-- Validate KPIs match Power BI dashboard
SELECT
    COUNT(admission_id)                                                     AS Total_Admissions,
    COUNT(DISTINCT patient_id)                                              AS Total_Patients,
    CAST(AVG(CAST(length_of_stay AS DECIMAL(10,2))) AS DECIMAL(5,2))       AS Avg_LOS,
    CAST(AVG(wait_time_hours) AS DECIMAL(5,2))                             AS Avg_Wait_Time,
    CAST(SUM(readmission) * 1.0 / COUNT(admission_id) * 100 AS DECIMAL(5,2)) AS Readmission_Rate_Pct,
    CAST(
        SUM(CASE WHEN status = 'Deceased' THEN 1 ELSE 0 END) * 1.0
        / COUNT(admission_id) * 100
    AS DECIMAL(5,2))                                                        AS Mortality_Rate_Pct
FROM dbo.fact_admissions;
-- Expected: 1M | 50K | 14.99 | 12.26 | 8.03% | 1.99%


-- Validate 2022 figures
SELECT
    COUNT(adm.admission_id)                                                      AS Total_Admissions,
    CAST(AVG(CAST(adm.length_of_stay AS DECIMAL(10,2))) AS DECIMAL(5,2))        AS Avg_LOS,
    CAST(SUM(adm.readmission) * 1.0 / COUNT(adm.admission_id) * 100 AS DECIMAL(5,2)) AS Readmission_Rate
FROM dbo.fact_admissions adm
JOIN dbo.dim_dates dat ON adm.date_id = dat.date_id
WHERE dat.year = 2022;
-- Expected: 199,678 | 14.98 | 8.06%


-- ============================================================
-- END OF ANALYSIS
-- Author: Sanele Siyabonga Thusi
-- GitHub: https://github.com/STCybersec
-- ============================================================

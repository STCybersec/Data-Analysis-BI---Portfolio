
# 🏥 Project 3 - Healthcare Operations Dashboard

**Industry:** Healthcare - Public & Private Hospitals, Clinics (South Africa)
**Tools:** SQL Server · Power BI · Python · Star Schema Modeling
**Status:** ✅ Complete

---

## 📌 Executive Summary

South Africa's healthcare system operates under significant strain - public hospitals absorb the majority of patient volume while facing chronic resource constraints, rising readmission rates, and extended patient wait times. This project analysed **1,000,000 patient admissions** across **50,000 patients** in public hospitals, private hospitals, and clinics across all 9 South African provinces over 5 years (2021-2025). The analysis delivered an executive Power BI dashboard designed to give hospital leadership and Department of Health decision makers a clear, actionable view of operational performance, patient outcomes, and avoidable cost drivers.

---

## 🧩 Business Problem

Hospital leadership had access to raw admission records but no structured visibility into operational performance. Critical questions remained unanswered: Which provinces are under the most pressure? Are readmission rates within acceptable thresholds? Which age groups and diagnoses are consuming the most capacity? Which facility types are carrying disproportionate load? Without this visibility, resource allocation, staffing decisions, and intervention programs were being made without data-driven direction - while avoidable readmissions continued to cost the system tens of millions of rands annually.

---

## 🗂️ Dataset

| Table | Rows | Description |
|-------|------|-------------|
| fact_admissions | 1,000,000 | Patient admission records with outcomes |
| dim_patients | 50,000 | Patient demographics, age groups, provinces |
| dim_doctors | 100 | Doctors with specializations and facility types |
| dim_departments | 15 | Departments with bed counts and facility types |
| dim_diagnoses | 20 | Diagnoses with illness categories |
| dim_dates | 1,826 | Full date dimension 2021–2025 |

> **Data generated using Python + SQL Server using realistic SA healthcare distributions. No real patient data used.**

---

## 🏗️ Methodology

**1. Data Modelling**
Star schema with fact_admissions + 5 dimensions covering patient demographics, illness categories, bed capacity, doctor workload, admissions, outcomes, readmissions, and wait times.

**2. Data Generation & ETL Loading**
Synthetic SA healthcare data generated with Python using realistic distributions.

**3. SQL Analysis**
Basic to advanced queries on admissions, readmissions, mortality, LOS, wait times, bed occupancy, and provincial trends using CTEs, window functions, DATEDIFF, CASE, and LAG().

**4. Dashboard Development**
Narrative-first Power BI with cost-impact headline, KPI benchmarks, province pressure analysis, illness breakdowns, age group demand, and 5-year trend showing what happened, why it matters, and next actions.

---

## 🏗️ Data Model

```
dim_patients    ──┐
dim_doctors     ──┤
dim_departments ──┼──► fact_admissions
dim_diagnoses   ──┤
dim_dates       ──┘
```
> *<img width="1825" height="722" alt="Model_View_3" src="https://github.com/user-attachments/assets/dc01e0f0-fd35-4ec2-8b22-815f6824a424" />*


Star schema - `fact_admissions` at the centre, joined to 5 dimension tables via foreign keys (One to many connections).

---

## 🛠️ Skills Demonstrated

- Star schema design with 5 dimension tables
- SQL - aggregations, multi-table joins, CTEs, DATEDIFF, CASE WHEN inside SUM, LAG() for MoM trends
- Python - synthetic healthcare data generation with realistic SA distributions
- Power BI - narrative dashboard design, conditional KPI color coding, cost callout cards
- Healthcare analytics - readmission rate, mortality rate, ALOS, wait time, bed occupancy
- Business value quantification - translating operational metrics into rand cost impact

---

## ❓ Business Questions & Key Insights

| Business Question | Key Finding |
|---|---|
| Which province carries the most admission pressure? | Gauteng leads with 35% of national admission volume - aligned with population density |
| What is driving the most admissions by illness? | Chronic diseases are the #1 category - preventable with structured follow-up care programs |
| Which age group fills the most beds? | Middle Aged and Senior patients account for 44% of all admissions - highest risk segments |
| What is the readmission rate? | 8.03% - above the 6% target, representing 80,300 avoidable admissions over 5 years |
| What is the avoidable cost of readmissions? | R87.4M based on SA DoH tariffs - R22M could be saved annually by reaching the 6% target |
| What is the mortality rate? | 1.99% - within the 2% benchmark, but requires continued monitoring |
| How long are patients waiting? | Average wait time of 12.26 hours - critically above the 8-hour target |
| Is admission volume growing? | Yes - 2025 recorded the highest admission volume on record, trend is accelerating |

---

## 📊 Power BI Dashboard

> *<img width="962" height="727" alt="Dashboard_Preview" src="https://github.com/user-attachments/assets/76505df8-e07d-48f4-ab29-ea6888a7e61f" />*

**Dashboard includes:**
- Cost Impact Headline - R87.4M avoidable readmission cost callout with methodology
- KPI Cards - Total Admissions, Total Patients, Readmission Rate, AVG LOS, Mortality Rate, Avg Wait Time
- Last Month comparison values on all KPIs
- Total Admissions by Province (Bar Chart - color coded by urgency) - Red Immediate
- Illness Category (Bar Chart - shows Chronic disease dominance)
- Admissions by Facility and Age Group (Stacked Bar - shows demand distribution)
- Total Admissions Yearly Trend (Line Chart - 5 year comparison)
- Slicers - Year, Illness, Gender, City, Province, Department, Dep.Type

---

## 💡 Key Results

| Metric | Value | Benchmark | Status |
|--------|-------|-----------|--------|
| 🏥 Total Admissions | 1,000,000 | — | — |
| 👥 Total Patients | 50,000 | — | — |
| 🔄 Readmission Rate | 8.03% | < 6% | ⚠️ Above Target |
| 🛏️ Avg Length of Stay | 14.99 days | < 15 days | ✅ On Target |
| 💀 Mortality Rate | 1.99% | < 2% | ✅ On Target |
| ⏱️ Avg Wait Time | 12.26 hrs | < 8 hrs | 🔴 Critical |
| 💰 Avoidable Readmission Cost | R87.4M | — | 5-year total |
| 💰 Potential Annual Saving | R22M | — | If 6% target reached |
| 🏛️ Public Hospital Share | 53% | — | Highest load |
| 📍 Highest Pressure Province | Gauteng | — | 35% of admissions |

---

## 📋 Business Recommendations

**1. 🔴 Immediately address wait times - 12.26 hours is a patient safety risk**
50% above 8-hr target, 3× WHO guideline. Fast-track protocols, add peak intake staff, deploy task team immediately.

**2. ⚠️ Launch a Chronic Disease Post-Discharge Program to reduce readmissions**
Chronic diseases drive 8.03% readmissions (above 6% target). 7-day follow-up for middle-aged/senior patients could cut readmissions 20-30%, saving R22M annually.

**3. ⚠️ Redirect resources to Gauteng and Western Cape**
These provinces absorb 55% of admissions. Implement province-weighted resource model for staffing, equipment, and beds.

**4. 🟡 Protect mortality rate before it breaches the 2% threshold**
Middle-aged and senior patients have highest mortality risk. Proactive clinical protocols needed now.

**5. 🟡 Investigate public hospital capacity constraints**
Current capacity insufficient within 2-3 years. Begin expansion or clinic referral optimisation planning.

**6. 🟢 Leverage clinics to reduce public hospital pressure**
Redirect acute/non-emergency cases to clinics. Structured referral optimisation would reduce load, cut wait times, and lower costs simultaneously.

---

## 🔮 Planned Enhancements

- Doctor-level performance analysis - admissions, outcomes, and specialization demand
- Seasonal admission forecasting model - predict peak months for staffing optimization
- Medical aid vs non-medical aid outcome comparison
- Department-level bed occupancy rate with capacity threshold alerts
- Province-level mortality rate analysis (rate vs volume)

---

## 📁 Project Files

```
Project3-Healthcare-Operations/
├── dataset/
│   ├── patients.csv
│   ├── doctors.csv
│   ├── departments.csv
│   ├── diagnoses.csv
│   ├── dates.csv
│   └── admissions.csv
├── sql/
│   └── Healthcare_Analysis.sql
├── dashboard/
│   └── Healthcare_Operations.pbix
├── images/
│   ├── Dashboard_Preview.png
│   └── Model_View.png
└── README.md
```

---

*Part of the [Data Analytics & BI Portfolio](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main) by Sanele Siyabonga Thusi*

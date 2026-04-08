# 🏥 Project 3 - Healthcare Operations Dashboard

**Industry:** Healthcare - Public & Private Hospitals, Clinics (South Africa)
**Tools:** SQL Server · Power BI · Python · Star Schema Modelling
**Status:** ✅ Complete

---

## 📌 Executive Summary

South Africa's healthcare system operates under severe strain - public hospitals absorb the majority of patient volume while facing rising readmission rates and critically extended wait times. This project analysed **1,000,000 patient admissions** across **50,000 patients** in public hospitals, private hospitals and clinics across all 9 SA provinces over 5 years (2021-2025), giving hospital leadership a clear view of operational performance, patient outcomes and avoidable cost drivers.

---

## 🗂️ Data Model

```
dim_patients    ──┐
dim_doctors     ──┤
dim_departments ──┼──► fact_admissions (1,000,000 rows)
dim_diagnoses   ──┤
dim_dates       ──┘
```
> *<img width="1825" height="722" alt="Model_View_3" src="https://github.com/user-attachments/assets/988563d0-e7ac-4260-9ca7-ee0243471b30" />*

| Table | Rows | Description |
|-------|------|-------------|
| fact_admissions | 1,000,000 | Admissions with outcomes and wait times |
| dim_patients | 50,000 | Demographics, age groups, SA provinces |
| dim_doctors | 100 | Specializations and facility types |
| dim_departments | 15 | Departments with bed counts |
| dim_diagnoses | 20 | Diagnoses with illness categories |
| dim_dates | 1,826 | 2021-2025 date dimension |

---

## 📊 Key Results

| Metric | Value | Benchmark | Status |
|--------|-------|-----------|--------|
| Readmission Rate | 8.03% | < 7% | ⚠️ Above Target |
| Avg Length of Stay | 14.99 days | < 15 days | ✅ On Target |
| Mortality Rate | 1.99% | < 2% | ✅ On Target |
| Avg Wait Time | 12.26 hrs | < 8 hrs | 🔴 Critical |
| Avoidable Cost | R87.4M | — | 5-year readmission cost |
| Potential Saving | R22M | — | If 6% target reached |
| Public Hospital Share | 53% | — | Highest load |

---
> *<img width="962" height="727" alt="Dashboard_Preview" src="https://github.com/user-attachments/assets/6b25a630-52c8-42ae-a522-082c2219235d" />*

## 🔍 Analysis

**Define**
SA hospitals face rising readmission rates and wait times that exceed safe clinical thresholds. Leadership had no structured view of which departments, age groups or diagnoses were driving avoidable admissions and costs.

**Measure**
8.03% readmission rate - above the 7% target - represents 80,300 avoidable admissions over 5 years. At SA DoH tariffs (H1/H2: R70/day, H3: R80/day) and a 53/33/13 facility mix, this costs R87.4M. Average wait time of 12.26 hours is more than 50% above the 8-hour target. Chronic diseases are the leading illness category - the most preventable admission type.

**Analyze - Whys**
1. Readmission rate exceeds target → 80,300 patients returning unnecessarily
2. Patients returning unnecessarily → no structured post-discharge follow-up
3. No post-discharge follow-up → chronic disease patients discharged without care continuity
4. No care continuity → outpatient capacity is insufficient to absorb post-discharge volume
5. Outpatient capacity insufficient → public hospitals carry 53% of volume with fixed resources and no overflow mechanism

**Root cause: Absence of post-discharge care continuity for chronic disease patients is the primary readmission driver - preventable with a structured follow-up protocol.**

**Improve**
Implement a 7-day post-discharge follow-up programme for chronic disease patients - targeting Middle Aged and Senior age groups who account for 44% of admissions. Evidence shows this reduces readmissions by 20-30%, saving approximately R22M annually. Address wait times through peak-hour triage staffing protocols.

**Control**
Monthly readmission rate tracking per department. Flag any month exceeding 9% for clinical review. Track wait time weekly - any department exceeding 16 hours triggers an emergency staffing review.

---

## 📋 Recommendations

1. 🔴 **Address wait times immediately** - 12.26 hours is a patient safety risk, exceeding WHO emergency guidelines by 3x
2. 🔴 **Launch chronic disease post-discharge programme** - reduces readmissions from 8% to 6%, saving R22M annually
3. ⚠️ **Protect mortality rate** - at 1.99% it is within 0.01% of breaching the 2% benchmark
4. ⚠️ **Resource allocation must reflect Gauteng's 35% admission share** - current equal-distribution model is insufficient
5. 🟢 **Redirect non-emergency cases to clinics** - clinics handle only 13% of admissions, reducing public hospital pressure

---

## 🛠️ Skills Demonstrated

SQL · Power BI · Python · Star Schema · CTEs · DATEDIFF · CASE WHEN inside SUM · LAG() · Bed Occupancy Rate · Mortality Rate · Healthcare KPIs · Cost Quantification · DMAIC · 5 Whys

---

## 📁 Project Files

```
Project3-Healthcare-Operations/
├── dataset/          → 6 CSV files
├── sql/              → healthcare_analysis.sql
├── dashboard/        → healthcare_operations.pbix
├── images/           → dashboard_preview.png | model_view.png
└── README.md
```

---

*Part of the [Data Analytics & BI Portfolio](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main) by Sanele Siyabonga Thusi*

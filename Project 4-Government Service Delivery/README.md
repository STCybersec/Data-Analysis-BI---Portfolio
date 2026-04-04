# 🏛️ Project 4 - Government Service Delivery Analytics

**Industry:** Public Sector - Municipal Government (South Africa)
**Tools:** SQL Server · Power BI · Python · Star Schema Modeling
**Status:** ✅ Complete

---

## 📌 Executive Summary

Service delivery failure is one of South Africa's most persistent governance challenges - affecting millions of citizens daily through water outages, electricity failures, pothole-riddled roads, and housing backlogs. This project analysed **500,000 service delivery requests** across **24 municipalities** in Gauteng, Western Cape, and KwaZulu-Natal over 5 years (2021-2025). The analysis delivered an executive Power BI dashboard designed to give Department of Cooperative Governance leadership a clear, data-driven view of municipal performance, SLA compliance, budget utilisation, and citizen satisfaction - identifying which municipalities are failing and what it is costing the fiscus.

---

## 🧩 Business Problem

Municipal leadership and provincial government had access to raw service request logs but no structured visibility into operational performance. Critical questions remained unanswered: Which municipalities are consistently failing SLA targets? Where is budget being wasted? Which service request types take the longest to resolve? Which departments are underperforming on citizen satisfaction? Without this visibility, interventions, budget reallocation, and accountability measures were being applied without data-driven direction - while service delivery protests continued to signal systemic failure on the ground.

---

## 🗂️ Dataset

| Table | Rows | Description |
|-------|------|-------------|
| fact_service_requests | 500,000 | Service requests with resolution, budget and SLA data |
| dim_citizens | 20,000 | Citizen demographics across 3 provinces |
| dim_departments | 10 | Government departments with SLA targets |
| dim_municipalities | 24 | SA municipalities across Gauteng, Western Cape, KZN |
| dim_request_types | 20 | SA-specific service request categories |
| dim_dates | 1,826 | Full date dimension 2021–2025 |

> **Data generated using Python + SQL Server using realistic SA municipal performance distributions. No real citizen data used.**

---

## 🏗️ Methodology

**1. Data Modelling**
Government star schema: fact_service_requests + 5 dimensions covering citizen demographics, municipality/province, department SLAs, request types, budgets, satisfaction, compliance, and escalations.

**2. Data Generation & ETL Loading**
Synthetic SA municipal data (60% SLA compliance reflecting real underperformance, 45% Gauteng volume weighting, budget variance patterns) using Python.

**3. SQL Analysis**
Request volumes, SLA compliance, budget variance, resolution times, escalations, satisfaction, municipal rankings, cost/request, and MoM trends using NULLIF(), SUM(CASE), weighted scoring, and LAG().

**4. Dashboard Development**
Executive Power BI with narrative-first design: SLA + budget headlines, color-coded municipal rankings, department resolution, request breakdown, and budget variance showing what's failing, where, and at what cost.

---

## 🏗️ Data Model

```
dim_citizens        ──┐
dim_departments     ──┤
dim_municipalities  ──┼──► fact_service_requests
dim_request_types   ──┤
dim_dates           ──┘
```

Star schema - `fact_service_requests` at the centre, joined to 5 dimension tables via foreign keys (One to many connections).

---

## 🛠️ Skills Demonstrated

- Star schema design with 5 dimension tables
- SQL - aggregations, multi-table joins, CTEs, NULLIF(), CASE WHEN inside SUM(), composite scoring, LAG() for MoM trends
- Python - synthetic government data generation with realistic SA municipal distributions
- Power BI - municipal performance dashboards, budget variance analysis, SLA compliance tracking
- Government analytics - SLA compliance, escalation rates, budget variance, cost per request, composite performance ranking
- Business value quantification - translating SLA failures into rand cost impact

---

## ❓ Business Questions & Key Insights

| Business Question | Key Finding |
|---|---|
| What is the overall SLA compliance rate? | Only 41.99% of requests resolved within SLA targets - critically below the 70% benchmark |
| Which province generates the most requests? | Gauteng leads with 228,460 requests - 45% of national volume |
| Which municipality is failing worst? | Ranked by SLA breach rate - bottom performers identified for intervention |
| Which department takes longest to resolve? | Housing averages 11+ days - highest resolution time across all departments |
| What is the budget situation? | R12.6B allocated vs R9.9B spent - R2.6B underspent, signalling project non-delivery |
| Which request type is most common? | Burst Pipe / Water Outage leads - infrastructure decay is the primary citizen complaint |
| What is the escalation rate? | ~10% of requests escalated - indicating systemic failure in first-line resolution |
| What do citizens think? | Satisfaction scores reveal which departments are failing citizen experience |

---

## 📊 Power BI Dashboard

> *Screenshot coming soon*

**Dashboard includes:**
- KPI Cards - Total Requests, SLA Compliance %, Avg Resolution Days, Escalation Rate, Budget Variance
- Requests by Municipality (Bar Chart - performance league table)
- Request Status Breakdown (Donut Chart - open vs resolved vs escalated)
- Avg Resolution Days by Department (Bar Chart - slowest departments)
- Monthly Request Trend (Line Chart - 5 year comparison)
- Budget Allocated vs Spent by Department (Clustered Bar - waste analysis)
- Satisfaction Score by Department (Bar Chart - citizen experience)

---

## 💡 Key Results

| Metric | Value | Benchmark | Status |
|--------|-------|-----------|--------|
| 📋 Total Requests | 500,000 | — | — |
| ✅ SLA Compliance Rate | 41.99% | > 70% | 🔴 Critical |
| ⏱️ Avg Resolution Days | Varies by dept | Per SLA target | ⚠️ Mixed |
| ⬆️ Escalation Rate | ~10% | < 5% | 🔴 Above Target |
| 💰 Budget Allocated | R12.6B | — | — |
| 💰 Budget Spent | R9.9B | — | — |
| 💰 Budget Underspent | R2.6B | 0 variance | 🔴 Non-delivery |
| 🏆 Most Common Request | Burst Pipe / Water Outage | — | Infrastructure crisis |
| 📍 Highest Volume Province | Gauteng | — | 45% of all requests |

---

## 📋 Business Recommendations

**1. 🔴 Declare a service delivery intervention in bottom-performing municipalities**
41.99% SLA compliance means <50% of requests resolved on time. Flag for provincial intervention (Section 139) with monthly performance improvement plans.

**2. 🔴 Investigate R2.6 billion in budget underspending**
This represents services not delivered, not savings. Conduct forensic budget review per department/municipality for planning failures or procurement delays. Reallocate unspent funds to highest-need areas.

**3. ⚠️ Fix first-line resolution to reduce escalation rate**
10% escalation rate (double 5% benchmark). Frontline staff need authority, resources, and training to resolve requests at point of contact.

**4. ⚠️ Prioritise Water & Sanitation infrastructure repair**
Burst pipe/water outage is the most common request, indicating ageing infrastructure. Ring-fence maintenance budget for water reticulation with preventive scheduling.

**5. 🟡 Implement Housing department process reform**
11+ day average resolution (highest across all departments). Implement process mapping, digital case management, and dedicated housing officers per municipality.

**6. 🟢 Replicate top-performing municipality practices**
Top municipalities prove high compliance is achievable. Launch peer-learning program for bottom performers at minimal cost.

---

## 🔮 Planned Enhancements

- Ward-level service request mapping for hyper-local performance analysis
- Budget utilisation forecasting model - predict year-end underspending by Q3
- Citizen satisfaction trend analysis by request type and province
- SLA breach cost quantification - rand value of every day beyond target

---

## 📁 Project Files

```
Project4-Government-Service-Delivery/
├── dataset/
│   ├── dim_citizens.csv
│   ├── dim_departments.csv
│   ├── dim_municipalities.csv
│   ├── dim_request_types.csv
│   ├── dim_dates.csv
│   └── fact_service_requests.csv
├── sql/
│   └── government_analysis.sql
├── dashboard/
│   └── government_service_delivery.pbix
├── images/
│   ├── dashboard_preview.png
│   └── model_view.png
└── README.md
```
> **fact_service_requests is not stored as CSV due to file size. Run generate_fact_service_requests.sql to recreate the full 500,000 row dataset locally.**

---

*Part of the [Data Analytics & BI Portfolio](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main) by Sanele Siyabonga Thusi*

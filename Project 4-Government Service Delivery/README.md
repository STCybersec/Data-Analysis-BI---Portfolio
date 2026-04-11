# 🏛️ Project 4 - Government Service Delivery Analytics

**Industry:** Public Sector - Municipal Government (South Africa)
**Tools:** SQL Server · Power BI · Python · Star Schema Modelling
**Status:** ✅ Complete

---

## 📌 Executive Summary

500,000 municipal service requests across 24 municipalities in Gauteng, Western Cape and KwaZulu-Natal were analysed over 5 years (2021-2025). The analysis revealed that only **41.99% of requests are resolved within SLA targets** and **R2.65B in budget went underspent** - not savings, but projects that were never delivered. This dashboard gives Department of Cooperative Governance leadership a data-driven view of where the system is failing and what it is costing citizens.

---

## 🗂️ Data Model

```
dim_citizens        ──┐
dim_departments     ──┤
dim_municipalities  ──┼──► fact_service_requests (500,000 rows)
dim_request_types   ──┤
dim_dates           ──┘
```

| Table | Rows | Description |
|-------|------|-------------|
| fact_service_requests | 500,000 | Requests with resolution, budget and SLA data |
| dim_citizens | 20,000 | Citizen demographics |
| dim_departments | 10 | Departments with SLA targets |
| dim_municipalities | 24 | SA municipalities across 3 provinces |
| dim_request_types | 20 | SA-specific service categories |
| dim_dates | 1,826 | 2021-2025 date dimension |

> *<img width="1463" height="720" alt="Model_View (2)" src="https://github.com/user-attachments/assets/305c394f-24c4-4ad8-ad9b-002b0af6ffb8" />*

---

## 📊 Key Results

| Metric | Value | Benchmark | Status |
|--------|-------|-----------|--------|
| SLA Compliance | 41.99% | < 70% | 🔴 Critical |
| Escalation Rate | 9.93% | > 5% | 🔴 Above Target |
| Avg Resolution Days | 7.77 days | Per SLA | ⚠️ Mixed |
| Budget Underspent | R2.65B | Zero variance | 🔴 Non-delivery |
| Satisfaction Score | 3.75 / 5 | < 4.0 | ⚠️ Below Target |
| Top Request Type | Burst Pipe / Water Outage | - | Infrastructure crisis |

> *<img width="920" height="730" alt="Dashboard_Preview (3)" src="https://github.com/user-attachments/assets/c76bb2d9-807a-41a1-9d8d-8848e35e96a4" />*

---

## 🔍 Feedback Analysis

**Define**
SA municipalities are failing to resolve citizen service requests on time. Less than half of 500,000 requests logged between 2021 and 2025 were resolved within their SLA targets - directly impacting citizen trust and service delivery outcomes.

**Measure**
41.99% SLA compliance. 9.93% escalation rate - double the 5% benchmark. Housing department averages 15.9 days to resolve requests against a 14-day target. R2.65B allocated but unspent across all departments.

**Analyze - Whys**
1. Requests are not resolved on time → departments exceed SLA targets
2. Departments exceed targets → Housing and Education breach most consistently
3. Housing and Education breach most → 10% of requests escalated beyond frontline staff
4. Requests escalate → frontline staff lack authority to approve spend or procure contractors
5. Frontline staff lack authority → municipal procurement requires multi-level approval for any expenditure

**Root cause: Procurement bureaucracy and lack of frontline decision-making authority is the primary SLA failure driver - not staff capacity.**

**Improve**
Delegate procurement authority up to R50,000 to department heads for standard service requests. Implement a 7-day fast-track resolution protocol for Critical and High priority requests. Introduce monthly SLA performance reporting per municipality with automatic escalation triggers.

**Control**
Monthly Power BI dashboard review at municipal manager level. Any municipality falling below 50% SLA compliance triggers a provincial performance improvement plan. Quarterly budget utilisation review to address underspending before year-end.

---

## 📋 Recommendations

1. 🔴 **Intervene in bottom-performing municipalities** - Section 139 intervention for municipalities with SLA compliance below 40%
2. 🔴 **Investigate R2.65B underspend** - forensic review per department to identify whether cause is planning failure, procurement delay or capacity constraint
3. ⚠️ **Fix first-line resolution** - reduce escalation rate from 10% to below 5% through frontline authority delegation
4. ⚠️ **Prioritise Water & Sanitation** - Burst Pipe is the most common request type, signalling ageing infrastructure requiring a ring-fenced maintenance budget
5. 🟢 **Replicate top performer practices** - structured peer-learning between highest and lowest ranked municipalities

---

## 🛠️ Skills Demonstrated

SQL · Power BI · Python · Star Schema · CTEs · Window Functions · CASE WHEN · LAG() · Composite Scoring · NULLIF() · Budget Variance Analysis · DMAIC · Root Cause Analysis

---

## 📁 Project Files

```
Project4-Government-Service-Delivery/
├── dataset/          → 5 dimension table CSVs
├── sql/
│   ├── government_analysis.sql       → analytical queries
│   └── DATA_GENERATION_NOTES.md      → fact table generation notes
├── dashboard/        → Dashboard_Preview(3).png
├── images/           → Dashboard_Preview.png | model_view.png
└── README.md
```

---

*Part of the [Data Analytics & BI Portfolio](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main) by Sanele Siyabonga Thusi*

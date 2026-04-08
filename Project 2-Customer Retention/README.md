# 📊 Project 2 - Customer Retention Analytics

**Industry:** E-Commerce
**Tools:** SQL Server · Power BI · Python · Star Schema Modelling
**Status:** ✅ Complete

---

## 📌 Executive Summary

An e-commerce business operating across 5 countries had transaction data but no visibility into customer behaviour - who was returning, who was at risk of churning, and which segments drove lifetime value. This project analysed **500,000 orders** across **5,000 customers** over 5 years (2021-2025), delivering a dashboard that gave leadership actionable insight into retention, acquisition and revenue by segment.

---

## 🗂️ Data Model

```
dim_customers ──┐
dim_products  ──┤
                ├──► fact_orders (500,000 rows)
dim_payment   ──┤
dim_dates     ──┘
```
> *<img width="1848" height="781" alt="Model_View" src="https://github.com/user-attachments/assets/7eeea215-8e38-4aeb-97fc-5d5e8bddaf36" />*


| Table | Rows | Description |
|-------|------|-------------|
| fact_orders | 500,000 | Orders with return flag |
| dim_customers | 5,000 | Demographics with latitude & longitude |
| dim_products | 40 | Products across 7 categories |
| dim_payment | 7 | Payment methods |
| dim_dates | 1,826 | 2021-2025 date dimension |

---

## 📊 Key Results

| Metric | Value | Insight |
|--------|-------|---------|
| Total Revenue | R340.72M | ▲ 3.13% vs Last Month |
| Total Orders | 498,000 | Across 5 countries |
| Return Rate | 4.99% | Healthy for e-commerce |
| Top Segment CLV | R68,777 | Occasional - High Value segment |
| At Risk CLV | R68,755 | Nearly matches top segment |
| Top Payment Method | Credit Card | Leads all 5 countries |
| Seasonal Peak | Q4 | November-December highest acquisition |

---
> *<img width="1337" height="858" alt="Dashboard_CR" src="https://github.com/user-attachments/assets/6feb1317-10a9-4524-915d-ba0c846c8949" />*


## 🔍 Analysis

**Define**
The business could not identify which customers were churning, which segments to prioritise, or where retention investment would generate the highest return. Marketing spend was undirected.

**Measure**
At Risk segment CLV of R68,755 is virtually equal to the High Value segment at R68,777 - meaning the business is on the verge of losing its most valuable customers. Return rate is healthy at 4.99% but the At Risk segment size signals imminent revenue loss.

**Analyze - Whys**
1. Revenue at risk → At Risk segment nearly matches High Value CLV
2. At Risk segment is large → no retention mechanism targeting lapsing customers
3. No retention mechanism → business had no visibility into segment behaviour before this analysis
4. No visibility → transaction data existed but was never structured for behavioural analysis
5. Data not structured → no dimensional model connecting orders to customer segments over time

**Root cause: Absence of customer behaviour analytics allowed high-value customers to lapse undetected - the data existed but was never modelled for retention insight.**

**Improve**
Launch an immediate win-back campaign targeting At Risk customers using personalised offers based on previous purchase category. Introduce a loyalty programme for High Value and Champion segments. Front-load Q3 marketing budgets to maximise Q4 acquisition peaks.

**Control**
Monthly CLV tracking per segment. Alert when At Risk segment revenue exceeds 25% of total - triggers immediate retention intervention. Track return rate by category to catch emerging product quality issues early.

---

## 📋 Recommendations

1. 🔴 **Urgently address At Risk segment** - R68,755 CLV at risk of churning, win-back campaign required immediately
2. ⚠️ **Protect High Value segment** - dedicated loyalty programme to prevent CLV erosion
3. ⚠️ **Double down on Q4 acquisition** - seasonal pattern is consistent, scale campaigns and stock from October
4. 🟢 **Expand in Johannesburg, London and New York** - highest customer concentration, localised campaigns would yield strong ROI

---

## 🛠️ Skills Demonstrated

SQL · Power BI · Python · Star Schema · CTEs · Window Functions · LAG() · CLV Calculation · Customer Segmentation · Map Visuals · DAX Time Intelligence · Return Rate Analysis

---

## 📁 Project Files

```
Project2-Customer-Retention/
├── dataset/          → 5 CSV files
├── sql/              → retention_analysis.sql
├── dashboard/        → customer_retention.pbix
├── images/           → dashboard_preview.png | model_view.png
└── README.md
```

---

*Part of the [Data Analytics & BI Portfolio](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main) by Sanele Siyabonga Thusi*

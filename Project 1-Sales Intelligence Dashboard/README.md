# 📊 Project 1 - Sales Intelligence Dashboard

**Industry:** Retail
**Tools:** SQL Server · Power BI · Python · Star Schema Modelling
**Status:** ✅ Complete

---

## 📌 Executive Summary

A retail business operating across 3 countries needed visibility into revenue performance, product demand and customer behaviour. This project analysed **500,000 transactions** across **5,000 customers** and **50 products** over 5 years (2021-2025), delivering an executive Power BI dashboard that transformed raw sales data into clear business decisions.

---

## 🧩 Business Problem

The retail business lacked a centralised view of sales performance. Decision-makers could not easily identify which products, regions, or customers were driving revenue - or spot seasonal patterns that could inform stock and marketing strategies. Without this visibility, budget and resource allocation decisions were being made without reliable data.

---

## 🗂️ Data Model

```
dim_customers ──┐
dim_products  ──┤
                ├──► fact_sales (500,000 rows)
dim_regions   ──┤
dim_dates     ──┘
```
> *<img width="1418" height="723" alt="Model_View_SI_BI" src="https://github.com/user-attachments/assets/ae822540-74bd-4ce4-88fc-0de82c6d7e94" />* 

| Table | Rows | Description |
|-------|------|-------------|
| fact_sales | 500,000 | Order transactions |
| dim_customers | 5,000 | Customer demographics - SA, USA, UK |
| dim_products | 50 | Products across 7 categories |
| dim_regions | 6 | Sales regions with managers |
| dim_dates | 1,826 | 2021-2025 date dimension |

---

## 📊 Key Results

| Metric | Value | Insight |
|--------|-------|---------|
| Total Revenue | R571.37M | Consistent YoY growth |
| Total Orders | 500,000 | 2021-2025 |
| Items Sold | 2,749,608 | Across all categories |
| Top Category | Electronics | R287M - 50.3% of total revenue |
| Top Region | International | R96.1M |
| Top Customer Spend | R207 219,24 | Linda Cele |
| Seasonal Peak | December | Holiday demand spike annually |

> *<img width="1299" height="729" alt="Dashboard_SI_BI" src="https://github.com/user-attachments/assets/4c2c1c60-0f69-454c-a379-969abcac5a4c" />*

---

## 🔍 Analysis

**Define**
The business had no structured view of which products, regions and customers were driving revenue - marketing and stock decisions were made without data-driven direction.

**Measure**
Electronics accounts for 50.3% of revenue - R287M of R571M total. The bottom 3 categories (Books, Health, Clothing) contribute less than 10% combined. Revenue grew consistently from R113M in 2021 to R115M in 2025.

**Analyze - Whys**
1. Revenue is concentrated in one category → Electronics dominates at 50%
2. Electronics dominates → high unit price products (Laptop R1,200, Desktop R1,500) drive disproportionate revenue
3. Other categories underperform → lower price points and lower purchase frequency
4. Lower purchase frequency → customers buy electronics once but consumables repeatedly
5. No repeat purchase strategy → no loyalty or upsell mechanism driving cross-category spend

**Root cause: Revenue concentration risk - single category dependency with no cross-sell strategy in place.**

**Improve**
Bundle low-performing categories with Electronics purchases. Introduce loyalty incentives for repeat buyers in Health and Sports. Target top 10 customers - averaging R560K spend - with exclusive offers to increase basket size.

**Control**
Monthly revenue dashboard review. Flag any month where Electronics drops below 45% of revenue - may indicate demand shift requiring stock reallocation. Track top customer spend quarterly.

---

## 📋 Recommendations

1. 🔴 **Reduce category concentration risk** - Electronics at 50% creates single-point revenue vulnerability
2. ⚠️ **Activate the International region** - leads revenue despite smallest customer base - high value segment underserved
3. ⚠️ **Build a December strategy** - seasonal spike is predictable, stock and campaign preparation should begin in October
4. 🟢 **Retain top 10 customers** - averaging R197K per customer, dedicated account management would protect this revenue

---

## 🛠️ Skills Demonstrated

SQL · Power BI · Python · Star Schema · JOINs · CTEs · Window Functions · LAG() · RANK() · PARTITION BY · Revenue Analysis · Customer Segmentation

---

## 📁 Project Files

```
Project1-Sales-Intelligence/
├── dataset/          → 5 CSV files
├── sql/              → sales_analysis.sql
├── dashboard/        → sales_dashboard.pbix
├── images/           → dashboard_preview.png | model_view.png
└── README.md
```

---

*Part of the [Data Analytics & BI Portfolio](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main) by Sanele Siyabonga Thusi*

# 📊 Project 1 - Sales Intelligence Dashboard

**Industry:** Retail
**Tools:** SQL Server · Power BI · Python · Star Schema Modeling
**Status:** ✅ Complete

---

## 📌 Executive Summary

A retail business with 5 years of transaction history needed clarity on what was driving revenue, which customers and products mattered most, and where regional growth opportunities existed. This project delivered a fully interactive Power BI dashboard built on a star schema data warehouse - giving leadership a single source of truth for sales performance across **500,000 transactions** spanning 5,000 customers, 50 products, and 6 regions.

---

## 🧩 Business Problem

The retail business lacked a centralised view of sales performance. Decision-makers could not easily identify which products, regions, or customers were driving revenue - or spot seasonal patterns that could inform stock and marketing strategies. Without this visibility, budget and resource allocation decisions were being made without reliable data.

---

## 🗂️ Dataset

| Table | Rows | Description |
|-------|------|-------------|
| fact_sales | 500,000 | Order transactions |
| dim_customers | 5,000 | Customer demographics - SA, USA, UK |
| dim_products | 50 | Products across 7 categories |
| dim_regions | 6 | Sales regions with managers |
| dim_dates | 1,826 | Full date dimension 2021–2025 |

> **Data generated using Python + SQL Server. No sensitive or real customer data used.**

---

## 🏗️ Methodology

**1. Data Modelling**
Designed a star schema with `fact_sales` at the centre, connected to 4 dimension tables via foreign keys. This structure enables fast, flexible querying across any combination of product, customer, region, and time.

**2. Data Generation & Loading**
Synthetic dataset generated using Python and loaded into SQL Server, simulating realistic retail transaction patterns including seasonality and regional variation.

**3. SQL Analysis**
Wrote analytical queries using aggregations, multi-table joins, CTEs, and window functions (`LAG`, `RANK`) to answer core business questions and surface trends over time.

**4. Dashboard Development**
Built an executive Power BI dashboard with KPI cards, trend charts, category breakdowns, regional comparisons, and a top customer table - designed for non-technical stakeholders.

---

## 🏗️ Data Model

```
dim_customers ──┐
dim_products  ──┤
                ├──► fact_sales
dim_regions   ──┤
dim_dates     ──┘
```
> *<img width="1418" height="723" alt="Model_View_SI_BI" src="https://github.com/user-attachments/assets/4da825eb-d556-472a-af8f-d7fc9569e6f4" />*

Star schema - `fact_sales` at the centre, joined to 4 dimension tables via foreign keys.

---

## 🛠️ Skills Demonstrated

- Star schema design & dimensional modelling
- SQL - aggregations, multi-table joins, CTEs, window functions, `LAG()`, `RANK()`
- Python - synthetic data generation
- Power BI - KPI cards, trend charts, regional maps, executive storytelling
- Business insight translation - turning query results into actionable findings

---

## 📊 Business Questions & Key Insights

| Business Question | Key Finding |
|---|---|
| What drove the most revenue? | Electronics accounted for 50.3% of all sales (R287M) |
| Which region performs best? | International region led with R96.1M despite the smallest customer base |
| How is revenue trending? | Consistent YoY growth - 2025 is the strongest year on record |
| Who are our highest-value customers? | Top 10 customers averaged ~R197K spend each - a critical retention segment |
| What is the seasonal pattern? | December spikes every year - consistent holiday demand surge |
| Which products lead sales? | Top 5 products are all within the Electronics category |
| What is the average order value? | Calculated across 500K orders to benchmark per-transaction performance |

---

## 📊 Power BI Dashboard

> *<img width="1299" height="729" alt="Dashboard_SI_BI" src="https://github.com/user-attachments/assets/fb83a7b4-17f4-41cc-ab8c-b80531ad2676" />*

**Dashboard includes:**
- KPI Cards - Total Revenue, Total Orders, Items Sold, Avg Order Value
- Monthly Revenue Trend (Line Chart)
- Revenue by Category (Bar Chart)
- Top 5 Products (Horizontal Bar)
- Revenue by Region (Bar)
- Top 10 Customers (Table)

---

## 💡 Key Results

| Metric | Value |
|--------|-------|
| 💰 Total Revenue | R571,370,401.85 |
| 📦 Total Orders | 500,000 |
| 🛒 Items Sold | 2,749,608 |
| 🏆 Top Category | Electronics - R287M (50.3% of revenue) |
| 🌍 Top Region | International - R96.1M |
| 👤 Top 10 Customer Avg Spend | ~R197K per customer |

---

## 📋 Business Recommendations

**1. Double down on Electronics**
With 50% of revenue from one category, there is a risk of customer concentration risk. Ensure stock levels, supplier relationships, and marketing budgets reflect this dependency. Diversification risk should also be assessed.

**2. Invest in the International region**
Leading revenue despite the smallest customer count signals high revenue-per-customer efficiency. This market warrants dedicated sales resources and expansion planning.

**3. Build a VIP retention programme**
The top 10 customers averaging ~R197K each represent disproportionate value. A targeted retention strategy - loyalty benefits, account management - would protect this revenue.

**4. Prepare for December demand**
Consistent holiday spikes should inform inventory pre-loading, staffing, and promotional planning at least 60 days in advance.

**5. Investigate underperforming regions**
If International leads despite fewer customers, lower-performing regions should be audited for pricing, product mix, or sales capability gaps.

---

## 📁 Project Files

```
Project1-Sales-Intelligence/
├── dataset/
│   ├── customers.csv
│   ├── products.csv
│   ├── regions.csv
│   ├── date.csv
│   └── sales.csv
├── sql/
│   └── sales_analysis.sql
├── dashboard/
│   └── Sales_Intelligence_BI.pbix
├── images/
│   ├── Dashboard_SI_BI.png
│   └── Model_View_SI_BI.png
└── README.md
```

---

*Part of the [Data Analytics & BI Portfolio](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main) by Sanele Siyabonga Thusi*

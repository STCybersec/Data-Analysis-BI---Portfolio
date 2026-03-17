# 📊 Project 1 - Sales Intelligence Dashboard

**Industry:** Retail
**Tools:** SQL Server · Power BI · Star Schema Modeling
**Status:** ✅ Complete

---

## 📌 Project Overview

A full end-to-end sales analytics project built on a star schema data warehouse containing **500,000 transactions** across 5,000 customers, 50 products, 6 regions, and 5 years of sales history (2021–2025).

The goal was to answer key business questions about revenue performance, product demand, regional contribution, and customer spend - and visualise the findings in an executive Power BI dashboard.

---

## 🗂️ Dataset

| Table | Rows | Description |
|-------|------|-------------|
| fact_sales | 500,000 | Order transactions |
| dim_customers | 5,000 | Customer demographics - SA, USA, UK |
| dim_products | 50 | Products across 7 categories |
| dim_regions | 6 | Sales regions with managers |
| dim_dates | 1,826 | Full date dimension 2021–2025 |

**Data generated using Python + SQL Server. No sensitive or real customer data used.**

---

## 🏗️ Data Model

```
dim_customers ──┐
dim_products  ──┤
                ├──► fact_sales
dim_regions   ──┤
dim_dates     ──┘
```

Star schema — fact_sales at the centre, joined to 4 dimension tables via foreign keys.

---

## 📊 Business Questions & Key Insights

| Question | Key Finding |
|---|---|
| What drove the most revenue? | Electronics accounted for 50% of all sales |
| Which region performs best? | International region led with R96M |
| How is revenue trending? | Consistent YoY growth — 2025 strongest year |
| Who are our best customers? | Top 10 customers averaged R560K spend each |
| What is seasonal pattern? | December spikes every year — holiday demand |

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

## 📁 Project Files

```
Project1-Sales-Intelligence/
├── dataset/
│   ├── dim_customers.csv
│   ├── dim_products.csv
│   ├── dim_regions.csv
│   ├── dim_dates.csv
│   └── fact_sales.csv
├── sql/
│   └── sales_analysis.sql
├── dashboard/
│   └── sales_dashboard.pbix
├── images/
│   └── dashboard_preview.png
└── README.md
```

---

## 💡 Key Insights

- Electronics dominates revenue at **50.3%** of total sales
- Revenue has grown **consistently year-on-year** from 2021 to 2025
- The **International region** leads all 6 regions despite being the smallest by customer count
- Top 10 customers contribute a disproportionate share — indicating high-value segment worth retaining
- **December** consistently shows the highest monthly revenue — seasonal demand spike

---

*Part of the [Data Analytics & BI Portfolio](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main) by Sanele Siyabonga Thusi*

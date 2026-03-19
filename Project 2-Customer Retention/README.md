# 📊 Project 2 - Customer Retention Analytics

**Industry:** E-Commerce
**Tools:** SQL Server · Power BI · Star Schema Modeling
**Status:** 🔄 In Progress

---

## 📌 Project Overview

A customer behaviour analytics project built on a star schema data warehouse containing **500,000 orders** across **5,000 customers** in 5 countries - South Africa, USA, UK, Australia, and Canada - spanning 5 years (2021–2025).

The goal was to answer key business questions about customer retention, repeat purchase behaviour, lifetime value, and acquisition trends - and visualise the findings in an interactive Power BI dashboard with map visuals.

---

## 🗂️ Dataset

| Table | Rows | Description |
|-------|------|-------------|
| fact_orders | 500,000 | Order transactions with return flag |
| dim_customers | 5,000 | Customer demographics with latitude & longitude |
| dim_products | 40 | Products across 7 categories |
| dim_payment | 7 | Payment methods |
| dim_dates | 1,826 | Full date dimension 2021–2025 |

**Data generated using Python + SQL Server. No sensitive or real customer data used.**

---

## 🏗️ Data Model

```
dim_customers ──┐
dim_products  ──┤
                ├──► fact_orders
dim_payment   ──┤
dim_dates     ──┘
```

Star schema — fact_orders at the centre, joined to 4 dimension tables via foreign keys.

**Key upgrades vs Project 1:**
- Customers include **latitude & longitude** - enables map visuals in Power BI
- Customers have a **segment** field (Champion, Loyal, At Risk, New, Dormant, High Value, Occasional)
- Customers have a **join_date** - enables acquisition trend analysis
- Orders include **is_return** flag - enables return rate analysis
- Orders include **unit_price** - enables margin analysis
- New **dim_payment** dimension - enables payment method analysis

---

## ❓ Business Questions & Key Insights

| Question | Key Finding |
|----------|-------------|
| How many customers are repeat buyers? | Repeat buyers contribute significantly more revenue than one-time buyers |
| Which payment method is most popular? | Credit Card and PayPal dominate across all 5 countries |
| Which customer segment drives the most value? | Champion and High Value segments drive the majority of CLV |
| Where are our customers located? | Geographic concentration in Johannesburg, London, and New York |
| How is customer acquisition trending? | Seasonal peaks in Q4 each year — November and December highest |
| What is the return rate? | Approximately 5% of orders are returned across all categories |
| Who are our highest value customers? | Top 10 customers show significantly above-average lifetime spend |
| Which category do repeat buyers prefer? | Electronics dominates repeat purchase behaviour |

---

## 📊 Power BI Dashboard

> *<img width="1337" height="858" alt="Screenshot 2026-03-19 034935" src="https://github.com/user-attachments/assets/8fe5c58e-dccc-4c9b-bb1f-01ca49e55070" />*

**Dashboard includes:**
- KPI Cards - Total Revenue, Total Orders, Total Customers, Return Rate
- New vs Repeat Buyers (Donut Chart)
- Customer Acquisition Trend (Line Chart)
- Revenue by Segment (Bar Chart)
- Revenue by Payment Method (Bar Chart)
- Customer Map - plotted by latitude & longitude (Map Visual)
- Top 10 Customers (Table)
- CLV by Segment (Column Chart)

---

## 📁 Project Files

```
Project2-Customer-Retention/
├── dataset/
│   ├── dim_customers.csv
│   ├── dim_products.csv
│   ├── dim_payment.csv
│   ├── dim_dates.csv
│   └── fact_orders.csv
├── sql/
│   └── retention_analysis.sql
├── dashboard/
│   └── customer_retention.pbix
├── images/
│   └── dashboard_preview.png
│   └── model_view.png
└── README.md
```

---

## 💡 Key Insights

- Customer map reveals **geographic concentration** in Johannesburg, London, and New York
- **Repeat buyers** contribute significantly more revenue than one-time buyers
- **Champion and High Value segments** drive the majority of CLV
- Credit Card and PayPal dominate payment preferences
- New customer acquisition shows **seasonal peaks** in Q4 each year

---

*Part of the [Data Analytics & BI Portfolio](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main) by Sanele Siyabonga Thusi*

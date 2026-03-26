# 📊 Project 2 - Customer Retention Analytics

**Industry:** E-Commerce
**Tools:** SQL Server · Power BI · Python · Star Schema Modeling
**Status:** ✅ Complete

---

## 📌 Executive Summary

An e-commerce business operating across 5 countries needed a clear picture of customer behaviour - who was returning, who was at risk of churning, and which segments were driving the most lifetime value. This project delivered an interactive Power BI dashboard built on a star schema data warehouse, analysing **500,000 orders** across **5,000 customers** over 5 years (2021-2025) - giving leadership actionable insight into retention, acquisition trends, and revenue by customer segment.

---

## 🧩 Business Problem

The business had transaction data but no visibility into customer behaviour patterns. They could not answer critical questions like: Which segments are most valuable? Where are we losing customers? What payment methods are driving revenue? Without this understanding, marketing spend, retention efforts, and acquisition strategies were being deployed without data-driven direction.

---

## 🗂️ Dataset

| Table | Rows | Description |
|-------|------|-------------|
| fact_orders | 500,000 | Order transactions with return flag |
| dim_customers | 5,000 | Customer demographics with latitude & longitude |
| dim_products | 40 | Products across 7 categories |
| dim_payment | 7 | Payment methods |
| dim_dates | 1,826 | Full date dimension 2021–2025 |

> **Data generated using Python + SQL Server. No sensitive or real customer data used.**

---

## 🏗️ Methodology

**1. Data Modelling**
Designed an upgraded star schema with `fact_orders` at the centre, connected to 4 dimension tables. Includes latitude/longitude for map visuals, customer segments, join dates for acquisition tracking, return flags, and a dedicated payment dimension.

**2. Data Generation & ET Loading**
Synthetic dataset generated using Python and loaded into SQL Server, illusttrating realistic e-commerce behaviour across 5 countries including seasonality, return patterns, and customer segmentation.

**3. SQL Analysis**
Wrote analytical queries using aggregations, CTEs, window functions, and joins to calculate customer lifetime value (CLV), acquisition trends, return rates, segment performance, and payment method breakdowns.

**4. Dashboard Development**
Built an interactive Power BI dashboard featuring map visuals, segment breakdowns, acquisition trends, and payment method analysis - designed to give both executive and operational stakeholders a complete view of customer health.

---

## 🏗️ Data Model

```
dim_customers ──┐
dim_products  ──┤
                ├──► fact_orders
dim_payment   ──┤
dim_dates     ──┘
```
> *<img width="1848" height="781" alt="Model_View" src="https://github.com/user-attachments/assets/95e027e0-bda9-4aee-953f-8582ccd0ef7c" />*

Star schema - `fact_orders` at the centre, joined to 4 dimension tables via foreign keys (One to many connections).

---

## 🛠️ Skills Demonstrated

- Star schema design & dimensional modelling
- SQL - aggregations, multi-table joins, CTEs, window functions, CLV calculations
- Python - synthetic data generation with realistic behavioural patterns
- Power BI - map visuals, segment analysis, acquisition trends, executive storytelling
- Customer analytics - segmentation, lifetime value, return rate analysis, acquisition tracking

---

## 📊 Business Questions & Key Insights

| Business Question | Key Finding |
|---|---|
| Which payment method is most popular? | Credit Card is the #1 payment method by revenue across all 5 countries |
| Which customer segment drives the highest CLV? | High Value leads at R68,777.74 - closely followed by At Risk at R68,755.72 |
| Where are our customers located? | Geographic concentration in South Africa, Canada, USA, UK and Australia |
| How is customer acquisition trending? | Seasonal peaks in Q4 each year - November and December are consistently highest |
| What is the return rate? | 4.99% return rate across all categories - healthy for e-commerce |
| Who are our highest-value customers? | Top 10 customers average R215,617.17 in lifetime spend |
| Which category do customers prefer? | Electronics dominates purchase behaviour across segments |
| How is revenue trending? | Revenue grew 3.13% vs last month and 25.30% vs last year |

---

## 📊 Power BI Dashboard

> *<img width="1337" height="858" alt="Dashboard_CR" src="https://github.com/user-attachments/assets/fedf7b5f-02a4-4e8c-8e7f-a364d078d10a" />*

**Dashboard includes:**
- KPI Cards - Total Revenue, Total Orders, Total Customers, Return Rate and Average Order Value
- Customer Acquisition Trend (Line Chart)
- Revenue by Segment (Bar Chart)
- Revenue by Payment Method (Bar Chart)
- Customer Map - plotted by latitude & longitude (Map Visual)
- Top 10 Customers (Table)

---

## 💡 Key Results

| Metric | Value |
|--------|-------|
| 💰 Total Revenue | R340.72M |
| 📦 Total Orders | 498,000 |
| 👥 Total Customers | 5,000 across 5 countries |
| 🔄 Return Rate | 4.99% - healthy for e-commerce |
| 📈 Revenue Growth MoM | ▲ 3.13% vs Last Month |
| 📈 Revenue Growth YoY | ▲ 25.30% vs Last Year |
| 💳 Top Payment Method | Credit Card |
| 🏆 Highest CLV Segment | High Value - R68,777.74 |
| ⚠️ Second Highest CLV Segment | At Risk - R68,755.72 |
| 👤 Top 10 Customer Avg Spend | R215,617.17 lifetime spend |

---

## 📋 Business Recommendations

**1. Urgently address the At Risk segment**
The At Risk segment holds the second highest CLV at R68,755.72 - nearly matching High Value customers. This means your most valuable customers are on the verge of churning. A targeted win-back campaign using personalised offers or direct outreach should be launched immediately to protect this revenue before it is lost permanently.

**2. Protect and grow the High Value segment**
At R68,777.74 CLV, High Value customers are the top revenue drivers. A dedicated loyalty programme - exclusive offers, early access, or account management - would strengthen retention and encourage further spend within this segment. Try to diversify to prevent revenue concentration risk.

**3. Double down on Q4 acquisition campaigns**
November and December consistently drive the highest acquisition. Marketing budgets should be front-loaded into Q3 preparation to maximise Q4 conversion - stock, campaigns, and customer service capacity should all be scaled accordingly.

**4. Investigate Electronics purchase dominance**
Electronics drives purchase behaviour across segments. Understanding the 'why' - product quality, price point, brand loyalty - can inform how other categories are positioned to replicate this pattern and reduce revenue concentration risk.

**5. Monitor return rate by category and region**
At 4.99% overall the return rate is healthy, but a breakdown by product category and country may reveal hidden problem areas being masked by the healthy average.

**6. Expand in high-density geographic markets**
Johannesburg, London, and New York show the highest customer concentration. Localised campaigns, currency optimisation, and region-specific product offerings in these markets would likely yield strong ROI.

---

## 🔮 Planned Enhancements

- Repeat vs one-time buyer segmentation analysis
- Cohort retention analysis by customer acquisition month
- Churn probability scoring by segment

---

## 📁 Project Files

```
Project2-Customer-Retention/
├── dataset/
│   ├── customers.csv
│   ├── products.csv
│   ├── payment.csv
│   ├── dates_P2.csv
│   └── orders.csv
├── sql/
│   └── Retention_Analysis.sql
├── dashboard/
│   └── CustomeRetention.pbix
├── images/
│   ├── Dashboard_CR.png
│   └── Model_View.png
└── README.md
```

---

*Part of the [Data Analytics & BI Portfolio](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main) by Sanele Siyabonga Thusi*

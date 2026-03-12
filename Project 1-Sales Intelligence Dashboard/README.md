# 📊 Project 1 — Sales Intelligence Dashboard

**Industry:** Retail
**Tools:** SQL Server · Power BI · Star Schema Modeling
**Status:** ✅ Complete

---

## 📌 Project Overview

A full end-to-end sales analytics project built on a star schema data warehouse containing **500,000 transactions** across 5,000 customers, 50 products, 6 regions, and 5 years of sales history (2021–2025).

The goal was to answer key business questions about revenue performance, product demand, regional contribution, and customer spend — and visualise the findings in an executive Power BI dashboard.

---

## 🗂️ Dataset

| Table | Rows | Description |
|-------|------|-------------|
| fact_sales | 500,000 | Order transactions |
| dim_customers | 5,000 | Customer demographics — SA, USA, UK |
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

## ❓ Business Questions & SQL Answers

### 🟢 Basic

**B1. What is the total revenue?**
```sql
SELECT SUM(sales_amount) AS Total_Revenue
FROM dbo.fact_sales;
-- Result: R571,370,401.85
```

**B2. How many total orders were placed?**
```sql
SELECT COUNT(order_id) AS Total_Orders
FROM dbo.fact_sales;
-- Result: 500,000
```

**B3. What is the total quantity of items sold?**
```sql
SELECT SUM(quantity) AS Total_Items_Sold
FROM dbo.fact_sales;
-- Result: 2,749,608
```

**B4. What are the unique product categories?**
```sql
SELECT DISTINCT category
FROM dbo.dim_products;
-- Result: Appliances, Books, Clothing, Electronics, Furniture, Health, Sports
```

**B5. How many customers do we have per country?**
```sql
SELECT country, COUNT(customer_name) AS Number_of_Customers
FROM dbo.dim_customers
GROUP BY country;
-- Result: South Africa: 2308 | USA: 1731 | UK: 961
```

---

### 🟡 Intermediate

**I1. What is total revenue per product category?**
```sql
SELECT
    pro.category,
    SUM(fac.sales_amount) AS Total_Revenue
FROM dbo.fact_sales fac
JOIN dbo.dim_products pro ON fac.product_id = pro.product_id
GROUP BY pro.category
ORDER BY Total_Revenue DESC;
-- Top: Electronics R287,818,354.32 | Bottom: Books R6,846,112.75
```

**I2. Top 5 best-selling products by revenue?**
```sql
WITH RevenueCTE AS (
    SELECT pro.product_name, SUM(fac.sales_amount) AS Total_Revenue
    FROM dbo.fact_sales fac
    JOIN dbo.dim_products pro ON fac.product_id = pro.product_id
    GROUP BY pro.product_name
),
RankedData AS (
    SELECT *, RANK() OVER(ORDER BY Total_Revenue DESC) AS Rankings
    FROM RevenueCTE
)
SELECT * FROM RankedData WHERE Rankings <= 5;
-- Result: Desktop, Laptop, Sofa, Smartphone, Wardrobe
```

**I3. Which region generates the most revenue?**
```sql
SELECT
    reg.region_name,
    SUM(fac.sales_amount) AS Total_Revenue
FROM dbo.fact_sales fac
JOIN dbo.dim_regions reg ON fac.region_id = reg.region_id
GROUP BY reg.region_name
ORDER BY Total_Revenue DESC;
-- Top: International R96,137,469.07 | Bottom: Central R93,532,671.50
```

**I4. What is the monthly revenue trend?**
```sql
SELECT
    YEAR(dat.order_date) AS Year,
    MONTH(dat.order_date) AS Month,
    SUM(fac.sales_amount) AS Total_Revenue
FROM dbo.fact_sales fac
JOIN dbo.dim_dates dat ON fac.date_id = dat.date_id
GROUP BY YEAR(dat.order_date), MONTH(dat.order_date)
ORDER BY Year, Month ASC;
```

**I5. Who are the top 10 customers by spend?**
```sql
WITH CustomerRevenue AS (
    SELECT cus.customer_name, SUM(fac.sales_amount) AS Total_Revenue
    FROM dbo.fact_sales fac
    JOIN dbo.dim_customers cus ON fac.customer_id = cus.customer_id
    GROUP BY cus.customer_name
),
RankedData AS (
    SELECT *, ROW_NUMBER() OVER(ORDER BY Total_Revenue DESC) AS Rankings
    FROM CustomerRevenue
)
SELECT * FROM RankedData WHERE Rankings <= 10;
-- Top Customer: Nkosi Perez R651,824.09
```

**I6. What is the average order value per region?**
```sql
SELECT
    reg.region_name,
    CAST(SUM(fac.sales_amount) / COUNT(fac.order_id) AS DECIMAL(18,2)) AS Avg_Order_Value
FROM dbo.fact_sales fac
JOIN dbo.dim_regions reg ON fac.region_id = reg.region_id
GROUP BY reg.region_name
ORDER BY Avg_Order_Value DESC;
```

---

### 🔴 Advanced

**A1. Rank products by revenue within each category**
```sql
WITH RevenueCTE AS (
    SELECT pro.product_name, pro.category, SUM(fac.sales_amount) AS Total_Revenue
    FROM dbo.fact_sales fac
    JOIN dbo.dim_products pro ON fac.product_id = pro.product_id
    GROUP BY pro.product_name, pro.category
),
RankedData AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY category ORDER BY Total_Revenue DESC) AS Rankings
    FROM RevenueCTE
)
SELECT * FROM RankedData WHERE Rankings = 1;
```

**A2. Month-over-month revenue growth**
```sql
WITH MonthlyRevenue AS (
    SELECT
        YEAR(dat.order_date) AS Year,
        MONTH(dat.order_date) AS Month,
        SUM(fac.sales_amount) AS Total_Revenue
    FROM dbo.fact_sales fac
    JOIN dbo.dim_dates dat ON fac.date_id = dat.date_id
    GROUP BY YEAR(dat.order_date), MONTH(dat.order_date)
),
GrowthCalc AS (
    SELECT *,
        LAG(Total_Revenue) OVER(ORDER BY Year, Month) AS Previous_Month_Revenue
    FROM MonthlyRevenue
)
SELECT
    Year, Month, Total_Revenue, Previous_Month_Revenue,
    CAST((Total_Revenue - Previous_Month_Revenue) / Previous_Month_Revenue * 100 AS DECIMAL(5,2)) AS MoM_Growth_Pct
FROM GrowthCalc
WHERE Previous_Month_Revenue IS NOT NULL
ORDER BY Year, Month;
```

**A3. Top 3 customers per country by spend**
```sql
WITH CustomerRevenue AS (
    SELECT cus.customer_name, cus.country, SUM(fac.sales_amount) AS Total_Revenue
    FROM dbo.fact_sales fac
    JOIN dbo.dim_customers cus ON fac.customer_id = cus.customer_id
    GROUP BY cus.customer_name, cus.country
),
RankedData AS (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY country ORDER BY Total_Revenue DESC) AS Rankings
    FROM CustomerRevenue
)
SELECT * FROM RankedData WHERE Rankings <= 3;
```

**A4. Revenue percentage contribution per category**
```sql
WITH CategoryRevenue AS (
    SELECT pro.category, SUM(fac.sales_amount) AS Total_Revenue
    FROM dbo.fact_sales fac
    JOIN dbo.dim_products pro ON fac.product_id = pro.product_id
    GROUP BY pro.category
)
SELECT
    category,
    Total_Revenue,
    CAST(Total_Revenue / SUM(Total_Revenue) OVER() * 100 AS DECIMAL(5,2)) AS Pct_Contribution
FROM CategoryRevenue
ORDER BY Pct_Contribution DESC;
```

**A5. Which year had the highest revenue and by how much?**
```sql
WITH RevenueDateCTE AS (
    SELECT YEAR(dat.order_date) AS Years, SUM(fac.sales_amount) AS Total_Revenue
    FROM dbo.fact_sales fac
    JOIN dbo.dim_dates dat ON fac.date_id = dat.date_id
    GROUP BY YEAR(dat.order_date)
),
Previous_Revenue AS (
    SELECT *, LAG(Total_Revenue) OVER(ORDER BY Years) AS Previous_Year_Revenue
    FROM RevenueDateCTE
)
SELECT *,
    CAST((Total_Revenue - Previous_Year_Revenue) AS DECIMAL(18,2)) AS Difference
FROM Previous_Revenue
ORDER BY Years ASC;
-- Best year: 2025 | Beat 2024 by R717,054.45
```

---

## 📊 Power BI Dashboard

> *Screenshot coming soon*

**Dashboard includes:**
- KPI Cards — Total Revenue, Total Orders, Items Sold, Avg Order Value
- Monthly Revenue Trend (Line Chart)
- Revenue by Category (Bar Chart)
- Top 5 Products (Horizontal Bar)
- Revenue by Region (Map / Bar)
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

*Part of the [Data Analytics & BI Portfolio](../README.md) by Sanele Siyabonga Thusi*

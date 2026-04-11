# 📊 Data Analytics & Business Intelligence Portfolio

Hi, I'm **Sanele Siyabonga Thusi** - a Data Analyst & BI Developer based in South Africa.

I build end-to-end analytics solutions: from data modeling and SQL analysis to Power BI dashboards that turn raw data into clear business decisions.

This portfolio contains **6 real-world projects** spanning retail, healthcare, government, fintech, logistics, and e-commerce - each demonstrating SQL, dimensional modeling, and Power BI dashboard development - plus a dedicated Python data cleaning section demonstrating the full data pipeline from raw to analysis-ready.

---

## 🧠 Core Skills

**Data Analysis**
- SQL - Joins, Aggregations, Window Functions, CTEs
- Data Cleaning & Transformation
- KPI Design & Business Metrics

**Business Intelligence**
- Power BI Dashboard Development
- Star Schema & Dimensional Modeling
- Executive Reporting & Storytelling

**Tools & Technologies**
- SQL Server · Power BI · Python · Excel · Power Query

---

## 📁 Repository Structure

```
Data-Analysis-BI---Portfolio/
│
├── Project 1-Sales Intelligence Dashboard/
│   ├── dataset/
│   ├── sql/
│   ├── dashboard/
│   ├── images/
│   └── README.md
│
├── Project 2-Customer Retention/
├── Project 3-Healthcare Operations/
├── Project 4-Government Service Delivery/
├── Project 5-Supply Chain Control Tower/
├── Project 6-Fintech Revenue Analytics/
│
├── Python-Data-Cleaning/
│   ├── Sales Intelligence Dashboard/
│   │   ├── Raw_Data/
│   │   │   └── Raw_Sales_Dirty.csv
│   │   ├── Cleaned_data/
│   │   │   └── Raw_Sales_Cleaned.csv
│   │   ├── Notebooks/
│   │   │   └── Sales_Data_Cleaning.ipynb
│   │   ├── Scripts/
│   │   │   └── Clean_Sales_Data.py
│   │   └── README.md
│   └── README.md
│
└── README.md
```

---

## 📁 BI & Analytics Projects

| # | Project | Industry | Status |
|---|---------|----------|--------|
| 1 | [Sales Intelligence Dashboard](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main/Project%201-Sales%20Intelligence%20Dashboard) | Retail | ✅ Complete |
| 2 | [Customer Retention Analytics](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main/Project%202-Customer%20Retention) | E-Commerce | ✅ Complete |
| 3 | [Healthcare Operations Dashboard](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main/Project%203-Healthcare%20Operations) | Healthcare | ✅ Complete |
| 4 | [Government Service Delivery Analytics](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main/Project%204-Government%20Service%20Delivery) | Public Sector | ✅ Complete |
| 5 | [Supply Chain Control Tower](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main/Project%205-Supply%20Chain%20Control%20Tower) | Logistics | ✅ Complete |
| 6 | [Fintech Revenue Analytics](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main/Project%206-Fintech%20Revenue%20Analytics) | Financial Services | ✅ Complete |

---

## 🐍 Python - Data Cleaning

| # | Dataset | Linked Project | Status |
|---|---------|----------------|--------|
| 1 | [Sales Intelligence Dashboard](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main/Python-Data-Cleaning/Sales_Intelligence_Dashboard) | Project 1 - Sales Intelligence Dashboard | 🔄 In Progress |
| 2 | [Customer Retention Analytics](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main/Python-Data-Cleaning/Customer_Retention) | Project 2 - Customer Retention Analytics | 🔄 In Progress |
| 3 | [Healthcare Operations Dashboard](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main/Python-Data-Cleaning/Healthcare_Operations) | Project 3 - Healthcare Operations Dashboard | 🔄 In Progress |
| 4 | [Government Service Delivery Analytics](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main/Python-Data-Cleaning/Government_Service_Delivery) | Project 4 - Government Service Delivery Analytics | 🔄 In Progress |
| 5 | [Supply Chain Control Tower](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main/Python-Data-Cleaning/Supply_Chain_Control_Tower) | Project 5 - Supply Chain Control Tower | 🔄 In Progress |
| 6 | [Fintech Revenue Analytics](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main/Python-Data-Cleaning/Fintech_Revenue_Analytics) | Project 6 - Fintech Revenue Analytics | 🔄 In Progress |

**What this section demonstrates:**
- Identifying and handling missing values
- Removing duplicate records
- Fixing incorrect data types (dates, numerics)
- Standardising inconsistent text formatting
- Flagging and isolating outliers
- Producing clean, analysis-ready datasets using Python & pandas

> *The cleaned datasets in this section feed directly into the SQL Server data warehouse and Power BI dashboards in the BI projects above — demonstrating a full end-to-end data pipeline.*

[📂 View Python Data Cleaning →](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main/Python-Data-Cleaning)

---

## Project 1 - Sales Intelligence Dashboard

**Industry:** Retail | **Status:** ✅ Complete

A full end-to-end sales analytics project built on a star schema data warehouse with 500,000 transactions across 5 years (2021-2025).

**Business Questions Answered:**
- What is total revenue and how has it trended over time?
- Which products and categories drive the most revenue?
- Which regions perform best?
- Who are the top customers by spend?

**Key Results:**
- 💰 Total Revenue: R571,370,401.85
- 📦 Total Orders: 500,000
- 🛒 Items Sold: 2,749,608
- 🏆 Top Category: Electronics (R287M - 50% of revenue)
- 🌍 Top Region: International (R96.1M)

**Skills Demonstrated:**
- Star schema design (fact + 4 dimension tables)
- SQL - aggregations, multi-table joins, CTEs, window functions, LAG(), RANK()
- Python - data cleaning pipeline (see Python-Data-Cleaning folder)
- Power BI dashboard with KPI cards, trend charts, regional mappings

[📂 View Project →](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main/Project%201-Sales%20Intelligence%20Dashboard)

---

## Project 2 - Customer Retention Analytics

**Industry:** E-Commerce | **Status:** ✅ Complete

Customer behaviour analytics focused on segmentation, lifetime value, acquisition trends, and return rate analysis across 5 countries.

**Business Questions Answered:**
- Which customer segment drives the highest CLV?
- Which payment method generates the most revenue?
- How is customer acquisition trending over time?
- What is the overall return rate?

**Key Results:**
- 💰 Total Revenue: R340.72M
- 👥 Total Customers: 5,000 across SA, USA, UK, Australia & Canada
- 🏆 Highest CLV Segment: High Value (R68,777.74)
- ⚠️ At Risk Segment CLV: R68,755.72 - nearly matching top segment
- 💳 Top Payment Method: Credit Card
- 🔄 Return Rate: 4.99%

**Skills Demonstrated:**
- Star schema with customer segmentation & geolocation
- SQL - CLV calculations, acquisition trends, return rate analysis
- Power BI - map visuals, segment analysis, MoM & YoY growth tracking

[📂 View Project →](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main/Project%202-Customer%20Retention)

---

## Project 3 - Healthcare Operations Dashboard

**Industry:** Healthcare | **Status:** ✅ Complete

Hospital operations analytics focused on patient flow, bed occupancy, and department workload.

**Business Questions Answered:**
- What is daily patient admission volume?
- What is average patient stay duration?
- Which departments are under most pressure?
- What is bed occupancy rate?

[📂 View Project →](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main/Project%203-Healthcare%20Operations)

---

## Project 4 - Government Service Delivery Analytics

**Industry:** Public Sector | **Status:** ✅ Complete

Tracking government service requests, resolution times, and departmental performance.

**Business Questions:**
- How many service requests are received per region?
- What is the average resolution time per department?
- Which departments have the highest backlog?

[📂 View Project →](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main/Project%204-Government%20Service%20Delivery)

---

## Project 5 - Supply Chain Control Tower

**Industry:** Logistics | **Status:** ✅ Complete

End-to-end supply chain analytics tracking shipments, warehouse efficiency, and delivery performance.

**Business Questions:**
- What is the average delivery time?
- Which warehouses process the most orders?
- Where are delays happening?

[📂 View Project →](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main/Project%205-Supply%20Chain%20Control%20Tower)

---

## Project 6 - Fintech Revenue Analytics

**Industry:** Financial Services | **Status:** ✅ Complete

Transaction and revenue analytics for a payments platform including merchant performance and payment method analysis.

**Business Questions:**
- Which payment methods generate the most revenue?
- What is daily transaction volume?
- Which merchants process the most payments?

[📂 View Project →](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main/Project%206-Fintech%20Revenue%20Analytics)

---

## 🎓 Education & Certifications

- BCom Information Technology Management - Mancosa *(2026-2029)*
- Cybersecurity SLP - University of Johannesburg
- Intelligent Systems Development (TensorFlow) - University of Johannesburg
- AI Fluency: Frameworks and Foundations - Anthropic
- Introduction to Agent Skills - Anthropic
- Data Analytics Essentials - Cisco
- Python Essentials 1 - Cisco
- Introduction to Data Science - Cisco

---

## 📬 Contact

📧 thusisanelelele@gmail.com
🐙 [GitHub](https://github.com/STCybersec)

> *"Data is only valuable when it drives better decisions."*

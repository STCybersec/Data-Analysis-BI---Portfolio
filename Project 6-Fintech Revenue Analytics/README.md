# 💳 Project 6 - Fintech Revenue Analytics

**Industry:** Financial Services - Payment Platform
**Tools:** SQL Server · Power BI · Python · Star Schema Modelling
**Status:** ✅ Complete

---

## 📌 Executive Summary

A payment platform operating across South Africa, UAE, UK and USA had no structured visibility into which merchants, markets and customer segments were driving fee revenue - while fraud and failed transactions were silently eroding the bottom line. This project analysed **500,000 transactions** across **10,000 customers** and **25 merchants** over 5 years (2021-2025), delivering an executive Fintech Control Tower dashboard that identified **R53.69M in fraud exposure** and a **7.94% failed transaction rate** threatening platform revenue integrity.

---

## 🗂️ Data Model

```
dim_customers     ──┐
dim_merchants     ──┤
dim_payment_types ──┼──► fact_transactions (500,000 rows)
dim_locations     ──┤
dim_dates         ──┘
```

| Table | Rows | Description |
|-------|------|-------------|
| fact_transactions | 500,000 | Transactions with fee, fraud and device data |
| dim_customers | 10,000 | Customer demographics and tier classification |
| dim_merchants | 25 | Merchants across 7 categories and 4 markets |
| dim_payment_types | 8 | Payment methods including crypto and BNPL |
| dim_locations | 15 | Cities with coordinates and currency |
| dim_dates | 1,826 | 2021-2025 date dimension |

> *<img width="1450" height="722" alt="Model_View" src="https://github.com/user-attachments/assets/8c6c5050-1e47-4384-8434-0395e5c1cf2f" />*
---

## 📊 Key Results

| Metric | Value | Benchmark | Status |
|--------|-------|-----------|--------|
| Gross Revenue | R2.66bn | — | 5-year total |
| Platform Fee Revenue | R66.40M | — | ~2.5% avg fee rate |
| Fraud Rate | 2.02% | < 2% | ⚠️ Above Target |
| Estimated Fraud Exposure | R53.69M | — | Critical risk |
| Failed Transaction Rate | 7.94% | < 5% | 🔴 Above Target |
| Avg Transaction Value | R5.31K | — | High value platform |
| Top Market | USA | — | Highest fee revenue |
| Top Merchant | Emirates Airlines | — | Highest fee contributor |
| Top Device | Mobile | 55.29% | Digital-first platform |
| Top Payment | Digital | — | Wallets dominate |

> *<img width="1164" height="623" alt="Dashboard_Preview" src="https://github.com/user-attachments/assets/fb824c76-b6fa-431d-8c75-439d6958a567" />*
---

## 🔍 Analysis

**Define**
The platform was processing R2.66bn in transactions with no visibility into fraud patterns, failed transaction drivers or merchant revenue concentration. Leadership could not answer which markets to prioritise, which merchants to protect or where revenue was being lost to failed and fraudulent transactions.

**Measure**
Platform fee revenue of R66.40M represents a 2.5% average fee rate across 500K transactions. Fraud rate of 2.02% - marginally above the 2% threshold - translates to R53.69M in fraud exposure. Failed transaction rate of 7.94% - nearly double the 5% benchmark - means 1 in 12 transactions never converts to revenue. USA generates the highest fee revenue despite SA having the largest customer base, indicating higher average transaction values in the US market.

**Analyze - Whys**
1. Failed transaction rate at 7.94% → revenue lost on 39,700 transactions annually
2. High failure rate → payment method and device type mismatches causing declines
3. Payment mismatches → Digital wallets dominate but POS infrastructure gaps cause failures at point of sale
4. POS infrastructure gaps → merchant onboarding in SA and UAE did not include POS device capability testing
5. No capability testing → platform had no transaction success monitoring by device type or merchant category before this analysis

**Root cause: Absence of transaction success monitoring by device and merchant category allowed a systemic POS failure pattern to persist undetected — costing the platform an estimated R5.3M in lost fee revenue annually.**

**Improve**
Implement real-time transaction success monitoring by device type and merchant. Require POS capability testing as part of merchant onboarding. Target failed transaction reduction from 7.94% to below 5% through device-merchant compatibility checks. Deploy fraud detection model flagging transactions above R50K from new devices in high-risk merchant categories.

**Control**
Weekly fraud rate dashboard review - any week exceeding 2.5% triggers immediate fraud team escalation. Monthly failed transaction rate by merchant - any merchant exceeding 10% failure rate placed on performance review. Platform fee revenue tracked daily against monthly targets.

---

## 📋 Recommendations

1. 🔴 **Address failed transaction rate urgently** - 7.94% means R5.3M in lost fee revenue annually, POS compatibility testing during merchant onboarding would eliminate the primary failure driver
2. 🔴 **Implement fraud detection model** - R53.69M fraud exposure at 2.02% rate requires automated flagging of high-risk transaction patterns before they complete
3. ⚠️ **Protect Emirates Airlines and Airbnb** - top two fee contributors by significant margin, dedicated merchant success managers would protect this concentration risk
4. ⚠️ **Grow the UK market** - lowest fee revenue despite strong merchant presence, targeted merchant acquisition and payment method localisation would unlock this market
5. ⚠️ **Convert Standard tier to Silver** - Standard customers generate the highest total fee revenue by volume but lowest per-customer value, a targeted upgrade incentive programme would increase CLV across the largest segment
6. 🟢 **Double down on Mobile** - 55.29% of transactions are mobile-first, investing in mobile UX optimisation and mobile wallet partnerships would reduce friction and increase conversion rates

---

## 🛠️ Skills Demonstrated

SQL · Power BI · Python · Star Schema · CTEs · Window Functions · LAG() · Fraud Rate Analysis · Fee Revenue Modelling · Customer Tier Segmentation · Merchant Performance · Device Type Analysis · DAX Time Intelligence · Conditional Formatting · DMAIC · 5 Whys

---

## 📁 Project Files

```
Project6-Fintech-Revenue-Analytics/
├── dataset/
│   ├── README.md                     → fact_transactions generation notes
│   ├── → Transactions.csv needs to be requested - file too big
│   ├── Customers.csv
│   ├── Merchants.csv
│   ├── Payment_types.csv
│   ├── Locations.csv
│   └── Dates.csv
├── sql/
│   └── fintech_analysis.sql
├── dashboard/
│   └── Fintech_Analytics.pbix
├── images/
│   ├──Dashboard_Preview.png
│   └── Model_View.png
└── README.md
```

---

*Part of the [Data Analytics & BI Portfolio](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main) by Sanele Siyabonga Thusi*

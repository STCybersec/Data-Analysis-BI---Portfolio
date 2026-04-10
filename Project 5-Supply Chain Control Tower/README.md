# 🚚 Project 5  Supply Chain Control Tower

**Industry:** Logistics & Supply Chain
**Tools:** SQL Server · Power BI · Python · Star Schema Modelling
**Status:** ✅ Complete

---

## 📌 Executive Summary

A global logistics operation spanning 10 warehouses across South Africa, UK, USA, Australia and UAE had no visibility into carrier performance, shipment delays or shipping cost efficiency. This project analysed **500,000 shipments** over 5 years (2021-2025), delivering an executive Supply Chain Control Tower dashboard that identified a **22.08% on-time delivery gap** against the 85% industry benchmark - with delayed shipments costing an estimated **R9.23M in premium freight charges.**

---

## 🗂️ Data Model

```
dim_warehouses ──┐
dim_suppliers  ──┤
dim_products   ──┼──► fact_shipments (500,000 rows)
dim_carriers   ──┤
dim_dates      ──┘
```

| Table | Rows | Description |
|-------|------|-------------|
| fact_shipments | 500,000 | Shipments with delivery status, costs and delays |
| dim_warehouses | 10 | Global warehouses with latitude & longitude |
| dim_suppliers | 10 | Suppliers by product category and origin country |
| dim_products | 15 | Products with unit price and weight |
| dim_carriers | 8 | Carriers by transport mode and service type |
| dim_dates | 1,826 | 2021-2025 date dimension |

> *<img width="1750" height="728" alt="Model_View (3)" src="https://github.com/user-attachments/assets/2c303b23-fe9d-4815-be86-738be7e802ef" />*
---

## 📊 Key Results

| Metric | Value | Benchmark | Status |
|--------|-------|-----------|--------|
| On Time Delivery % | 62.92% | > 85% | 🔴 Critical |
| On Time Gap | 22.08% | 0% gap | 🔴 Below Target |
| Delay Rate | 12.02% | < 10% | ⚠️ Above Target |
| Avg Delay Days | 7.03 days | < 3 days | 🔴 Critical |
| Total Shipping Cost | R512.09M | — | 5-year total |
| Estimated Delay Cost | R9.23M | — | Premium freight impact |
| Return Rate | 5.00% | < 5% | ⚠️ On boundary |
| Road vs Air Cost | R192M each | Road > Air | ⚠️ Imbalanced |

> *<img width="1350" height="722" alt="Dashboard_Preview (4)" src="https://github.com/user-attachments/assets/874451d7-b3fc-4c3d-b6b7-025dbeae16c8" />*
---

## 🔍 Analysis

**Define**
The business had no visibility into which carriers, warehouses or transport modes were driving delays and cost overruns. Shipment performance was tracked manually with no structured analytics - leaving leadership unable to identify root causes or take corrective action.

**Measure**
62.92% on-time delivery rate - 22.08 percentage points below the 85% industry benchmark. Every carrier in the network performs below target. Average delay of 7.03 days - more than double the 3-day benchmark. Road and Air freight costs are equal at R192M each despite Road being significantly cheaper per shipment - indicating Air is being overused for non-urgent shipments.

**Analyze - Whys**
1. On-time delivery is at 62.92% → all 8 carriers are below the 85% benchmark
2. All carriers underperform → the issue is not carrier-specific but systemic
3. Systemic delays → shipments are averaging 7.03 days late across all transport modes
4. Delays across all modes → order lead times are too short for the chosen transport mode
5. Lead times too short → procurement teams are defaulting to Air freight to compensate - driving up cost without improving delivery reliability

**Root cause: Poor lead time planning is forcing expensive Air freight as a reactive measure - increasing cost without resolving the underlying delay problem.**

**Improve**
Implement a transport mode optimisation framework - classify shipments by urgency and weight, assigning Sea and Rail for planned non-urgent orders and reserving Air freight for genuinely time-critical shipments only. Extend procurement lead times by 5 days minimum to allow Road and Sea routing. Target carrier SLA agreements with on-time delivery penalties for performance below 80%.

**Control**
Monthly carrier scorecard reviewed at logistics manager level. Any carrier dropping below 60% on-time delivery triggers a contract review. Road-to-Air freight ratio tracked quarterly - target ratio of 3:1 Road vs Air by value. Delay cost tracked monthly against the R9.23M baseline.

---

## 📋 Recommendations

1. 🔴 **Implement transport mode optimisation** - Road and Air at equal cost signals Air overuse, shifting non-urgent shipments to Road and Sea would reduce shipping cost by an estimated 15-20%
2. 🔴 **Extend procurement lead times** - 7-day average delays indicate lead times are systematically too short, adding 5-day buffer per order cycle would reduce delays without additional cost
3. ⚠️ **Introduce carrier SLA penalties** - all 8 carriers below 85% benchmark with no consequence management, performance-linked contracts would drive improvement
4. ⚠️ **Investigate Cape Town DC throughput** - leading all warehouses in shipment volume despite not being SA's primary logistics hub, capacity constraints may be masking efficiency issues
5. 🟢 **Leverage Dubai Hub as regional connector** - strategically positioned between SA, UK and Australia routes, optimising routing through Dubai could reduce transit times on international lanes

---

## 🛠️ Skills Demonstrated

SQL · Power BI · Python · Star Schema · CTEs · Window Functions · LAG() · On-Time Delivery Rate · Delay Cost Quantification · Carrier Performance Analysis · Transport Mode Analysis · Map Visuals · DAX Time Intelligence · DMAIC · 5 Whys

---

## 📁 Project Files

```
Project5-Supply-Chain-Control-Tower/
├── dataset/          → 5 dimension table CSVs
├── sql/              → supply_chain_analysis.sql
├── dashboard/        → supply_chain_control_tower.pbix
├── images/           → dashboard_preview(4).png | model_view(3).png
└── README.md
```

---

*Part of the [Data Analytics & BI Portfolio](https://github.com/STCybersec/Data-Analysis-BI---Portfolio/tree/main) by Sanele Siyabonga Thusi*

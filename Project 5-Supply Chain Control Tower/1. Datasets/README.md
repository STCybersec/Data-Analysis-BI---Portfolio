# 📦 Dataset - fact_shipments

## About This Dataset

`fact_shipments` contains **500,000 shipment records** generated using Python and loaded into SQL Server, covering global logistics operations across 10 warehouses in South Africa, UK, USA, Australia and UAE from 2021 to 2025.

---

## Why Only a Sample Is Stored Here

The full `fact_shipments` CSV exceeds GitHub's 25MB file size limit. A **50,000 row sample** is provided here for reference and schema inspection.

The complete 500,000 row dataset can be recreated by running:
```
Project5_SupplyChain.sql
```
against a local SQL Server instance with the database `Project5_SupplyChain` created.

---

## Schema

| Column | Type | Description |
|--------|------|-------------|
| shipment_id | INT | Primary key |
| warehouse_id | INT | FK to dim_warehouses |
| supplier_id | INT | FK to dim_suppliers |
| product_id | INT | FK to dim_products |
| carrier_id | INT | FK to dim_carriers |
| date_id | INT | FK to dim_dates |
| ship_date | DATE | Date shipment dispatched |
| expected_date | DATE | Planned delivery date |
| actual_delivery | DATE | Actual delivery date (NULL if not delivered) |
| days_in_transit | INT | Total days from dispatch to delivery |
| delay_days | INT | Days beyond expected date (0 if on time) |
| quantity | INT | Units shipped |
| unit_cost | DECIMAL | Cost per unit to the business |
| shipping_cost | DECIMAL | Freight cost for the shipment |
| total_value | DECIMAL | Total shipment value (quantity × unit_cost + shipping_cost) |
| delivery_status | VARCHAR | Delivered / In Transit / Delayed / Failed |
| order_status | VARCHAR | Completed / Processing / Cancelled / Returned |
| on_time_delivery | INT | 1 = delivered on time, 0 = late or undelivered |
| return_flag | INT | 1 = returned, 0 = not returned |

---

## Contact

For the full 500,000 row dataset contact:
📧 thusisanelelele@gmail.com

---

*Part of the [Supply Chain Control Tower Project](../README.md) by Sanele Siyabonga Thusi*

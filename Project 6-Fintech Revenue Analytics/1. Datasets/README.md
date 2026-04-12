# 📦 Dataset - fact_transactions

## About This Dataset

`fact_transactions` contains **500,000 financial transaction records** generated using Python and loaded into SQL Server, covering payment platform operations across South Africa, UK, USA and UAE from 2021 to 2025.

---

## Note

The full `fact_transactions` CSV exceeds GitHub's 25MB file size limit.

The complete 500,000 row dataset can be recreated by running:
```
Project6_Fintech.sql
```
against a local SQL Server instance with the database `Project6_Fintech` created.

---

## Schema

| Column | Type | Description |
|--------|------|-------------|
| transaction_id | INT | Primary key |
| customer_id | INT | FK to dim_customers |
| merchant_id | INT | FK to dim_merchants |
| payment_type_id | INT | FK to dim_payment_types |
| location_id | INT | FK to dim_locations |
| date_id | INT | FK to dim_dates |
| transaction_amount | DECIMAL | Gross transaction value in local currency |
| fee_amount | DECIMAL | Platform fee earned (1.5-3.5% of amount) |
| net_amount | DECIMAL | Amount received by merchant after fee |
| transaction_status | VARCHAR | Completed / Failed / Reversed / Pending |
| transaction_type | VARCHAR | Purchase / Refund / Transfer / Withdrawal |
| is_fraud | INT | 1 = fraudulent transaction, 0 = legitimate |
| device_type | VARCHAR | Mobile / Web / POS |

---

## Generation Parameters

| Parameter | Value |
|-----------|-------|
| Total rows | 500,000 |
| Date range | 2021-01-01 to 2025-12-31 |
| Fraud rate | ~2.02% |
| Failed transaction rate | ~7.94% |
| Completed rate | ~82.03% |
| Fee rate range | 1.5% - 3.5% per transaction |
| Avg transaction value | R5,310 |
| Device split | Mobile 55% / Web 30% / POS 15% |

---

## Key Distributions

**Transaction Status:**
- Completed - 82.03%
- Failed - 7.94%
- Reversed - 6.12%
- Pending - 4.02% (amended to Pending from earlier version)

**Transaction Type:**
- Purchase - 75%
- Refund - 10%
- Transfer - 10%
- Withdrawal - 5%

**Payment Categories:**
- Digital (Mobile Wallet, QR Code, Apple Pay, Crypto) - dominant
- Card (Credit & Debit) - second
- Bank Transfer - third
- Credit (BNPL) - lowest

**Markets:**
- South Africa - 40% of customers
- UAE - 20% of customers
- UK - 20% of customers
- USA - 20% of customers

---

## Contact

For the full 500,000 row dataset contact:
📧 thusisanelelele@gmail.com

---

*Part of the [Fintech Revenue Analytics Project](../README.md) by Sanele Siyabonga Thusi*

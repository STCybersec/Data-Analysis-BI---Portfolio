# ============================================================
# Project 2: Customer Retention Analytics
# Data Cleaning Script
# Author: Sanele Siyabonga Thusi
# Tool: Python (Pandas)
# ============================================================

import pandas as pd
import numpy as np

print("=" * 60)
print("PROJECT 2 - Customer Retention Analytics")
print("Data Cleaning Report")
print("=" * 60)

# === Load Data
fact_orders   = pd.read_csv("orders.csv")
dim_customers = pd.read_csv("customers.csv")
dim_products  = pd.read_csv("products.csv")
dim_payment   = pd.read_csv("payment.csv")
dim_dates     = pd.read_csv("dates_P2.csv")

# === Profile
def profile(df, name):
    print(f"\n--- {name} ---")
    print(f"Shape        : {df.shape}")
    print(f"Duplicates   : {df.duplicated().sum()}")
    print(f"Null counts  :\n{df.isnull().sum()[df.isnull().sum() > 0]}")

profile(fact_orders,   "fact_orders")
profile(dim_customers, "dim_customers")
profile(dim_products,  "dim_products")
profile(dim_payment,   "dim_payment")
profile(dim_dates,     "dim_dates")

# === Clean fact_orders
print("\n[1] Removing duplicate order IDs...")
before = len(fact_orders)
fact_orders = fact_orders.drop_duplicates(subset=["order_id"])
print(f"    Removed: {before - len(fact_orders)} duplicates")

print("[2] Removing negative or zero sales amounts...")
before = len(fact_orders)
fact_orders = fact_orders[fact_orders["sales_amount"] > 0]
print(f"    Removed: {before - len(fact_orders)} invalid rows")

print("[3] Validating is_return flag (must be 0 or 1)...")
invalid_flags = fact_orders[~fact_orders["is_return"].isin([0, 1])]
fact_orders = fact_orders[fact_orders["is_return"].isin([0, 1])]
print(f"    Removed: {len(invalid_flags)} invalid flag values")

print("[4] Removing negative unit prices...")
before = len(fact_orders)
fact_orders = fact_orders[fact_orders["unit_price"] > 0]
print(f"    Removed: {before - len(fact_orders)} invalid rows")

print("[5] Capping outlier sales amounts (above 99th percentile)...")
cap = fact_orders["sales_amount"].quantile(0.99)
outliers = (fact_orders["sales_amount"] > cap).sum()
fact_orders["sales_amount"] = fact_orders["sales_amount"].clip(upper=cap)
print(f"    Capped: {outliers} outlier values at {cap:.2f}")

# === Clean dim_customers
print("[6] Removing duplicate customer IDs...")
before = len(dim_customers)
dim_customers = dim_customers.drop_duplicates(subset=["customer_id"])
print(f"    Removed: {before - len(dim_customers)} duplicates")

print("[7] Standardising country and city to title case...")
dim_customers["country"] = dim_customers["country"].str.strip().str.title()
dim_customers["city"]    = dim_customers["city"].str.strip().str.title()

print("[8] Validating customer segments...")
valid_segments = ["Champion","Loyal","At Risk","New Customer","Dormant","High Value","Occasional"]
invalid_seg = dim_customers[~dim_customers["segment"].isin(valid_segments)]
dim_customers.loc[~dim_customers["segment"].isin(valid_segments), "segment"] = "Unknown"
print(f"    Fixed: {len(invalid_seg)} invalid segments set to Unknown")

print("[9] Removing invalid ages...")
before = len(dim_customers)
dim_customers = dim_customers[(dim_customers["age"] >= 18) & (dim_customers["age"] <= 80)]
print(f"    Removed: {before - len(dim_customers)} invalid ages")

print("[10] Converting join_date to datetime...")
dim_customers["join_date"] = pd.to_datetime(dim_customers["join_date"], errors="coerce")
null_dates = dim_customers["join_date"].isnull().sum()
print(f"    NULL join_dates: {null_dates}")

# === Clean dim_dates
print("[11] Converting order_date to datetime...")
dim_dates["order_date"] = pd.to_datetime(dim_dates["order_date"], errors="coerce")
null_dates = dim_dates["order_date"].isnull().sum()
dim_dates = dim_dates.dropna(subset=["order_date"])
print(f"    Dropped: {null_dates} unparseable dates")

# === Validate FK integrity
print("\n[12] Validating foreign key integrity...")
orphan_cust = fact_orders[~fact_orders["customer_id"].isin(dim_customers["customer_id"])]
orphan_prod = fact_orders[~fact_orders["product_id"].isin(dim_products["product_id"])]
orphan_pay  = fact_orders[~fact_orders["payment_id"].isin(dim_payment["payment_id"])]
print(f"    Orphan customer_ids : {len(orphan_cust)}")
print(f"    Orphan product_ids  : {len(orphan_prod)}")
print(f"    Orphan payment_ids  : {len(orphan_pay)}")

# === Summary
print("\n" + "=" * 60)
print("CLEANING SUMMARY")
print("=" * 60)
print(f"fact_orders   : {len(fact_orders):,} rows after cleaning")
print(f"dim_customers : {len(dim_customers):,} rows after cleaning")
print(f"dim_products  : {len(dim_products):,} rows after cleaning")
print(f"dim_payment   : {len(dim_payment):,} rows (no changes needed)")
print(f"dim_dates     : {len(dim_dates):,} rows after cleaning")

# === Export
fact_orders.to_csv("cleaned_fact_orders.csv", index=False)
dim_customers.to_csv("cleaned_dim_customers.csv", index=False)
dim_products.to_csv("cleaned_dim_products.csv", index=False)
dim_payment.to_csv("cleaned_dim_payment.csv", index=False)
dim_dates.to_csv("cleaned_dim_dates.csv", index=False)
print("\nAll cleaned files exported successfully.")

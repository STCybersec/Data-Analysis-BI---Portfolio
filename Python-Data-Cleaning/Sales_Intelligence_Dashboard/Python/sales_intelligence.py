# ============================================================
# Project 1: Sales Intelligence Dashboard
# Data Cleaning Script
# Author: Sanele Siyabonga Thusi
# Tool: Python (Pandas)
# ============================================================

import pandas as pd
import numpy as np

print("=" * 60)
print("PROJECT 1 - Sales Intelligence Dashboard")
print("Data Cleaning Report")
print("=" * 60)

# === Load Data 
fact_sales    = pd.read_csv("fact_sales.csv")
dim_customers = pd.read_csv("dim_customers.csv")
dim_products  = pd.read_csv("dim_products.csv")
dim_regions   = pd.read_csv("dim_regions.csv")
dim_dates     = pd.read_csv("dim_dates.csv")

# === Profile
def profile(df, name):
    print(f"\n--- {name} ---")
    print(f"Shape        : {df.shape}")
    print(f"Duplicates   : {df.duplicated().sum()}")
    print(f"Null counts  :\n{df.isnull().sum()[df.isnull().sum() > 0]}")

profile(fact_sales,    "fact_sales")
profile(dim_customers, "dim_customers")
profile(dim_products,  "dim_products")
profile(dim_regions,   "dim_regions")
profile(dim_dates,     "dim_dates")

# == Clean fact_sales
print("\n[1] Removing duplicate orders...")
before = len(fact_sales)
fact_sales = fact_sales.drop_duplicates(subset=["order_id"])
print(f"    Removed: {before - len(fact_sales)} duplicates")

print("[2] Removing negative or zero sales amounts...")
before = len(fact_sales)
fact_sales = fact_sales[fact_sales["sales_amount"] > 0]
print(f"    Removed: {before - len(fact_sales)} invalid rows")

print("[3] Removing negative quantities...")
before = len(fact_sales)
fact_sales = fact_sales[fact_sales["quantity"] > 0]
print(f"    Removed: {before - len(fact_sales)} invalid rows")

print("[4] Capping outlier sales amounts (above 99th percentile)...")
cap = fact_sales["sales_amount"].quantile(0.99)
outliers = (fact_sales["sales_amount"] > cap).sum()
fact_sales["sales_amount"] = fact_sales["sales_amount"].clip(upper=cap)
print(f"    Capped: {outliers} outlier values at {cap:.2f}")

# == Clean dim_customers
print("[5] Standardising country names to title case...")
dim_customers["country"] = dim_customers["country"].str.strip().str.title()

print("[6] Filling NULL customer names with placeholder...")
null_names = dim_customers["customer_name"].isnull().sum()
dim_customers["customer_name"] = dim_customers["customer_name"].fillna("Unknown Customer")
print(f"    Filled: {null_names} NULL names")

print("[7] Filling NULL cities with placeholder...")
null_cities = dim_customers["city"].isnull().sum()
dim_customers["city"] = dim_customers["city"].fillna("Unknown City")
print(f"    Filled: {null_cities} NULL cities")

print("[8] Removing invalid ages (below 0 or above 120)...")
before = len(dim_customers)
dim_customers = dim_customers[(dim_customers["age"] >= 0) & (dim_customers["age"] <= 120)]
print(f"    Removed: {before - len(dim_customers)} invalid ages")

# === Clean dim_products
print("[9] Removing negative prices...")
before = len(dim_products)
dim_products = dim_products[dim_products["price"] > 0]
print(f"    Removed: {before - len(dim_products)} invalid products")

print("[10] Standardising category names...")
dim_products["category"]     = dim_products["category"].str.strip().str.title()
dim_products["sub_category"] = dim_products["sub_category"].str.strip().str.title()

# === Clean dim_dates
print("[11] Converting order_date to datetime...")
dim_dates["order_date"] = pd.to_datetime(dim_dates["order_date"], errors="coerce")
null_dates = dim_dates["order_date"].isnull().sum()
dim_dates = dim_dates.dropna(subset=["order_date"])
print(f"    Dropped: {null_dates} unparseable dates")

# === Validate FK integrity
print("\n[12] Validating foreign key integrity...")
orphan_cust = fact_sales[~fact_sales["customer_id"].isin(dim_customers["customer_id"])]
orphan_prod = fact_sales[~fact_sales["product_id"].isin(dim_products["product_id"])]
orphan_reg  = fact_sales[~fact_sales["region_id"].isin(dim_regions["region_id"])]
orphan_date = fact_sales[~fact_sales["date_id"].isin(dim_dates["date_id"])]
print(f"    Orphan customer_ids : {len(orphan_cust)}")
print(f"    Orphan product_ids  : {len(orphan_prod)}")
print(f"    Orphan region_ids   : {len(orphan_reg)}")
print(f"    Orphan date_ids     : {len(orphan_date)}")

# === Summary
print("\n" + "=" * 60)
print("CLEANING SUMMARY")
print("=" * 60)
print(f"fact_sales    : {len(fact_sales):,} rows after cleaning")
print(f"dim_customers : {len(dim_customers):,} rows after cleaning")
print(f"dim_products  : {len(dim_products):,} rows after cleaning")
print(f"dim_regions   : {len(dim_regions):,} rows (no changes needed)")
print(f"dim_dates     : {len(dim_dates):,} rows after cleaning")

# === Export
fact_sales.to_csv("cleaned_fact_sales.csv", index=False)
dim_customers.to_csv("cleaned_dim_customers.csv", index=False)
dim_products.to_csv("cleaned_dim_products.csv", index=False)
dim_regions.to_csv("cleaned_dim_regions.csv", index=False)
dim_dates.to_csv("cleaned_dim_dates.csv", index=False)
print("\nAll cleaned files exported successfully.")

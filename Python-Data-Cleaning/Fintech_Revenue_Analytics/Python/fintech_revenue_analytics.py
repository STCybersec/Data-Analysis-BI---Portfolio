# ============================================================
# Project 6: Fintech Revenue Analytics
# Data Cleaning Script
# Author: Sanele Siyabonga Thusi
# Tool: Python (Pandas)
# ============================================================

import pandas as pd
import numpy as np

print("=" * 60)
print("PROJECT 6 - Fintech Revenue Analytics")
print("Data Cleaning Report")
print("=" * 60)

# === Load Data
fact_transactions  = pd.read_csv("fact_transactions_sample.csv")
dim_customers      = pd.read_csv("dim_customers.csv")
dim_merchants      = pd.read_csv("dim_merchants.csv")
dim_payment_types  = pd.read_csv("dim_payment_types.csv")
dim_locations      = pd.read_csv("dim_locations.csv")
dim_dates          = pd.read_csv("dim_dates.csv")

# === Profile
def profile(df, name):
    print(f"\n--- {name} ---")
    print(f"Shape        : {df.shape}")
    print(f"Duplicates   : {df.duplicated().sum()}")
    print(f"Null counts  :\n{df.isnull().sum()[df.isnull().sum() > 0]}")

profile(fact_transactions, "fact_transactions")
profile(dim_customers,     "dim_customers")
profile(dim_merchants,     "dim_merchants")
profile(dim_locations,     "dim_locations")

# === Clean fact_transactions
print("\n[1] Removing duplicate transaction IDs...")
before = len(fact_transactions)
fact_transactions = fact_transactions.drop_duplicates(subset=["transaction_id"])
print(f"    Removed: {before - len(fact_transactions)} duplicates")

print("[2] Removing zero or negative transaction amounts...")
before = len(fact_transactions)
fact_transactions = fact_transactions[fact_transactions["transaction_amount"] > 0]
print(f"    Removed: {before - len(fact_transactions)} invalid amounts")

print("[3] Removing negative fee amounts...")
before = len(fact_transactions)
fact_transactions = fact_transactions[fact_transactions["fee_amount"] >= 0]
print(f"    Removed: {before - len(fact_transactions)} invalid fee rows")

print("[4] Validating fee amount on completed transactions...")
missing_fee = fact_transactions[
    (fact_transactions["transaction_status"] == "Completed") &
    (fact_transactions["fee_amount"] == 0)
]
print(f"    Found: {len(missing_fee)} Completed transactions with zero fee")

print("[5] Validating net_amount = transaction_amount - fee_amount...")
fact_transactions["net_check"] = round(
    fact_transactions["transaction_amount"] - fact_transactions["fee_amount"], 2)
mismatches = (
    abs(fact_transactions["net_amount"] - fact_transactions["net_check"]) > 0.01
).sum()
fact_transactions["net_amount"] = fact_transactions["net_check"]
fact_transactions = fact_transactions.drop(columns=["net_check"])
print(f"    Corrected: {mismatches} net_amount mismatches recalculated")

print("[6] Validating is_fraud flag (0 or 1 only)...")
invalid = fact_transactions[~fact_transactions["is_fraud"].isin([0, 1])]
fact_transactions = fact_transactions[fact_transactions["is_fraud"].isin([0, 1])]
print(f"    Removed: {len(invalid)} invalid fraud flags")

print("[7] Checking fraud flag on failed transactions...")
fraud_failed = fact_transactions[
    (fact_transactions["is_fraud"] == 1) &
    (fact_transactions["transaction_status"] == "Completed")
]
print(f"    Found: {len(fraud_failed)} fraud-flagged completed transactions — valid for investigation")

print("[8] Validating transaction status values...")
valid_statuses = ["Completed", "Failed", "Reversed", "Pending"]
fact_transactions.loc[
    ~fact_transactions["transaction_status"].isin(valid_statuses),
    "transaction_status"] = "Unknown"

print("[9] Validating transaction type values...")
valid_types = ["Purchase", "Refund", "Transfer", "Withdrawal"]
fact_transactions.loc[
    ~fact_transactions["transaction_type"].isin(valid_types),
    "transaction_type"] = "Unknown"

print("[10] Validating device type values...")
valid_devices = ["Mobile", "Web", "POS"]
fact_transactions.loc[
    ~fact_transactions["device_type"].isin(valid_devices),
    "device_type"] = "Unknown"

print("[11] Capping outlier transaction amounts (above 99th percentile)...")
cap = fact_transactions["transaction_amount"].quantile(0.99)
outliers = (fact_transactions["transaction_amount"] > cap).sum()
fact_transactions["transaction_amount"] = \
    fact_transactions["transaction_amount"].clip(upper=cap)
print(f"    Capped: {outliers} outlier amounts at {cap:.2f}")

# === Clean dim_customers
print("[12] Validating customer tiers...")
valid_tiers = ["Standard", "Silver", "Gold", "Platinum"]
invalid_tier = ~dim_customers["customer_tier"].isin(valid_tiers)
dim_customers.loc[invalid_tier, "customer_tier"] = "Standard"
print(f"    Fixed: {invalid_tier.sum()} invalid tiers set to Standard")

print("[13] Removing invalid ages...")
before = len(dim_customers)
dim_customers = dim_customers[
    (dim_customers["age"] >= 18) & (dim_customers["age"] <= 80)]
print(f"    Removed: {before - len(dim_customers)} invalid ages")

print("[14] Standardising country names...")
dim_customers["country"] = dim_customers["country"].str.strip().str.title()

# === Clean dim_locations
print("[15] Validating currency codes (3 characters)...")
invalid_curr = dim_locations[dim_locations["currency"].str.len() != 3]
print(f"    Found: {len(invalid_curr)} invalid currency codes")

print("[16] Validating latitude and longitude ranges...")
invalid_lat = dim_locations[
    (dim_locations["latitude"] < -90) | (dim_locations["latitude"] > 90)]
invalid_lon = dim_locations[
    (dim_locations["longitude"] < -180) | (dim_locations["longitude"] > 180)]
print(f"    Invalid latitudes : {len(invalid_lat)}")
print(f"    Invalid longitudes: {len(invalid_lon)}")

# === Validate FK integrity
print("\n[17] Validating foreign key integrity...")
orphan_cust = fact_transactions[
    ~fact_transactions["customer_id"].isin(dim_customers["customer_id"])]
orphan_mer  = fact_transactions[
    ~fact_transactions["merchant_id"].isin(dim_merchants["merchant_id"])]
orphan_pay  = fact_transactions[
    ~fact_transactions["payment_type_id"].isin(dim_payment_types["payment_type_id"])]
orphan_loc  = fact_transactions[
    ~fact_transactions["location_id"].isin(dim_locations["location_id"])]
print(f"    Orphan customer_ids     : {len(orphan_cust)}")
print(f"    Orphan merchant_ids     : {len(orphan_mer)}")
print(f"    Orphan payment_type_ids : {len(orphan_pay)}")
print(f"    Orphan location_ids     : {len(orphan_loc)}")

# === Summary
print("\n" + "=" * 60)
print("CLEANING SUMMARY")
print("=" * 60)
print(f"fact_transactions : {len(fact_transactions):,} rows after cleaning")
print(f"dim_customers     : {len(dim_customers):,} rows after cleaning")
print(f"dim_merchants     : {len(dim_merchants):,} rows (no changes needed)")
print(f"dim_payment_types : {len(dim_payment_types):,} rows (no changes needed)")
print(f"dim_locations     : {len(dim_locations):,} rows (no changes needed)")
print(f"dim_dates         : {len(dim_dates):,} rows (no changes needed)")

# === Export
fact_transactions.to_csv("cleaned_fact_transactions.csv", index=False)
dim_customers.to_csv("cleaned_dim_customers.csv", index=False)
dim_merchants.to_csv("cleaned_dim_merchants.csv", index=False)
dim_payment_types.to_csv("cleaned_dim_payment_types.csv", index=False)
dim_locations.to_csv("cleaned_dim_locations.csv", index=False)
dim_dates.to_csv("cleaned_dim_dates.csv", index=False)
print("\nAll cleaned files exported successfully.")

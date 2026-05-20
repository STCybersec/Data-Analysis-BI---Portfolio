# ============================================================
# Project 5: Supply Chain Control Tower
# Data Cleaning Script
# Author: Sanele Siyabonga Thusi
# Tool: Python (Pandas)
# ============================================================

import pandas as pd
import numpy as np

print("=" * 60)
print("PROJECT 5 - Supply Chain Control Tower")
print("Data Cleaning Report")
print("=" * 60)

# === Load Data
fact_shipments = pd.read_csv("fact_shipments_sample.csv")
dim_warehouses = pd.read_csv("dim_warehouses.csv")
dim_suppliers  = pd.read_csv("dim_suppliers.csv")
dim_products   = pd.read_csv("dim_products.csv")
dim_carriers   = pd.read_csv("dim_carriers.csv")
dim_dates      = pd.read_csv("dim_dates.csv")

# === Profile
def profile(df, name):
    print(f"\n--- {name} ---")
    print(f"Shape        : {df.shape}")
    print(f"Duplicates   : {df.duplicated().sum()}")
    print(f"Null counts  :\n{df.isnull().sum()[df.isnull().sum() > 0]}")

profile(fact_shipments, "fact_shipments")
profile(dim_warehouses, "dim_warehouses")
profile(dim_carriers,   "dim_carriers")

# === Clean fact_shipments
print("\n[1] Removing duplicate shipment IDs...")
before = len(fact_shipments)
fact_shipments = fact_shipments.drop_duplicates(subset=["shipment_id"])
print(f"    Removed: {before - len(fact_shipments)} duplicates")

print("[2] Converting date columns to datetime...")
for col in ["ship_date", "expected_date", "actual_delivery"]:
    fact_shipments[col] = pd.to_datetime(fact_shipments[col], errors="coerce")

print("[3] Flagging delivered shipments with NULL actual_delivery...")
missing_del = fact_shipments[
    (fact_shipments["delivery_status"] == "Delivered") &
    (fact_shipments["actual_delivery"].isnull())
]
print(f"    Found: {len(missing_del)} Delivered with no actual_delivery date")

print("[4] Removing negative delay days...")
before = len(fact_shipments)
fact_shipments.loc[fact_shipments["delay_days"] < 0, "delay_days"] = 0
print(f"    Fixed: negative delay days set to 0")

print("[5] Removing negative shipping costs...")
before = len(fact_shipments)
fact_shipments = fact_shipments[fact_shipments["shipping_cost"] > 0]
print(f"    Removed: {before - len(fact_shipments)} invalid cost rows")

print("[6] Removing negative total values...")
before = len(fact_shipments)
fact_shipments = fact_shipments[fact_shipments["total_value"] > 0]
print(f"    Removed: {before - len(fact_shipments)} invalid value rows")

print("[7] Validating on_time_delivery flag (0 or 1 only)...")
invalid = fact_shipments[~fact_shipments["on_time_delivery"].isin([0, 1])]
fact_shipments = fact_shipments[fact_shipments["on_time_delivery"].isin([0, 1])]
print(f"    Removed: {len(invalid)} invalid on_time flags")

print("[8] Validating return_flag (0 or 1 only)...")
invalid = fact_shipments[~fact_shipments["return_flag"].isin([0, 1])]
fact_shipments = fact_shipments[fact_shipments["return_flag"].isin([0, 1])]
print(f"    Removed: {len(invalid)} invalid return flags")

print("[9] Validating delivery status values...")
valid_statuses = ["Delivered", "In Transit", "Delayed", "Failed"]
fact_shipments.loc[
    ~fact_shipments["delivery_status"].isin(valid_statuses),
    "delivery_status"] = "Unknown"

print("[10] Validating order status values...")
valid_order = ["Completed", "Processing", "Cancelled", "Returned"]
fact_shipments.loc[
    ~fact_shipments["order_status"].isin(valid_order),
    "order_status"] = "Unknown"

print("[11] Capping outlier shipping costs (above 99th percentile)...")
cap = fact_shipments["shipping_cost"].quantile(0.99)
outliers = (fact_shipments["shipping_cost"] > cap).sum()
fact_shipments["shipping_cost"] = fact_shipments["shipping_cost"].clip(upper=cap)
print(f"    Capped: {outliers} outlier shipping costs at {cap:.2f}")

print("[12] Validating transit days are positive...")
fact_shipments.loc[fact_shipments["days_in_transit"] <= 0, "days_in_transit"] = np.nan
print(f"    Fixed: non-positive transit days set to NULL")

# === Clean dim_warehouses
print("[13] Standardising country names...")
dim_warehouses["country"] = dim_warehouses["country"].str.strip().str.title()

print("[14] Validating latitude and longitude ranges...")
invalid_lat = dim_warehouses[
    (dim_warehouses["latitude"] < -90) | (dim_warehouses["latitude"] > 90)]
invalid_lon = dim_warehouses[
    (dim_warehouses["longitude"] < -180) | (dim_warehouses["longitude"] > 180)]
print(f"    Invalid latitudes : {len(invalid_lat)}")
print(f"    Invalid longitudes: {len(invalid_lon)}")

# === Validate FK integrity
print("\n[15] Validating foreign key integrity...")
orphan_wh  = fact_shipments[~fact_shipments["warehouse_id"].isin(dim_warehouses["warehouse_id"])]
orphan_sup = fact_shipments[~fact_shipments["supplier_id"].isin(dim_suppliers["supplier_id"])]
orphan_car = fact_shipments[~fact_shipments["carrier_id"].isin(dim_carriers["carrier_id"])]
print(f"    Orphan warehouse_ids : {len(orphan_wh)}")
print(f"    Orphan supplier_ids  : {len(orphan_sup)}")
print(f"    Orphan carrier_ids   : {len(orphan_car)}")

# === Summary
print("\n" + "=" * 60)
print("CLEANING SUMMARY")
print("=" * 60)
print(f"fact_shipments : {len(fact_shipments):,} rows after cleaning")
print(f"dim_warehouses : {len(dim_warehouses):,} rows after cleaning")
print(f"dim_suppliers  : {len(dim_suppliers):,} rows (no changes needed)")
print(f"dim_products   : {len(dim_products):,} rows (no changes needed)")
print(f"dim_carriers   : {len(dim_carriers):,} rows (no changes needed)")
print(f"dim_dates      : {len(dim_dates):,} rows (no changes needed)")

# === Export
fact_shipments.to_csv("cleaned_fact_shipments.csv", index=False)
dim_warehouses.to_csv("cleaned_dim_warehouses.csv", index=False)
dim_suppliers.to_csv("cleaned_dim_suppliers.csv", index=False)
dim_products.to_csv("cleaned_dim_products.csv", index=False)
dim_carriers.to_csv("cleaned_dim_carriers.csv", index=False)
dim_dates.to_csv("cleaned_dim_dates.csv", index=False)
print("\nAll cleaned files exported successfully.")

# ============================================================
# Project 4: Government Service Delivery Analytics
# Data Cleaning Script
# Author: Sanele Siyabonga Thusi
# Tool: Python (Pandas)
# ============================================================

import pandas as pd
import numpy as np

print("=" * 60)
print("PROJECT 4 - Government Service Delivery Analytics")
print("Data Cleaning Report")
print("=" * 60)

# === Load Data
fact_requests     = pd.read_csv("fact_service_requests.csv")
dim_citizens      = pd.read_csv("dim_citizens.csv")
dim_departments   = pd.read_csv("dim_departments.csv")
dim_municipalities= pd.read_csv("dim_municipalities.csv")
dim_request_types = pd.read_csv("dim_request_types.csv")
dim_dates         = pd.read_csv("dim_dates.csv")

# === Profile
def profile(df, name):
    print(f"\n--- {name} ---")
    print(f"Shape        : {df.shape}")
    print(f"Duplicates   : {df.duplicated().sum()}")
    print(f"Null counts  :\n{df.isnull().sum()[df.isnull().sum() > 0]}")

profile(fact_requests,      "fact_service_requests")
profile(dim_citizens,       "dim_citizens")
profile(dim_departments,    "dim_departments")
profile(dim_municipalities, "dim_municipalities")

# === Clean fact_service_requests
print("\n[1] Removing duplicate request IDs...")
before = len(fact_requests)
fact_requests = fact_requests.drop_duplicates(subset=["request_id"])
print(f"    Removed: {before - len(fact_requests)} duplicates")

print("[2] Converting date columns to datetime...")
fact_requests["date_submitted"] = pd.to_datetime(
    fact_requests["date_submitted"], errors="coerce")
fact_requests["date_resolved"] = pd.to_datetime(
    fact_requests["date_resolved"], errors="coerce")

print("[3] Flagging resolved requests with NULL resolution date...")
missing_res = fact_requests[
    (fact_requests["status"].isin(["Resolved", "Closed"])) &
    (fact_requests["date_resolved"].isnull())
]
print(f"    Found: {len(missing_res)} Resolved/Closed with no resolution date")

print("[4] Flagging negative resolution days...")
neg_days = fact_requests[
    fact_requests["resolution_days"].notna() &
    (fact_requests["resolution_days"] < 0)
]
fact_requests.loc[
    fact_requests["resolution_days"] < 0, "resolution_days"] = np.nan
print(f"    Fixed: {len(neg_days)} negative resolution days set to NULL")

print("[5] Removing negative budget values...")
before = len(fact_requests)
fact_requests = fact_requests[fact_requests["budget_allocated"] > 0]
print(f"    Removed: {before - len(fact_requests)} invalid budget rows")

print("[6] Validating SLA met flag (0 or 1 only)...")
invalid = fact_requests[~fact_requests["sla_met"].isin([0, 1])]
fact_requests = fact_requests[fact_requests["sla_met"].isin([0, 1])]
print(f"    Removed: {len(invalid)} invalid sla_met flags")

print("[7] Validating priority values...")
valid_priorities = ["Critical", "High", "Medium", "Low"]
fact_requests.loc[
    ~fact_requests["priority"].isin(valid_priorities), "priority"] = "Unknown"

print("[8] Validating status values...")
valid_statuses = ["Resolved", "Open", "Escalated", "Closed"]
fact_requests.loc[
    ~fact_requests["status"].isin(valid_statuses), "status"] = "Unknown"

print("[9] Validating satisfaction scores (1-5, 0 for unresolved)...")
invalid_sat = fact_requests[
    ~fact_requests["satisfaction_score"].isin([0,1,2,3,4,5])]
fact_requests.loc[
    ~fact_requests["satisfaction_score"].isin([0,1,2,3,4,5]),
    "satisfaction_score"] = 0
print(f"    Fixed: {len(invalid_sat)} invalid satisfaction scores")

# === Clean dim_citizens
print("[10] Standardising province and city names...")
dim_citizens["province"] = dim_citizens["province"].str.strip().str.title()
dim_citizens["city"]     = dim_citizens["city"].str.strip().str.title()

print("[11] Removing invalid ages...")
before = len(dim_citizens)
dim_citizens = dim_citizens[
    (dim_citizens["age"] >= 18) & (dim_citizens["age"] <= 100)]
print(f"    Removed: {before - len(dim_citizens)} invalid ages")

# === Clean dim_municipalities
print("[12] Standardising municipality names...")
dim_municipalities["municipality_name"] = \
    dim_municipalities["municipality_name"].str.strip().str.title()
dim_municipalities["province"] = \
    dim_municipalities["province"].str.strip().str.title()

# === Validate FK integrity
print("\n[13] Validating foreign key integrity...")
orphan_cit  = fact_requests[~fact_requests["citizen_id"].isin(dim_citizens["citizen_id"])]
orphan_dep  = fact_requests[~fact_requests["department_id"].isin(dim_departments["department_id"])]
orphan_mun  = fact_requests[~fact_requests["municipality_id"].isin(dim_municipalities["municipality_id"])]
orphan_req  = fact_requests[~fact_requests["request_type_id"].isin(dim_request_types["request_type_id"])]
print(f"    Orphan citizen_ids       : {len(orphan_cit)}")
print(f"    Orphan department_ids    : {len(orphan_dep)}")
print(f"    Orphan municipality_ids  : {len(orphan_mun)}")
print(f"    Orphan request_type_ids  : {len(orphan_req)}")

# === Summary
print("\n" + "=" * 60)
print("CLEANING SUMMARY")
print("=" * 60)
print(f"fact_service_requests : {len(fact_requests):,} rows after cleaning")
print(f"dim_citizens          : {len(dim_citizens):,} rows after cleaning")
print(f"dim_departments       : {len(dim_departments):,} rows (no changes needed)")
print(f"dim_municipalities    : {len(dim_municipalities):,} rows after cleaning")
print(f"dim_request_types     : {len(dim_request_types):,} rows (no changes needed)")
print(f"dim_dates             : {len(dim_dates):,} rows (no changes needed)")

# === Export
fact_requests.to_csv("cleaned_fact_service_requests.csv", index=False)
dim_citizens.to_csv("cleaned_dim_citizens.csv", index=False)
dim_departments.to_csv("cleaned_dim_departments.csv", index=False)
dim_municipalities.to_csv("cleaned_dim_municipalities.csv", index=False)
dim_request_types.to_csv("cleaned_dim_request_types.csv", index=False)
dim_dates.to_csv("cleaned_dim_dates.csv", index=False)
print("\nAll cleaned files exported successfully.")

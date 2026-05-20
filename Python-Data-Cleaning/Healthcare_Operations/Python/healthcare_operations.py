# ============================================================
# Project 3: Healthcare Operations Dashboard
# Data Cleaning Script
# Author: Sanele Siyabonga Thusi
# Tool: Python (Pandas)
# ============================================================

import pandas as pd
import numpy as np

print("=" * 60)
print("PROJECT 3 — Healthcare Operations Dashboard")
print("Data Cleaning Report")
print("=" * 60)

# === Load Data
fact_admissions  = pd.read_csv("fact_admissions.csv")
dim_patients     = pd.read_csv("dim_patients.csv")
dim_doctors      = pd.read_csv("dim_doctors.csv")
dim_departments  = pd.read_csv("dim_departments.csv")
dim_diagnoses    = pd.read_csv("dim_diagnoses.csv")
dim_dates        = pd.read_csv("dim_dates.csv")

# === Profile
def profile(df, name):
    print(f"\n--- {name} ---")
    print(f"Shape        : {df.shape}")
    print(f"Duplicates   : {df.duplicated().sum()}")
    print(f"Null counts  :\n{df.isnull().sum()[df.isnull().sum() > 0]}")

profile(fact_admissions, "fact_admissions")
profile(dim_patients,    "dim_patients")
profile(dim_doctors,     "dim_doctors")
profile(dim_departments, "dim_departments")
profile(dim_diagnoses,   "dim_diagnoses")

# === Clean fact_admissions
print("\n[1] Removing duplicate admission IDs...")
before = len(fact_admissions)
fact_admissions = fact_admissions.drop_duplicates(subset=["admission_id"])
print(f"    Removed: {before - len(fact_admissions)} duplicates")

print("[2] Converting discharge_date to datetime...")
fact_admissions["discharge_date"] = pd.to_datetime(
    fact_admissions["discharge_date"], errors="coerce")

print("[3] Flagging NULL discharge dates for non-admitted patients...")
null_discharge = fact_admissions[
    (fact_admissions["status"] != "Admitted") &
    (fact_admissions["discharge_date"].isnull())
]
print(f"    Found: {len(null_discharge)} missing discharge dates for non-Admitted records")

print("[4] Removing negative length of stay...")
before = len(fact_admissions)
fact_admissions = fact_admissions[fact_admissions["length_of_stay"] >= 0]
print(f"    Removed: {before - len(fact_admissions)} invalid LOS values")

print("[5] Capping outlier LOS (above 99th percentile)...")
cap = fact_admissions["length_of_stay"].quantile(0.99)
outliers = (fact_admissions["length_of_stay"] > cap).sum()
fact_admissions["length_of_stay"] = fact_admissions["length_of_stay"].clip(upper=cap)
print(f"    Capped: {outliers} outlier LOS values at {cap:.0f} days")

print("[6] Removing negative wait times...")
before = len(fact_admissions)
fact_admissions = fact_admissions[fact_admissions["wait_time_hours"] >= 0]
print(f"    Removed: {before - len(fact_admissions)} invalid wait times")

print("[7] Validating readmission flag (0 or 1 only)...")
invalid = fact_admissions[~fact_admissions["readmission"].isin([0, 1])]
fact_admissions = fact_admissions[fact_admissions["readmission"].isin([0, 1])]
print(f"    Removed: {len(invalid)} invalid readmission flags")

print("[8] Validating patient status values...")
valid_statuses = ["Discharged", "Admitted", "Deceased"]
fact_admissions.loc[
    ~fact_admissions["status"].isin(valid_statuses), "status"] = "Unknown"
print(f"    Standardised invalid status values to Unknown")

# === Clean dim_patients
print("[9] Removing invalid patient ages (below 0 or above 120)...")
before = len(dim_patients)
dim_patients = dim_patients[
    (dim_patients["age"] >= 0) & (dim_patients["age"] <= 120)]
print(f"    Removed: {before - len(dim_patients)} invalid ages")

print("[10] Validating age groups match actual age...")
def expected_age_group(age):
    if age <= 12:   return "Child"
    elif age <= 17: return "Adolescent"
    elif age <= 35: return "Young Adult"
    elif age <= 55: return "Middle Aged"
    elif age <= 75: return "Senior"
    else:           return "Elderly"

dim_patients["age_group_check"] = dim_patients["age"].apply(expected_age_group)
mismatches = (dim_patients["age_group"] != dim_patients["age_group_check"]).sum()
dim_patients["age_group"] = dim_patients["age_group_check"]
dim_patients = dim_patients.drop(columns=["age_group_check"])
print(f"    Corrected: {mismatches} age group mismatches")

print("[11] Standardising province names...")
dim_patients["province"] = dim_patients["province"].str.strip().str.title()

print("[12] Validating medical_aid values...")
dim_patients["medical_aid"] = dim_patients["medical_aid"].str.strip().str.title()
invalid_med = ~dim_patients["medical_aid"].isin(["Yes", "No"])
dim_patients.loc[invalid_med, "medical_aid"] = "Unknown"
print(f"    Fixed: {invalid_med.sum()} invalid medical_aid values")

# === Validate FK integrity
print("\n[13] Validating foreign key integrity...")
orphan_pat  = fact_admissions[~fact_admissions["patient_id"].isin(dim_patients["patient_id"])]
orphan_doc  = fact_admissions[~fact_admissions["doctor_id"].isin(dim_doctors["doctor_id"])]
orphan_dep  = fact_admissions[~fact_admissions["department_id"].isin(dim_departments["department_id"])]
orphan_diag = fact_admissions[~fact_admissions["diagnosis_id"].isin(dim_diagnoses["diagnosis_id"])]
print(f"    Orphan patient_ids    : {len(orphan_pat)}")
print(f"    Orphan doctor_ids     : {len(orphan_doc)}")
print(f"    Orphan department_ids : {len(orphan_dep)}")
print(f"    Orphan diagnosis_ids  : {len(orphan_diag)}")

# === Summary
print("\n" + "=" * 60)
print("CLEANING SUMMARY")
print("=" * 60)
print(f"fact_admissions : {len(fact_admissions):,} rows after cleaning")
print(f"dim_patients    : {len(dim_patients):,} rows after cleaning")
print(f"dim_doctors     : {len(dim_doctors):,} rows (no changes needed)")
print(f"dim_departments : {len(dim_departments):,} rows (no changes needed)")
print(f"dim_diagnoses   : {len(dim_diagnoses):,} rows (no changes needed)")
print(f"dim_dates       : {len(dim_dates):,} rows (no changes needed)")

# === Export
fact_admissions.to_csv("cleaned_fact_admissions.csv", index=False)
dim_patients.to_csv("cleaned_dim_patients.csv", index=False)
dim_doctors.to_csv("cleaned_dim_doctors.csv", index=False)
dim_departments.to_csv("cleaned_dim_departments.csv", index=False)
dim_diagnoses.to_csv("cleaned_dim_diagnoses.csv", index=False)
dim_dates.to_csv("cleaned_dim_dates.csv", index=False)
print("\nAll cleaned files exported successfully.")

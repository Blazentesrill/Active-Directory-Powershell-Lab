# Active-Directory-Powershell-Lab
A set of PowerShell scripts for automating Active Directory administration tasks — including group creation, bulk user provisioning from a CSV, selective account enabling, and group membership assignment. Built as part of a systems administration course lab.
 
---
 
## Overview
 
These scripts simulate a real-world AD onboarding workflow:
1. Create security groups for each department
2. Verify the groups were created
3. Bulk-create user accounts from a CSV file
4. Enable only even-numbered accounts (e.g. IT2, IT4, HR2...)
5. Add enabled accounts to their corresponding department group
---
 
## Prerequisites
 
- Windows Server with **Active Directory Domain Services (AD DS)** installed
- PowerShell with the **ActiveDirectory** module (`Import-Module ActiveDirectory`)
- A network share mapped to `Z:\` containing `accounts.csv`
- Sufficient permissions to create users and groups in AD
---
 
## Scripts
 
### `AD-LabQ1.ps1` — Create Department Groups
 
Creates five security groups using an array and a loop:
 
```
IT, HR, Executive, OPS, Billing
```
 
Each group is created as a **Global Security** group via `New-ADGroup`.
 
---
 
### `AD-LabQ2.ps1` — List Newly Created Groups
 
Filters all AD groups and displays only the ones matching the five department names created in Q1. Uses `Get-ADGroup` with a `Where-Object` filter.
 
---
 
### `AD-LabQ3.ps1` — Bulk Create AD User Accounts from CSV
 
Reads `accounts.csv` from the shared drive, sorts by first and last name columns, and creates an AD user account for each row.
 
Features:
- Skips rows with missing/blank data
- Skips accounts that already exist (idempotent)
- Sets a default password (`Password123!`) with accounts **disabled** by default
- Derives UPN from the domain root automatically
---
 
### `AD-LabQ4.ps1` — Enable Even-Numbered Accounts
 
Reads the CSV and enables only accounts whose trailing number is even (e.g. `IT2`, `IT4`, `HR6`).
 
Logic:
- Extracts the trailing number from the `SamAccountName` using regex
- Skips odd-numbered and non-numeric accounts
- Uses `Enable-ADAccount` with error handling
---
 
### `AD-LabQ5.ps1` — Add Enabled Accounts to Department Groups
 
Reads the CSV, filters for even-numbered accounts, verifies the account is enabled in AD, then adds it to the matching department group based on the account name prefix.
 
Group matching:
| Account Prefix | Group |
|---|---|
| `IT*` | IT |
| `HR*` | HR |
| `EXECUTIVE*` | Executive |
| `OPS*` | OPS |
| `BILLING*` | Billing |
 
---
 
## CSV Format
 
The `accounts.csv` file should follow this structure:
 
| Column | Description |
|---|---|
| `IT1` | SamAccountName / First Name (e.g. `IT2`, `HR5`) |
| `Account1` | Last Name / display surname |
 
---
 
## Skills Demonstrated
 
- PowerShell scripting for AD automation
- `New-ADGroup`, `New-ADUser`, `Enable-ADAccount`, `Add-ADGroupMember`
- CSV import and sorting with `Import-Csv` + `Sort-Object`
- Regex pattern matching for conditional logic
- Idempotent scripting (skip-if-exists checks)
- Error handling with `try/catch` and `-ErrorAction SilentlyContinue`
---
 
## Files
 
| File | Description |
|---|---|
| `AD-LabQ1.ps1` | Create IT, HR, Executive, OPS, Billing groups |
| `AD-LabQ2.ps1` | List and verify created groups |
| `AD-LabQ3.ps1` | Bulk create AD users from CSV |
| `AD-LabQ4.ps1` | Enable even-numbered accounts |
| `AD-LabQ5.ps1` | Add enabled accounts to department groups |
 

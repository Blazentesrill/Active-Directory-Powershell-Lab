Import-Module ActiveDirectory
$csvPath = "Z:\accounts.csv"
#I used a shared folder
$accounts = Import-Csv $csvPath
foreach ($acct in $accounts) {
    $first = $acct.IT1   # e.g. IT2, HR5, OPS10
    $last  = $acct.Account1
    $sam   = $first      # same as we used in Script 3
    if ([string]::IsNullOrWhiteSpace($sam)) { continue }
    if ($sam -match '(\d+)$') {
        $num = [int]$Matches[1]
        if ($num % 2 -ne 0) {
            Write-Host "Skipping odd-numbered account: $sam"
            continue
        }
    } else {
        Write-Host "No trailing number for $sam - skipping"
        continue
    }
    $user = Get-ADUser -Identity $sam -Properties Enabled -ErrorAction SilentlyContinue
    if (-not $user) {
        Write-Warning "User $sam not found in AD"
        continue
    }
    if (-not $user.Enabled) {
        Write-Host "User $sam is not enabled - skipping group membership"
        continue
    }
    $upperFirst = $first.ToUpper()
    if ($upperFirst -like "IT*") {
        Add-ADGroupMember -Identity "IT" -Members $sam
        Write-Host "Added $sam to IT"
    }
    elseif ($upperFirst -like "HR*") {
        Add-ADGroupMember -Identity "HR" -Members $sam
        Write-Host "Added $sam to HR"
    }
    elseif ($upperFirst -like "EXECUTIVE*") {
        Add-ADGroupMember -Identity "Executive" -Members $sam
        Write-Host "Added $sam to Executive"
    }
    elseif ($upperFirst -like "OPS*") {
        Add-ADGroupMember -Identity "OPS" -Members $sam
        Write-Host "Added $sam to OPS"
    }
    elseif ($upperFirst -like "BILLING*") {
        Add-ADGroupMember -Identity "Billing" -Members $sam
        Write-Host "Added $sam to Billing"
    }
    else {
        Write-Host "No matching group for $sam (first name: $first)"
    }
}
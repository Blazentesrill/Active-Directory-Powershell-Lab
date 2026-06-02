Import-Module ActiveDirectory
$csvPath = "Z:\accounts.csv"
#shared folder
$accounts = Import-Csv $csvPath | Sort-Object IT1, Account1
$domain = (Get-ADDomain).DNSRoot

foreach ($acct in $accounts) {
    $first = $acct.IT1
    $last  = $acct.Account1
    $sam   = $first
    $name  = "$first $last"
    $upn   = "$sam@$domain"
    if ([string]::IsNullOrWhiteSpace($sam) -or
        [string]::IsNullOrWhiteSpace($first) -or
        [string]::IsNullOrWhiteSpace($last)) {

        Write-Warning "Skipping a row with missing data. Raw row: $($acct | Out-String)"
        continue
    }
    $existing = Get-ADUser -Filter "SamAccountName -eq '$sam'" -ErrorAction SilentlyContinue
    if ($existing) {
        Write-Host "User $sam already exists. Skipping."
        continue
    }
    New-ADUser `
        -Name $name `
        -GivenName $first `
        -Surname $last `
        -SamAccountName $sam `
        -UserPrincipalName $upn `
        -AccountPassword (ConvertTo-SecureString "Password123!" -AsPlainText -Force) `
        -Enabled $false
    Write-Host "Created user: $sam ($name)"
}

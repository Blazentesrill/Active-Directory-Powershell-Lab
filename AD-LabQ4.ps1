Import-Module ActiveDirectory
$csvPath = "Z:\accounts.csv"
#used a shared file
$accounts = Import-Csv $csvPath
foreach ($acct in $accounts) {
    $sam = $acct.IT1
    if ([string]::IsNullOrWhiteSpace($sam)) { continue }
    if ($sam -match '(\d+)$') {
        $num = [int]$Matches[1]
        if ($num % 2 -eq 0) {
            try {
                Enable-ADAccount -Identity $sam
                Write-Host "Enabled account: $sam (number $num)"
            } catch {
                Write-Warning "Failed to enable $sam : $_"
            }
        } else {
            Write-Host "Skipping odd account: $sam (number $num)"
        }
    } else {
        Write-Host "No trailing number found in $sam - skipping"
    }
}

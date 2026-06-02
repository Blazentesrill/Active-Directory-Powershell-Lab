$groups = @("IT", "HR", "Executive", "OPS", "Billing")
foreach ($g in $groups) {
    New-ADGroup -Name $g -GroupScope Global -GroupCategory Security
    Write-Host "Created group: $g"
}
$groups = @("IT", "HR", "Executive", "OPS", "Billing")
Get-ADGroup -Filter * | Where-Object { $groups -contains $_.Name } | Format-Table Name

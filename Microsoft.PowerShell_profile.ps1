Import-Module PSFzf # run "Install-Module -Name PSFzf -Scope CurrentUser" before first use, after choco install fzf

Set-PSReadLineKeyHandler -Chord "Ctrl+r" -ScriptBlock { Invoke-FuzzyHistory }
Set-Alias -Name npp -Value "C:\Program Files\Notepad++\notepad++.exe" 

function Get-DiskHuman {
    Get-Disk | Select-Object Number, FriendlyName, SerialNumber,
        @{Name="Size(GB)"; Expression={"{0:N2}" -f ($_.Size / 1GB)}}
}

function Get-PartitionHuman {
    Get-Partition | Select-Object DiskNumber, PartitionNumber, DriveLetter,
        @{Name="Size(GB)"; Expression={"{0:N2}" -f ($_.Size / 1GB)}},
        Type
}

function Get-VolumeHuman {
    Get-Volume | Select-Object DriveLetter, FileSystemLabel, FileSystem,
        @{Name="Used(GB)"; Expression={"{0:N2}" -f (($_.Size - $_.SizeRemaining) / 1GB)}},
        @{Name="Free(GB)"; Expression={"{0:N2}" -f ($_.SizeRemaining / 1GB)}},
        @{Name="Total(GB)"; Expression={"{0:N2}" -f ($_.Size / 1GB)}}
}

function lsblk {
    $disks = Get-Disk | Sort-Object Number
    $partitions = Get-Partition
    $volumes = Get-Volume

    foreach ($disk in $disks) {
        $diskNum = $disk.Number
        $diskName = $disk.FriendlyName
        $diskSize = "{0:N2} GB" -f ($disk.Size / 1GB)
        Write-Host "Disk $diskNum - $diskName ($diskSize)" -ForegroundColor Cyan

        $diskParts = $partitions | Where-Object { $_.DiskNumber -eq $diskNum } | Sort-Object PartitionNumber

        foreach ($part in $diskParts) {
            $partNum = $part.PartitionNumber
            $drive = if ($part.DriveLetter) { "$($part.DriveLetter):" } else { "-" }
            $size = "{0:N2} GB" -f ($part.Size / 1GB)
            $type = $part.Type
            $volLabel = ($volumes | Where-Object { $_.DriveLetter -eq $part.DriveLetter }).FileSystemLabel

            $labelDisplay = if ($volLabel) { " [$volLabel]" } else { "" }

            Write-Host " └─ Partition $partNum ($drive, $type, $size)$labelDisplay" -ForegroundColor Gray
        }

        Write-Host ""
    }
}

function fuzzdir {
    <#
    .SYNOPSIS
        Uses fzf to select a directory path and copies it to clipboard.

    .DESCRIPTION
        Recursively lists all directories, lets you choose one via fzf, and copies the full path to the clipboard.

    .EXAMPLE
        Copy-DirPathFromFzf
    #>
    $selected = Get-ChildItem -Directory -Recurse | Select-Object -ExpandProperty FullName | fzf
    if ($selected) {
        $selected | Set-Clipboard
        Write-Host "Copied to clipboard:" -ForegroundColor Green
        Write-Host $selected
    }
}

function fuzzexe {
    $exe = Get-CimInstance Win32_Process |
        Where-Object ExecutablePath |
        ForEach-Object ExecutablePath |
        fzf |
        ForEach-Object { Split-Path $_ -Leaf }

    if ($exe) {
        Set-Clipboard -Value $exe
        Write-Host "Copied to clipboard: $exe"
    } else {
        Write-Host "No selection made."
    }
}


function lg {
    git log --graph --date=relative --abbrev-commit --pretty=format:"`e[31m%h`e[0m -`e[33m%d`e[0m `e[1;34m%an`e[0m - `e[37m%s`e[0m `e[32m(%cr)`e[0m `e[36m%G?`e[0m"
}

function sniff {
    param(
        [string]$name,
        [string]$path = "."
    )
    if ($path -match "^[a-zA-Z]:$") { $path += "\" }
    Get-ChildItem -Path $path -Recurse -Directory | Where-Object { $_.Name -like "*$name*" }
}

function snuff {
    param(
        [string]$name,
        [string]$path = "."
    )
    if ($path -match "^[a-zA-Z]:$") { $path += "\" }
    Get-ChildItem -Path $path -Recurse -File | Where-Object { $_.Name -like "*$name*" }
}

$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}


function myip {
    (Invoke-RestMethod -Uri 'https://ipinfo.io/ip').Trim()
}

function localip {
    (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {
        $_.IPAddress -notlike '169.*' -and $_.IPAddress -ne '127.0.0.1'
    }).IPAddress
}

function localipmore {
    Get-NetIPAddress -AddressFamily IPv4 | Where-Object {
        $_.IPAddress -notlike '169.*' -and $_.IPAddress -ne '127.0.0.1'
    } | Select-Object InterfaceAlias, IPAddress
}

Invoke-Expression (& { (zoxide init powershell | Out-String) }) # after doing choco install zoxide

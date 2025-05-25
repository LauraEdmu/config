Import-Module PSFzf # run "Install-Module -Name PSFzf -Scope CurrentUser" before first use, after choco install fzf

Set-PSReadLineKeyHandler -Chord "Ctrl+r" -ScriptBlock { Invoke-FuzzyHistory }

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


# Convenience
alias v="nvim"
alias bashrc="nvim ~/.bashrc && source ~/.bashrc"
alias upgrate="sudo apt update && sudo apt upgrade"
alias ..="cd .."
alias list="ls -lh"
alias nvInit="nvim ~/.config/nvim/init.lua"
alias home="cd ~"
alias pfind="ps aux | grep "
alias :q="clear"
alias kern="uname -a"
alias aptfix="sudo apt --fix-broken install"
alias aptdeps="sudo apt-get install -f"

# Windows Alias
alias del="rm"
alias copy="cp"
alias move="mv"
alias del="rm"
alias cls="clear"

# Network
alias myip="curl ipinfo.io/ip"
alias ports="netstat -tulanp"
alias ipinfo="ip -c a"
alias nmapGateway="nmap -A 192.168.0.1"
alias nmapPing="nmap -sn 192.168.0.0/24"
alias nmapQuick="nmap -F"
alias nampPorts="namp -p-"
alias nmapAgressive="nmap -A"
alias nmapOS="nmap -O"
alias speed="speedtest-cli"
alias trace="traceroute"
alias nmapStealth="sudo nmap -sS"
alias download='aria2c -x 16 -s 16 -k 1M --auto-file-renaming=false --summary-interval=0 --continue=true --retry-wait=5 --max-tries=3'
alias dad="curl -H 'Accept: text/plain' https://icanhazdadjoke.com/; echo"
alias interfaces="ip link show"

sendip() {
    local ip=$(curl -s ipinfo.io/ip)
    curl -X POST -H 'Content-Type: application/json' -d "{\"content\": \"$ip\"}" "https://discord.com/api/webhooks/1280596126021718088/sNHMBgBwzXW7KquG6_q89pQMY1UTp5AeSGvIxolzyWhKxnlPCOWgEuFkNCVUE_6RTEHo"
}

# System
alias off="sudo shutdown now"
alias firmware="systemctl reboot --firmware-setup"
alias bat="acpi -a -b -t"

# Git
alias lg="git log --graph --date=relative --abbrev-commit --pretty=format:'%C(red)%h%Creset -%C(yellow)%d%Creset %C(bold blue)%an%Creset - %C(white)%s%Creset %C(green)(%cr)%Creset %C(cyan)%G?%Creset'"
alias lgSign="git log --graph --date=relative --abbrev-commit --pretty=format:'%C(red)%h%Creset -%C(yellow)%d%Creset %C(bold blue)%an%Creset - %C(white)%s%Creset %C(green)(%cr)%Creset %C(cyan)   { %G?%Creset %C(bold magenta)%GS%Creset %C(bold cyan)[%GK]%C(cyan) }%Creset'"
alias gd="git diff --color | diff-so-fancy"
alias pull="git pull"

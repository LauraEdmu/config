# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/bin:$PATH"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
ZSH_THEME="agnoster"

# Vim Mode
# bindkey -v
# export KEYTIMEOUT=1
# bindkey '^[^[[C' expand-or-complete-prefix

# Conveniance
alias v="nvim"
alias zshrc="nvim ~/.zshrc && source ~/.zshrc"
alias upgrate="sudo apt update && sudo apt upgrade"
alias ..="cd .."
alias list="ls -lh"
alias nvInit="nvim ~/.config/nvim/init.lua"
alias home="cd ~"
alias pfind="ps aux | grep "
alias :q="clear"

# Windows Alias
alias del="rm"
alias copy="cp"
alias move="mv"
alias del="rm"
alias cls="clear"

# Network
alias myip="curl ipinfo.io/ip"
alias myipmore="curl -H 'X-Api-Key: REDACTED' https://api.api-ninjas.com/v1/iplookup\?address=$(curl -s ipinfo.io/ip)"
# alias sendip="curl -X POST -H 'Content-Type: application/json' -d '{\"content\": $(curl ipinfo.io/ip)}' https://discord.com/api/webhooks/1280596126021718088/sNHMBgBwzXW7KquG6_q89pQMY1UTp5AeSGvIxolzyWhKxnlPCOWgEuFkNCVUE_6RTEHo" 
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

sendip() {
    local ip=$(curl -s ipinfo.io/ip)
    curl -X POST -H 'Content-Type: application/json' -d "{\"content\": \"$ip\"}" "https://discord.com/api/webhooks/1280596126021718088/sNHMBgBwzXW7KquG6_q89pQMY1UTp5AeSGvIxolzyWhKxnlPCOWgEuFkNCVUE_6RTEHo"
}

# System
alias off="sudo shutdown now"
alias firmware="systemctl reboot --firmware-setup"
alias bat_old="upower -i $(upower -e | grep 'BAT') | grep -E 'percentage'"
alias bat="acpi -a -b -t"

# Git
# alias lg="git log --graph --date=relative --abbrev-commit --pretty=format:'%Cred%h%Creset - %C(yellow)%d%Creset %s%Cgreen(%cr)%creset'"
alias lg="git log --graph --date=relative --abbrev-commit --pretty=format:'%C(red)%h%Creset -%C(yellow)%d%Creset %C(bold blue)%an%Creset - %C(white)%s%Creset %C(green)(%cr)%Creset %C(cyan)%G?%Creset'"
alias lgSign="git log --graph --date=relative --abbrev-commit --pretty=format:'%C(red)%h%Creset -%C(yellow)%d%Creset %C(bold blue)%an%Creset - %C(white)%s%Creset %C(green)(%cr)%Creset %C(cyan)   { %G?%Creset %C(bold magenta)%GS%Creset %C(bold cyan)[%GK]%C(cyan) }%Creset'"
alias gd="git diff --color | diff-so-fancy"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions zsh-z fzf)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

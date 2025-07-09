# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export PATH="$HOME/bin:$PATH"
export VISUAL=nvim
export EDITOR=nvim
export PATH="$HOME/.cargo/bin:$PATH" # make rust cargo bins accessible

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
ZSH_THEME="agnoster"

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
alias kern="uname -a"
alias aptfix="sudo apt --fix-broken install"
alias aptdeps="sudo apt-get install -f"
alias nvimsudo="EDITOR=nvim visudo"
alias lsfuzz="ls | fzf --preview='bat --style=numbers --color=always {}'"

# Windows Alias
alias del="rm"
alias copy="cp"
alias move="mv"
alias del="rm"
alias cls="clear"

# Network
alias myip="curl ipinfo.io/ip"
alias myipmore="curl -H 'X-Api-Key: ' https://api.api-ninjas.com/v1/iplookup\?address=$(curl -s ipinfo.io/ip)"
# alias sendip="curl -X POST -H 'Content-Type: application/json' -d '{\"content\": $(curl ipinfo.io/ip)}' https://discord.com/api/webhooks/1280596126021718088/sNHMBgBwzXW7KquG6_q89pQMY1UTp5AeSGvIxolzyWhKxnlPCOWgEuFkNCVUE_6RTEHo" 
alias localip="ip -4 addr show scope global | grep -oP '(?<=inet\s)\d+(\.\d+){3}'"
alias localipmore="ip -4 -o addr show scope global | awk '{print \$2, \$4}' | cut -d/ -f1"
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

# Media
play() {
  local search_term="$1"
  local selected
  selected="$(fd -i "$search_term" I:/media/ | fzf)"
  [[ -n "$selected" ]] && vlc "$selected"
}

playmediafrom() {
  local search_term="$1"
  local root_dir="${2:-I:/media/}"
  local selected
  selected="$(fd -i "$search_term" "$root_dir" | fzf)"
  [[ -n "$selected" ]] && vlc "$selected"
}

playhere() {
  local search_term="$1"
  local selected
  selected="$(fd -i "$search_term" . | fzf)"
  [[ -n "$selected" ]] && vlc "$selected"
}

# Setup
alias get_rust="curl https://sh.rustup.rs -sSf | sh"

update_zshrc() {
  mv ~/.zshrc ~/.zshrc.backup
  if xh -o ~/.zshrc -F laura.to/zshrc; then
    echo "✅ .zshrc updated successfully. Sourcing..."
    source ~/.zshrc
  else
    echo "❌ Failed to fetch new .zshrc. Restoring backup..."
    mv ~/.zshrc.backup ~/.zshrc
  fi
}

sendip() {
    local ip=$(curl -s ipinfo.io/ip)
    curl -X POST -H 'Content-Type: application/json' -d "{\"content\": \"$ip\"}" "https://discord.com/api/webhooks/1280596126021718088/sNHMBgBwzXW7KquG6_q89pQMY1UTp5AeSGvIxolzyWhKxnlPCOWgEuFkNCVUE_6RTEHo"
}

fuzzdir() {
  local selected
  selected=$(find . -type d 2>/dev/null | fzf)

  if [[ -n "$selected" ]]; then
    if command -v xclip &>/dev/null; then
      printf '%s' "$selected" | xclip -selection clipboard
      echo "Copied to clipboard: $selected"
    elif command -v pbcopy &>/dev/null; then
      printf '%s' "$selected" | pbcopy
      echo "Copied to clipboard: $selected"
    else
      echo "No clipboard tool found (need xclip or pbcopy)"
    fi
  fi
}

fuzzexe() {
  local selected exe

  selected=$(ps -eo args= | grep '/' | fzf)

  if [[ -n "$selected" ]]; then
    exe=$(echo "$selected" | awk '{print $1}' | sed 's/.*\///')
    echo "$exe"
  else
    echo "No selection made."
  fi
}

# System
alias off="sudo shutdown now"
alias firmware="systemctl reboot --firmware-setup"
# alias bat_old="upower -i $(upower -e | grep 'BAT') | grep -E 'percentage'"
alias batt="acpi -a -b -t"
alias cat="bat"

# Git
# alias lg="git log --graph --date=relative --abbrev-commit --pretty=format:'%Cred%h%Creset - %C(yellow)%d%Creset %s%Cgreen(%cr)%creset'"
alias lg="git log --graph --date=relative --abbrev-commit --pretty=format:'%C(red)%h%Creset -%C(yellow)%d%Creset %C(bold blue)%an%Creset - %C(white)%s%Creset %C(green)(%cr)%Creset %C(cyan)%G?%Creset'"
alias lgSign="git log --graph --date=relative --abbrev-commit --pretty=format:'%C(red)%h%Creset -%C(yellow)%d%Creset %C(bold blue)%an%Creset - %C(white)%s%Creset %C(green)(%cr)%Creset %C(cyan)   { %G?%Creset %C(bold magenta)%GS%Creset %C(bold cyan)[%GK]%C(cyan) }%Creset'"
alias gd="git diff --color | diff-so-fancy"
alias pull="git pull"

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

# Alternative fzf cd widget that includes hidden dirs
fzf_cd_hidden() {
  local dir
  dir=$(command find . -type d 2> /dev/null | sed "s|^\./||" | fzf +m) && cd "$dir"
}
zle -N fzf_cd_hidden
bindkey '^[d' fzf_cd_hidden  # Alt-d

lhelp() {
  local helpfile="$HOME/.zsh_help"

  if [[ -f "$helpfile" ]]; then
    less -R "$helpfile"        # -R keeps ANSI colours, if you add any
  else
    printf "%s\n" "⛔  No .zsh_help found in \$HOME – create one with your key-binds, aliases and functions."
  fi
}

unalias z 2>/dev/null # remove z alias of other plugin
eval "$(zoxide init zsh)" # use this after apt install zoxide

# Vim Mode
bindkey -v
export KEYTIMEOUT=1

# navigate interactive menus with vim
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'left' vi-backward-char
bindkey -M menuselect 'down' vi-down-line-or-history
bindkey -M menuselect 'up' vi-up-line-or-history
bindkey -M menuselect 'right' vi-forward-char
# fix bug with backspace
bindkey "^?" backward-delete-char

# Vim cursor
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'  # block cursor
  else
    echo -ne '\e[5 q'  # beam cursor
  fi
}
zle -N zle-keymap-select
zle-line-init() {
  zle-keymap-select
}
zle -N zle-line-init

# enter vim buffer with key
autoload edit-command-line; zle -N edit-command-line
bindkey '\ev' edit-command-line

#!/usr/bin/env bash

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

# Update & upgrade
sudo apt update && sudo apt full-upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

# Core tooling
sudo apt install -y \
  neovim curl btop zsh screen tmux 7zip git ca-certificates fastfetch fzf btrfs-progs duperemove eza du-dust

# Change root’s shell to zsh
sudo chsh -s "$(command -v zsh)" root

# Install oh my zsh
sudo env RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Create user “laura” with zsh, no password
LAURA_UID=1000
LAURA_GID=1000
sudo addgroup --gid "$LAURA_GID" laura
sudo adduser --disabled-password --comment "" --shell /bin/zsh --uid "$LAURA_UID" --gid "$LAURA_GID" laura
# sudo useradd -m -u "$LAURA_UID" -g "$LAURA_GID" -s /bin/zsh laura
cd /home/laura
sudo -H -u laura env HOME=/home/laura USER=laura LOGNAME=laura RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# SSH keys – root
sudo install -o root -g root -m 700 -d /root/.ssh
sudo curl -fsSL https://raw.githubusercontent.com/LauraEdmu/config/master/pub_keys/orca.pub \
  -o /root/.ssh/authorized_keys
sudo chmod 600 /root/.ssh/authorized_keys

# SSH keys – laura
sudo -H -u laura install -m 700 -d /home/laura/.ssh
sudo -H -u laura curl -fsSL https://raw.githubusercontent.com/LauraEdmu/config/master/pub_keys/orca.pub \
  -o /home/laura/.ssh/authorized_keys
sudo chown -R laura:laura /home/laura/.ssh
sudo chmod 700 /home/laura/.ssh
sudo chmod 600 /home/laura/.ssh/authorized_keys


# SSH daemon hardening
sudo sed -i \
  -e 's/^#\?PasswordAuthentication .*/PasswordAuthentication no/' \
  -e 's/^#\?PermitRootLogin .*/PermitRootLogin prohibit-password/' \
  /etc/ssh/sshd_config
sudo systemctl restart ssh

# Timezone
sudo timedatectl set-timezone Europe/London

# zsh configs
sudo curl -fsSL https://raw.githubusercontent.com/LauraEdmu/config/refs/heads/master/bash-zsh/.zshrc \
  -o /root/.zshrc
sudo -H -u laura curl -fsSL https://raw.githubusercontent.com/LauraEdmu/config/refs/heads/master/bash-zsh/.zshrc \
  -o /home/laura/.zshrc

# Neovim configs
sudo -H -u laura install -m 700 -d /home/laura/.config/nvim
sudo -H -u laura curl -fsSL https://raw.githubusercontent.com/LauraEdmu/config/refs/heads/master/nvim/init.lua \
  -o /home/laura/.config/nvim/init.lua
sudo install -o root -g root -m 700 -d /root/.config/nvim
sudo curl -fsSL https://raw.githubusercontent.com/LauraEdmu/config/refs/heads/master/nvim/init.lua \
  -o /root/.config/nvim/init.lua

# ---- Zsh plugin dependencies & extras ----

# Packages
sudo apt install -y zoxide

# oh-my-zsh custom plugins directory
OMZ_CUSTOM="/root/.oh-my-zsh/custom/plugins"
LAURA_OMZ_CUSTOM="/home/laura/.oh-my-zsh/custom/plugins"

# Function to install a plugin if missing
install_plugin() {
  local repo="$1"
  local name="$2"
  local target="$3"

  if [ ! -d "$target/$name" ]; then
    git clone --depth=1 "$repo" "$target/$name"
  fi
}

# Root plugins
sudo install -o root -g root -m 755 -d "$OMZ_CUSTOM"

install_plugin https://github.com/zsh-users/zsh-autosuggestions \
  zsh-autosuggestions "$OMZ_CUSTOM"

install_plugin https://github.com/zsh-users/zsh-syntax-highlighting \
  zsh-syntax-highlighting "$OMZ_CUSTOM"

install_plugin https://github.com/zsh-users/zsh-completions \
  zsh-completions "$OMZ_CUSTOM"

install_plugin https://github.com/agkozak/zsh-z \
  zsh-z "$OMZ_CUSTOM"

# Laura plugins
sudo -H -u laura install -m 755 -d "$LAURA_OMZ_CUSTOM"

sudo -H -u laura bash -c '
  install_plugin() {
    repo="$1"; name="$2"; target="$3"
    [ -d "$target/$name" ] || git clone --depth=1 "$repo" "$target/$name"
  }

  install_plugin https://github.com/zsh-users/zsh-autosuggestions \
    zsh-autosuggestions "'"$LAURA_OMZ_CUSTOM"'"

  install_plugin https://github.com/zsh-users/zsh-syntax-highlighting \
    zsh-syntax-highlighting "'"$LAURA_OMZ_CUSTOM"'"

  install_plugin https://github.com/zsh-users/zsh-completions \
    zsh-completions "'"$LAURA_OMZ_CUSTOM"'"

  install_plugin https://github.com/agkozak/zsh-z \
    zsh-z "'"$LAURA_OMZ_CUSTOM"'"
'
## General Setup Complete

### yt-dlp setup
sudo install -o laura -g laura -m 755 -d /srv/ytdlp

BIN_NAME='yt-dlp'
BIN_DIR='/srv/ytdlp'
BIN_PATH="$BIN_DIR/$BIN_NAME"
TMP_PATH="$BIN_PATH.tmp"

sudo curl -fsSLo "$TMP_PATH" 'https://github.com/yt-dlp/yt-dlp-nightly-builds/releases/latest/download/yt-dlp_linux'

sudo chmod 0755 "$TMP_PATH"
sudo chown laura:laura "$TMP_PATH"
sudo mv "$TMP_PATH" "$BIN_PATH"

echo "yt-dlp nightly is ready"

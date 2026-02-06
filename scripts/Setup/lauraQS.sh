#!/usr/bin/env bash
# lauraQS_Ext.sh – bootstrap a fresh Debian/Ubuntu system
# Ensure Unix line endings:  sed -i 's/\r$//' lauraQS_Ext.sh

set -euo pipefail

# Update & upgrade
sudo apt update && sudo apt upgrade -y

# Core tooling
sudo apt install -y \
  neovim curl btop zsh build-essential ripgrep fd-find fzf git htop

# (Optional) shorter alias for fd-find
sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd

# Change root’s shell to zsh
sudo chsh -s "$(command -v zsh)" root

# Create user “laura” with zsh, no password, sudo privileges
sudo adduser --disabled-password --gecos "" --shell /bin/zsh laura
# sudo usermod -aG sudo laura
sudo passwd -d laura

# SSH keys – root
sudo install -o root -g root -m 700 -d /root/.ssh
sudo curl -fsSL https://raw.githubusercontent.com/LauraEdmu/config/master/pub_keys/orca.pub \
  -o /root/.ssh/authorized_keys
sudo chmod 600 /root/.ssh/authorized_keys

# SSH keys – laura
sudo -u laura install -m 700 -d /home/laura/.ssh
sudo -u laura curl -fsSL https://raw.githubusercontent.com/LauraEdmu/config/master/pub_keys/orca.pub \
  -o /home/laura/.ssh/authorized_keys
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
sudo -u laura curl -fsSL https://raw.githubusercontent.com/LauraEdmu/config/refs/heads/master/bash-zsh/.zshrc \
  -o /home/laura/.zshrc

# Neovim configs
sudo -u laura install -m 700 -d /home/laura/.config/nvim
sudo -u laura curl -fsSL https://raw.githubusercontent.com/LauraEdmu/config/refs/heads/master/nvim/init.lua \
  -o /home/laura/.config/nvim/init.lua
sudo install -o root -g root -m 700 -d /root/.config/nvim
sudo curl -fsSL https://raw.githubusercontent.com/LauraEdmu/config/refs/heads/master/nvim/init.lua \
  -o /root/.config/nvim/init.lua

echo "Setup complete! Recommended: run get_rust next."

#!/usr/bin/env bash
# lauraQS_Ext.sh – bootstrap a fresh Debian/Ubuntu system
# Ensure Unix line endings:  sed -i 's/\r$//' lauraQS_Ext.sh

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
ENABLE_LAURA_SUDO=0

# Update & upgrade
sudo apt update && sudo apt full-upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

# Core tooling
sudo apt install -y \
  neovim curl btop zsh ripgrep fd-find du-dust eza 7zip screen tmux fastfetch build-essential fzf git htop btrfs-progs duperemove bat

TMP_YAZI="$(mktemp /tmp/yazi.XXXXXX.deb)"
curl -fsSLo "$TMP_YAZI" https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.deb
sudo apt install -y "$TMP_YAZI"
sudo rm -f "$TMP_YAZI"

TMP_SD="$(mktemp /tmp/sd.XXXXXX.tar.gz)"
TMP_DIR="$(mktemp -d /tmp/sd.XXXXXX)"
curl -fsSLo "$TMP_SD" 'https://github.com/chmln/sd/releases/download/v1.0.0/sd-v1.0.0-x86_64-unknown-linux-gnu.tar.gz'
tar -xzf "$TMP_SD" -C "$TMP_DIR" --strip-components=1
sudo install -m 755 "$TMP_DIR/sd" /usr/local/bin/sd
rm -rf "$TMP_SD" "$TMP_DIR"

TMP_HX="$(mktemp /tmp/HX.XXXXXX.deb)"
curl -fsSLo "$TMP_HX" 'https://github.com/helix-editor/helix/releases/download/25.07.1/helix_25.7.1-1_amd64.deb'
sudo apt install -y "$TMP_HX"
sudo rm -f "$TMP_HX"
install -d -m 755 /root/.config/helix
curl -fsSLo /root/.config/helix/config.toml 'https://raw.githubusercontent.com/LauraEdmu/config/master/helix/config.toml'

# (Optional) shorter alias for fd-find
sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd

# Change root’s shell to zsh
sudo chsh -s "$(command -v zsh)" root

# Install oh my zsh
sudo env RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# prep plugin files
#sudo curl -fsSL https://raw.githubusercontent.com/LauraEdmu/config/master/nvim/.oh-my-zsh.7z \
  #-o /root/.oh-my-zsh.7z

# Create user “laura” with zsh, no password
LAURA_UID=1000
LAURA_GID=1000
sudo addgroup --gid "$LAURA_GID" laura
sudo adduser --disabled-password --comment "" --shell /bin/zsh --uid "$LAURA_UID" --gid "$LAURA_GID" laura
cd /home/laura
sudo -H -u laura env HOME=/home/laura USER=laura LOGNAME=laura RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo -H -u laura -- install -d -m 755 /home/laura/.config/helix
sudo -H -u laura -- curl -fsSLo /home/laura/.config/helix/config.toml \
  'https://raw.githubusercontent.com/LauraEdmu/config/master/helix/config.toml'
  
if [ "$ENABLE_LAURA_SUDO" -eq 1 ]; then
  sudo usermod -aG sudo laura
  # If laura has no password, sudo would be unusable unless you do this:
  echo 'laura ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/laura >/dev/null
  sudo chmod 440 /etc/sudoers.d/laura
else
  sudo deluser laura sudo >/dev/null 2>&1 || true
  sudo rm -f /etc/sudoers.d/laura
fi


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



## Complete

echo "Setup complete! Recommended: run get_rust next."

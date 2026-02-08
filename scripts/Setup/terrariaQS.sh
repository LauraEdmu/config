#!/usr/bin/env bash

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

# Update & upgrade
sudo apt update && sudo apt full-upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

# Core tooling
sudo apt install -y \
  neovim curl btop zsh screen tmux 7zip git ca-certificates fastfetch fzf

# Change root’s shell to zsh
sudo chsh -s "$(command -v zsh)" root

# Install oh my zsh
sudo env RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Create user “laura” with zsh, no password
sudo adduser --disabled-password --gecos "" --shell /bin/zsh laura
cd /home/laura
sudo -H -u laura env HOME=/home/laura USER=laura LOGNAME=laura RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#sudo -H -u laura env RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

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

## Game Setup Start
sudo install -d -o laura -g laura /srv/terraria
cd /srv/terraria
VERSION=1454
curl -Lfo server.zip "https://terraria.org/api/download/pc-dedicated-server/terraria-server-$VERSION.zip"
7z x -y server.zip
rm -rf ./$VERSION/Windows ./$VERSION/Mac server.zip
mv ./$VERSION/Linux/* ./$VERSION/.
rmdir ./$VERSION/Linux
sudo chmod +x ./$VERSION/TerrariaServer*

cat > start.sh <<EOF
#!/usr/bin/env bash
set -euo pipefail

BIN="./TerrariaServer.bin.x86_64"
PORT=7777
PASS=""
PLAYERS=10
WORLD="addme.wld"

cd "$VERSION"

exec "\$BIN" \\
  -port "\$PORT" \\
  -pass "\$PASS" \\
  -players "\$PLAYERS" \\
  -world "\$WORLD" \\
  -ip 0.0.0.0
EOF
sudo chmod +x start.sh

cat > makeworld.sh <<EOF
#!/usr/bin/env bash
set -euo pipefail

BIN="./TerrariaServer.bin.x86_64"
PORT=7777
PASS=""
PLAYERS=10
WORLD="\${WORLD:?Set WORLD to desired name (no .wld)}"
SIZE="\${SIZE:?Set SIZE to 1 (small), 2 (medium), or 3 (large)}"

cd "$VERSION"

exec "\$BIN" \\
  -port "\$PORT" \\
  -pass "\$PASS" \\
  -players "\$PLAYERS" \\
  -autocreate "\$SIZE" \\
  -worldname "\$WORLD" \\
  -ip 0.0.0.0
EOF
sudo chmod +x makeworld.sh


sudo chown -R laura:laura /srv/terraria

echo "Terraria Version $VERSION server is now set up and ready.
1:sudo -u laura screen -S terraria
2:cd /srv/terraria
3:Consider using and changing start.sh
"

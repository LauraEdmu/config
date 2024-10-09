#!/bin/bash

# Note: might need to sed -i 's/\r$//' lauraQS_Ext.sh

# Update and upgrade system
sudo apt update && sudo apt upgrade -y

# Install necessary packages
sudo apt install -y ufw neovim curl git fail2ban upower fzf htop

# Create a new user "laura" without a password and add to sudo group
sudo useradd -m -s /bin/bash laura
sudo usermod -aG sudo laura

# Disable password login for the new user
sudo passwd -d laura

# Make SSH directory for root and set permissions
sudo mkdir -p /root/.ssh
sudo chmod 700 /root/.ssh

# Download SSH public key from GitHub and add to root's authorized_keys
sudo curl -s https://raw.githubusercontent.com/LauraEdmu/config/master/pub_keys/id_ed25519.pub -o /root/.ssh/authorized_keys
sudo chmod 600 /root/.ssh/authorized_keys

# Make SSH directory for user "laura" and set permissions
sudo mkdir -p /home/laura/.ssh
sudo chmod 700 /home/laura/.ssh

# Add the same SSH public key to the new user's authorized_keys
sudo curl -s https://raw.githubusercontent.com/LauraEdmu/config/master/pub_keys/id_ed25519.pub -o /home/laura/.ssh/authorized_keys
sudo chmod 600 /home/laura/.ssh/authorized_keys
sudo chown -R laura:laura /home/laura/.ssh

# Disable root login over SSH and disable password authentication
#sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart ssh

# Enable and configure UFW, allowing SSH (port 22) only
sudo ufw allow proto tcp from any to any port 22
sudo ufw enable

# Enable and start Fail2Ban for SSH protection
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# Set the system timezone to Europe/London
sudo timedatectl set-timezone Europe/London

sudo curl -s https://raw.githubusercontent.com/LauraEdmu/config/master/.bashrc -o /root/.bashrc
sudo curl -s https://raw.githubusercontent.com/LauraEdmu/config/master/.bashrc -o /home/laura/.bashrc

# Install vim-plug for Neovim (for both laura and root)
#curl -fLo /home/laura/.local/share/nvim/site/autoload/plug.vim --create-dirs \
#    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
#sudo curl -fLo /root/.local/share/nvim/site/autoload/plug.vim --create-dirs \
#    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
#sudo chown -R laura:laura /home/laura/.local

# Set up Neovim for both users, download init.lua
#mkdir -p /home/laura/.config/nvim
#curl -s https://raw.githubusercontent.com/LauraEdmu/config/refs/heads/master/nvim/init.lua -o /home/laura/.config/nvim/init.lua
#mkdir -p /root/.config/nvim
#sudo curl -s https://raw.githubusercontent.com/LauraEdmu/config/refs/heads/master/nvim/init.lua -o /root/.config/nvim/init.lua

# Ensure laura owns all files in her home directory
sudo chown -R laura:laura /home/laura

sudo source ~/.bashrc

echo "Setup complete! A system reboot is recommended to apply all changes."

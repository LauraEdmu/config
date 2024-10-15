#!/bin/bash

# Update and upgrade system
sudo dnf update -y

# Install necessary packages
sudo dnf install -y ufw neovim curl git fail2ban upower fzf htop

# Create a new user "laura" without a password and add to the wheel group (Fedora's sudo group)
sudo useradd -m -s /bin/bash laura
sudo usermod -aG wheel laura

# Disable password login for the new user
sudo passwd -d laura

# Make SSH directory for root and set permissions
sudo mkdir -p /root/.ssh
sudo chmod 700 /root/.ssh

# Download SSH public key from GitHub and add to root's authorized_keys
sudo curl -s https://raw.githubusercontent.com/LauraEdmu/config/master/pub_keys/icedphoenix.pub -o /root/.ssh/authorized_keys
sudo chmod 600 /root/.ssh/authorized_keys

# Make SSH directory for user "laura" and set permissions
sudo mkdir -p /home/laura/.ssh
sudo chmod 700 /home/laura/.ssh

# Add the same SSH public key to the new user's authorized_keys
sudo curl -s https://raw.githubusercontent.com/LauraEdmu/config/master/pub_keys/icedphoenix.pub -o /home/laura/.ssh/authorized_keys
sudo chmod 600 /home/laura/.ssh/authorized_keys
sudo chown -R laura:laura /home/laura/.ssh

# Disable password authentication for SSH
sudo sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Enable and configure UFW, allowing SSH (port 22) only
sudo ufw allow proto tcp from any to any port 22

# Enable and start Fail2Ban for SSH protection
sudo systemctl enable --now fail2ban

# Set the system timezone to Europe/London
sudo timedatectl set-timezone Europe/London

# Download .bashrc for root and user "laura"
sudo curl -s https://raw.githubusercontent.com/LauraEdmu/config/master/.bashrc -o /root/.bashrc
sudo curl -s https://raw.githubusercontent.com/LauraEdmu/config/master/.bashrc -o /home/laura/.bashrc

# Ensure laura owns all files in her home directory
sudo chown -R laura:laura /home/laura

# Source the bashrc for immediate effect
source ~/.bashrc

echo "Setup complete! You may now want to Enable UFW (Already configured). A system reboot is recommended to apply all changes."

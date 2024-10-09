#!/bin/sh

# Update and upgrade system
apk update && apk upgrade

# Install necessary packages including common Linux utilities
apk add bash ufw neovim curl git fail2ban upower fzf htop sudo openssh util-linux

# Make bash the default shell for root
chsh -s /bin/bash root

# Create a new user "laura" without a password and add to wheel (sudo) group
adduser -D -s /bin/bash laura
adduser laura wheel

# Disable password login for the new user
passwd -d laura

# Ensure sudo group is set up correctly
echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Make SSH directory for root and set permissions
mkdir -p /root/.ssh
chmod 700 /root/.ssh

# Download SSH public key from GitHub and add to root's authorized_keys
curl -s https://raw.githubusercontent.com/LauraEdmu/config/master/pub_keys/id_ed25519.pub -o /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

# Make SSH directory for user "laura" and set permissions
mkdir -p /home/laura/.ssh
chmod 700 /home/laura/.ssh

# Add the same SSH public key to the new user's authorized_keys
curl -s https://raw.githubusercontent.com/LauraEdmu/config/master/pub_keys/id_ed25519.pub -o /home/laura/.ssh/authorized_keys
chmod 600 /home/laura/.ssh/authorized_keys
chown -R laura:laura /home/laura/.ssh

# Disable password authentication for SSH
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
rc-service sshd restart

# Enable and configure UFW, allowing SSH (port 22) only
ufw allow proto tcp from any to any port 22
ufw --force enable

# Enable and start Fail2Ban for SSH protection
rc-update add fail2ban
rc-service fail2ban start

# Set the system timezone to Europe/London
setup-timezone -z Europe/London

# Download custom .bashrc for root and laura
curl -s https://raw.githubusercontent.com/LauraEdmu/config/master/.bashrc -o /root/.bashrc
curl -s https://raw.githubusercontent.com/LauraEdmu/config/master/.bashrc -o /home/laura/.bashrc

# Ensure laura owns all files in her home directory
chown -R laura:laura /home/laura

# Source the new bashrc for root
source /root/.bashrc

echo "Setup complete! A system reboot is recommended to apply all changes."

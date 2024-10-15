#!/bin/bash

# Disable password authentication in SSH config

# Backup the current SSH config
CONFIG_FILE="/etc/ssh/sshd_config"
BACKUP_FILE="/etc/ssh/sshd_config.bak"

if [ -f "$CONFIG_FILE" ]; then
    echo "Backing up current SSH config to $BACKUP_FILE"
    cp "$CONFIG_FILE" "$BACKUP_FILE"
else
    echo "SSH config file not found at $CONFIG_FILE!"
    exit 1
fi

# Update the SSH configuration
echo "Disabling password authentication..."
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' "$CONFIG_FILE"
sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' "$CONFIG_FILE"
sed -i 's/^#PermitRootLogin yes/PermitRootLogin prohibit-password/' "$CONFIG_FILE"
sed -i 's/^PermitRootLogin yes/PermitRootLogin prohibit-password/' "$CONFIG_FILE"

# Ensure PubkeyAuthentication is enabled
sed -i 's/^#PubkeyAuthentication yes/PubkeyAuthentication yes/' "$CONFIG_FILE"
sed -i 's/^PubkeyAuthentication no/PubkeyAuthentication yes/' "$CONFIG_FILE"

# Restart SSH service to apply changes
echo "Restarting SSH service..."
systemctl restart ssh

echo "Password authentication disabled. You can only access the server using SSH keys now."

# Optional: Check status of SSH service
systemctl status ssh --no-pager

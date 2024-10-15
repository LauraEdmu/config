#!/bin/bash

# Disable password authentication for local logins

# Backup the current PAM config
PAM_CONFIG="/etc/pam.d/common-auth"
BACKUP_PAM_CONFIG="/etc/pam.d/common-auth.bak"

if [ -f "$PAM_CONFIG" ]; then
    echo "Backing up current PAM config to $BACKUP_PAM_CONFIG"
    cp "$PAM_CONFIG" "$BACKUP_PAM_CONFIG"
else
    echo "PAM config file not found at $PAM_CONFIG!"
    exit 1
fi

# Disable password login by commenting out the pam_unix.so line
echo "Disabling password authentication for local logins..."
sed -i 's/^\(auth.*pam_unix.so.*\)/# \1/' "$PAM_CONFIG"

# Add a message indicating that password-based logins are disabled (optional)
if ! grep -q "auth required pam_deny.so" "$PAM_CONFIG"; then
    echo "auth required pam_deny.so" >> "$PAM_CONFIG"
fi

echo "Password authentication for local logins has been disabled."
echo "Users will no longer be able to log in using passwords for console or tty access."

# Optional: Restart related services (not usually required, but you can reboot to test)
# systemctl restart getty@tty1.service

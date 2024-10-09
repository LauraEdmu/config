#!/bin/bash

# Update repos
sudo apt update

# Install ffmpeg, curl, and UFW
sudo apt install -y ffmpeg curl ufw

# Allow port 80 and 20 through UFW
sudo ufw allow 80

# Check if Jellyfin is already installed
if ! command -v jellyfin &> /dev/null; then
    # Download and run the Jellyfin setup script
    curl -s https://repo.jellyfin.org/install-debuntu.sh | sudo bash
else
    echo "Jellyfin is already installed!"
fi

# Create media directories
sudo mkdir -p /media/movies /media/tv /media/books /media/music

# Set the correct permissions for the media directories
sudo chown -R jellyfin:jellyfin /media
sudo chmod -R 755 /media

# Allow jellyfin to bind port 80
sudo setcap 'cap_net_bind_service=+ep' /usr/lib/jellyfin/bin/jellyfin

echo "Script has finished! Once you've configured it, you can run sed -i 's/8096/80/' /etc/jellyfin/network.xml to change port"
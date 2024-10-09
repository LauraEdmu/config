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

# Wait for Jellyfin to start before modifying the configuration
sudo systemctl start jellyfin
sleep 5

# Change Jellyfin port to 80 in the configuration file
sudo sed -i 's/8096/80/' /etc/jellyfin/network.xml

# Restart Jellyfin to apply the changes
sudo systemctl restart jellyfin

# Create media directories
sudo mkdir -p /media/movies /media/tv /media/books /media/music

# Set the correct permissions for the media directories
sudo chown -R jellyfin:jellyfin /media
sudo chmod -R 755 /media

echo "Script has finished!"
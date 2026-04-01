#!/usr/bin/env bash

set -euo pipefail

SSID='ssid'
PASSWORD='password'
SAFE_CONN='laura-phone'

rollback() {
    echo "Rolling back to $SAFE_CONN..."
    nmcli connection up "$SAFE_CONN" || true
}

trap rollback EXIT

nmcli device wifi connect "$SSID" password "$PASSWORD"

echo "Waiting to confirm connectivity..."
sleep 10
IP="$(curl -fsS https://ipinfo.io/ip)"
echo "External IP: $IP"
echo "Local IP: $(ip -4 addr show scope global | grep -oP '(?<=inet\s)\d+(\.\d+){3}')"

trap - EXIT
echo "Connection to $SSID stable"

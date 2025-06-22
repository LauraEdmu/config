#!/bin/bash

# Vars
WEBHOOK_URL="https://discord.com/api/webhooks/rest-of-it-here"
USERNAME="Uptime Announce"

# Collect system info
HOSTNAME="$(hostname)"
UPTIME="$(uptime -p)"
WHO="$(who | awk '{print $1 " on " $2 " since " $3 " " $4}' | paste -sd '; ' -)"
MEMORY="$(free -h | awk '/^Mem:/ {print $3 "/" $2 " used (" $7 " free)"}')"
LOAD="$(uptime | awk -F'load average: ' '{print $2}')"
DATE="$(date -Iseconds)"

# Build message
MESSAGE="📡 Daily Status Ping
**Hostname:** $HOSTNAME
**Time:** $DATE
**Uptime:** $UPTIME
**Users:** ${WHO:-None}
**Memory:** $MEMORY
**Load Average:** $LOAD"

# Send
jq -Rs --arg content "$MESSAGE" --arg username "$USERNAME" '{content: $content, username: $username}' \
    <<< "" | xh POST "$WEBHOOK_URL"

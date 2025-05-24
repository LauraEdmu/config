#!/bin/bash

# Replace with your keys
USER_KEY="blank"
APP_TOKEN="blank"

IP=$(echo "$SSH_CONNECTION" | cut -d ' ' -f 1)
HOST=$(hostname)
TIME=$(date -u '+%Y-%m-%d %H:%M:%S UTC')

curl -s -o /dev/null --fail \
  -F "token=$APP_TOKEN" \
  -F "user=$USER_KEY" \
  -F "title=SSH Login on $HOST" \
  -F "message=User $USER from $IP at $TIME" \
  https://api.pushover.net/1/messages.json \
  >/dev/null 2>&1

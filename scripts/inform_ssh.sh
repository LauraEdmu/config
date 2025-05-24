PLACE IN --> /etc/ssh/sshrc
/usr/local/bin/ssh_notify.sh &


PLACE IN --> /usr/local/bin/ssh_notify.sh
#!/bin/bash

WEBHOOK_URL="ENTER_WEBHOOK"
HOSTNAME="$(hostname)"
USER_NAME="$(whoami)"
IP_ADDRESS="$(echo $SSH_CONNECTION | awk '{print $1}')"
TIME="$(TZ='Europe/London' date '+%Y-%m-%d %H:%M:%S %Z')" # UK Timezone
# TIME="$(date -u '+%Y-%m-%d %H:%M:%S %Z')" # UTC
# TIME="$(date '+%Y-%m-%d %H:%M:%S %Z')" # System Time

CONTENT="🔐 SSH login on \`$HOSTNAME\` by user \`$USER_NAME\` from IP \`$IP_ADDRESS\` at \`$TIME\`"

curl -H "Content-Type: application/json" \
     -X POST \
     -d "{\"content\": \"$CONTENT\"}" \
     "$WEBHOOK_URL"


ALT VERSION USING PUSHOVER
#!/bin/bash

# Replace with your keys
USER_KEY="blank"
APP_TOKEN="blank"

IP=$(echo "$SSH_CONNECTION" | cut -d ' ' -f 1)
HOST=$(hostname)
TIME=$(TZ='Europe/London' date -u '+%Y-%m-%d %H:%M:%S UTC')

curl -s -o /dev/null --fail \
  -F "token=$APP_TOKEN" \
  -F "user=$USER_KEY" \
  -F "title=SSH Login on $HOST" \
  -F "message=User $USER from $IP at $TIME" \
  https://api.pushover.net/1/messages.json \
  >/dev/null 2>&1

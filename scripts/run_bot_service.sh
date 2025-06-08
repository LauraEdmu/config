### Example of making a service to autorun a bot ###


filename --> illusion_bot.sh
#!/bin/bash

# Name of your screen session
SESSION_NAME="illusion"

# Absolute paths
VENV_PATH="/opt/bots/illusion_venv/"
PROJECT_PATH="/opt/bots/illusion"
PYTHON_SCRIPT="main.py"

# Start screen and run commands in it
screen -dmS "$SESSION_NAME" bash -c "
  source \"$VENV_PATH/bin/activate\" && \
  cd \"$PROJECT_PATH\" && \
  python \"$PYTHON_SCRIPT\"
"

filename --> /etc/systemd/system/illusion_bot.service
[Unit]
Description=Start illusion Bot in screen
After=network.target

[Service]
Type=oneshot
ExecStart=/root/illusion_bot.sh
User=root
RemainAfterExit=true

[Install]
WantedBy=multi-user.target

• systemctl daemon-reload
• systemctl enable illusion_bot.service
• systemctl start illusion_bot.service

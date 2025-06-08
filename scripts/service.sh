
#!/bin/bash

# Name of your screen session
SESSION_NAME="Screen session name"

# Absolute paths
VENV_PATH=""
PROJECT_PATH=""
PYTHON_SCRIPT="app.py"

# Start screen and run commands in it
screen -dmS "$SESSION_NAME" bash -c "
  source \"$VENV_PATH/bin/activate\" && \
  cd \"$PROJECT_PATH\" && \
  python \"$PYTHON_SCRIPT\"
"


/etc/systemd/system/servicename.service
[Unit]
Description=Start service in screen
After=network.target

[Service]
Type=oneshot
ExecStart=/root/runservice.sh
User=root
RemainAfterExit=true
Nice=-10

[Install]
WantedBy=multi-user.target
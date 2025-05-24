PLACE IN --> /etc/profile.d/motd.sh
#!/bin/bash
echo -e "=== Laura's Lilnode ==="
echo -e "Hostname : $(hostname)"
echo -e "OS       : $(lsb_release -ds)"
echo -e "Uptime   : $(uptime -p)"
echo    "------------------------"
echo -e "Github   : https://github.com/lauraEdmu/"

PLACE IN --> ~/.zprofile
# Manually source /etc/profile.d scripts (for dynamic MOTD)
for script in /etc/profile.d/*.sh; do
  [ -r "$script" ] && . "$script"
done
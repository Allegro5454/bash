# AutoSU - Automatic System Update

# Info

Bash script that sets systemd timer that updates your system every monday at 00 or at first start after that hour.

# Requirements

Debian/Ubuntu based system (apt-get package manager needed)
Root priveleges

# How to start

1.chmod +x AutoSU.sh
2.sudo ./AutoSU.sh

# How to check

journalctl -u update.service - checks logs of the update process
systemctl status update.service - checks if the script is active and when will it run next

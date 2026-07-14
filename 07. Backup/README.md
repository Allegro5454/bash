# RS_BACKUP = RSYNC BACKUP MANAGER

# INFO
Bash script that synchronizes files from point A to point B locally or via SSH.
Designed for automated background execution (e.g., via cron or systemd).

# REQUIREMENTS
- rsync
- awk
- SSH client
- Configured passwordless SSH keys (Required for remote transfers, script runs in BatchMode)

# LOGS
Script automatically generates logs based on the executing user:
- Root: `/var/log/backup-manager/`
- User: `~/.local/state/backup_manager/`
# CONFIGURATION
Configuration is read from `~/.config/RS_BACKUP/config`.
There are 2 variables that can be set:
- API="<your_discord_webhook>"
- ALTERNATE_PATH="<alternate_log_path>"
# HOW TO START
chmod +x RS_BACKUP.sh
./RS_BACKUP.sh FROM_PATH TO_PATH

For remote directories, use the standard SSH format:
user@server:/path/to/directory

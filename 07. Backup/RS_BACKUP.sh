#!/bin/bash
#Looking for a bad command syntax.
CURR_DATE=$(date +%F-%H-%M )
LOG_FILE="BACKUP$CURR_DATE.log"
if [[ "$EUID" -eq 0 ]]; then
    LOG_LOC="/var/log/backup-manager/"
else
    LOG_LOC="$HOME/.local/state/backup_manager/"
fi
mkdir -p "$LOG_LOC"
logmsg() {
    echo -e "$1" | tee -a "$LOG_LOC$LOG_FILE"
}
#Start of the script
logmsg "=== Backup Manager ==="
if (( "$#" < 2 )); then 
    logmsg "Not enough arguments"
    logmsg "YOUR_PATH/RS_BACKUP.sh FROM_PATH TO_PATH"
exit 1
fi
#Looking for an error in the first var
if [[ ! "$1" == *:* ]]; then
    if [[ ! -e "$1" ]]; then
        logmsg "There is no File/Directory with this name: $1 "
        exit 1
    fi    
else
    SSH_CHECK=${1%%:*}
    logmsg "$SSH_CHECK"
    ssh -o BatchMode=yes -o ConnectTimeout=10 "$SSH_CHECK" exit > /dev/null 2>&1
    if [[ ! $? == 0 ]]; then
        logmsg "SSH connection wasn't established"
        exit 1
    fi
fi
#Looking for a connection error
if [[ "$2" == *:* ]]; then
    SSH_CHECK2=${2%%:*}
    ssh -o BatchMode=yes -o ConnectTimeout=5 "$SSH_CHECK2" exit > /dev/null 2>&1 
    if [[ ! $? == 0 ]]; then
        logmsg "SSH connection wasn't established"
        exit 1
    fi
fi
#checking disc usage
if [[ ! "$1" == *:* ]]; then
    USG_1=$( du -k --summarize "$1" | awk '{print $1}')
else
    DIR_LOC=${1#*:}
    USG_1=$(ssh -o BatchMode=yes -o ConnectTimeout=5 "$SSH_CHECK" "du -k --summarize \"$DIR_LOC\" | awk '{print \$1}'" )
fi
if [[ ! "$2" == *:* ]]; then
    if [[ -d "$2" ]]; then
        USG_2=$( df -k --output=avail "$2" | tail -n 1 )
    else    
        FATH_DIR=$( dirname "$2" )
        USG_2=$( df -k --output=avail "$FATH_DIR" | tail -n 1 )
    fi
else
    DIR_LOC=${2#*:}
    FATH_DIR=$( dirname "$DIR_LOC" )    
    USG_2=$( ssh -o BatchMode=yes -o ConnectTimeout=5 "$SSH_CHECK2" " df -k --output=avail \"$FATH_DIR\" | tail -n 1"  )
fi
if [[ -z "$USG_1" ]]; then
    logmsg "The command ended with an error "
    exit 1
fi
if [[ -z "$USG_2" ]]; then
    logmsg "The command ended with an error"
    exit 1
fi
if (( USG_1 > USG_2*8/10 )); then
    logmsg "Not enough free space"
    exit 1
fi

rsync -e "ssh -o BatchMode=yes -o ConnectTimeout=5" -avh "$1" "$2" >> "$LOG_LOC$LOG_FILE" 2>&1
RSYNC_EXT=$?
if [[ $RSYNC_EXT -ne 0 ]]; then
    logmsg "Process encountered a problem. Error Code: $RSYNC_EXT "
    exit 1
else
    logmsg "=== Data transfered succesfully ==="
fi

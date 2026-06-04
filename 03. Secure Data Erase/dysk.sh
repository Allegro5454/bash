#!/bin/bash

# --- KONFIGURACJA ---
LOG_FILE="$HOME/Dziennik_$(date +%Y%m%d_%H%M%S).txt"

# Funkcja logująca i wyświetlająca tekst
log_message() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

clear
log_message "=== Secure Data Eraser ==="
log_message "Data: $(date)"
log_message "---------------------------------------------"

# 1. Identyfikacja dysków
log_message "\nAvaiable drives:"
lsblk -o NAME,MODEL,SIZE,TYPE,TRAN,MOUNTPOINTS | tee -a "$LOG_FILE"

echo -ne "\nWrite the name of the drive you want to (sda or nvme0n1): "
read DISK_NAME
if [$DISK_NAME = sda[1-9] ]
    echo -ne "Please write only name of the drive not partition"
    exit 1
fi
if [$DISK_NAME = nvme0n*[p]* ]
    echo -ne "Please write only name of the drive not partition"
    exit 1
fi
DISK_PATH="/dev/$DISK_NAME"


# Sprawdzenie czy dysk istnieje
if [ ! -b "$DISK_PATH" ]; then
    log_message "There is no $DISK_PATH avaiable "
    exit 1
fi

# 2. Weryfikacja typu (HDD vs SSD)
IS_ROTATIONAL=$(cat /sys/block/$DISK_NAME/queue/rotational)
TRIM_OUTDATED=$(cat /sys/block/$DISK_NAME/queue/discard_zeroes_data)
if [ "$IS_ROTATIONAL" -eq "1" ]; then
    DISK_TYPE="HDD"
    CLEAN_CMD="sudo dd if=/dev/zero of=$DISK_PATH bs=1M status=progress"
else
    DISK_TYPE="SSD"
    if ["TRIM_OUTDATED" -eq "1"] then
        CLEAN_CMD="sudo blkdiscard -vf $DISK_PATH"
        log_message "\nDisk $DISK_PATH support TRIM, Blkdiscard will work"
    else
        CLEAN_CMD="sudo blkdiscard -vzf $DISK_PATH"
        log_message "\nDisk $DISK_PATH is not supporting TRIM, Blkdiscard will not work"
    fi

fi

log_message "\nDETECTED: $DISK_TYPE ($DISK_PATH)"
log_message "ATTENTION:ALL DATA ON $DISK_PATH WILL BE DESTROYED"
echo -ne "Do you want to continute (write: YES):"
read CONFIRM
CONFIRM=$(<<<"$CONFIRM" sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
CONFIRM=$(tr '[:upper:]' '[:lower:]' <<< "$CONFIRM")

if [ "$CONFIRM" != "yes" ];  then
    log_message "Operation Stopped"
    exit 0
fi

# 3. Rozpoczęcie czyszczenia
log_message "\nOperation starting on $DISK_TYPE..."
START_TIME=$(date +%s)

eval $CLEAN_CMD 2>&1 | tee -a "$LOG_FILE"

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

log_message "\nOperation Ended: $DISK_PATH Data is discarded."
log_message "Duration time: $DURATION seconds."
log_message "---------------------------------------------"

 # 4. Kopiowanie logu na pendrive (opcjonalnie)
echo -ne "\nDo you want to Copy log file to external drive? (y): "
read COPY_LOG
if [ "$COPY_LOG" == "y" || "$COPY_LOG" == "Y" ]; then
	lsblk -o NAME,MODEL,SIZE,TYPE,TRAN,MOUNTPOINTS
    echo "Write name of the external drive partition (np. sdb1): "
    read PEN_PART
    mkdir /mnt/pen
    sudo mount /dev/$PEN_PART /mnt/pen
    sudo cp "$LOG_FILE" /mnt/pen
    sync
    umount /mnt/pen
    log_message "Log is saved on /dev/$PEN_PART"
fi
log_message "You can restart the PC."
#!/bin/bash
#Declaration of log file and function
LOG_FILE="/var/log/erase_$(date +%Y%m%d_%H%M%S).txt"
logmsg() {
    echo -e "$1" | tee -a "$LOG_FILE"
}
clear
logmsg "=== Secure Data Eraser ==="
logmsg "Date: $(date)"
logmsg "---------------------------------------------"
logmsg "\nAvaiable drives:"

DISKS_INP=$(lsblk -n -o TYPE,NAME,MODEL,SIZE,MOUNTPOINTS) 
LIST_DISKS=$(awk -v count="0" '{
if( $1  == "disk" )
{count=count+1 
$1=""
print count, $0 
}
}' <<<"$DISKS_INP" )

DISKS_NUM=( 0 $(awk -v count="0" '{
if( $1  == "disk" )
{ 
print $2 
}
}'<<<"$DISKS_INP" ) )

logmsg "$LIST_DISKS"


echo -ne "\nWrite the number coresponding to the name of the drive you want to wipe: "
read DISK_NAME

if [[ ! "$DISK_NAME" =~ ^[0-9]+$ ]]; then
logmsg "Please use only numbers" 
exit
fi

if [ "${DISKS_NUM[$DISK_NAME]}" = "" ]; then
logmsg "There isn't a disk coresponding to this number" 
exit
fi
MOUNT_CHECK=$( awk -v CHK="${DISKS_NUM[$DISK_NAME]}" '{
if ( $1 ~ "^/dev/"CHK"([0-9]|$)" ||( CHK ~ "^nvme" && $1 ~ "^/dev/"CHK"p([0-9]|$)" )  )
{print
exit}
}' /proc/mounts )

if [[ -n $MOUNT_CHECK ]];then
logmsg "This disk is currently mounted, unmount it to continue"
exit
fi
ZRAM_CHECK=$(awk -v CHK="${DISKS_NUM[$DISK_NAME]}" 'BEGIN{
if(CHK ~ "^zram")
{print 1
exit}
}')
if [[ -n $ZRAM_CHECK ]];then
logmsg "This disk can't be erased"
exit
fi
logmsg "\nSelected drive is /dev/${DISKS_NUM[$DISK_NAME]}\nWrite ${DISKS_NUM[$DISK_NAME]} to confirm "
read DISK_CHECK
if [[ "$DISK_CHECK" != "${DISKS_NUM[$DISK_NAME]}" ]];then
logmsg "\nOperation canceled"
exit
fi

DSCRD_SP=$(cat /sys/block/"${DISKS_NUM[$DISK_NAME]}"/queue/discard_max_bytes)
if (( "$DSCRD_SP" >= 1 )); then
logmsg "This disk supports TRIM operation"
blkdiscard -fs /dev/"${DISKS_NUM[$DISK_NAME]}"   
logmsg "Data has been discarded"
exit
fi
logmsg "This disk doesn't support discard operation"
dd if=/dev/zero of=/dev/${DISKS_NUM[$DISK_NAME]} bs=1M status=progress
logmsg "Data has been discarded"



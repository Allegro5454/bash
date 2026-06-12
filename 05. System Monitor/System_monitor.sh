#!/bin/bash

#mapfile -t TASKS_ALL < <(ps aux)
while :
do
clear
COMP_UPTIME=$(uptime)
COMP_UPTIME=( $COMP_UPTIME )
COMP_UPTIME2=$( sed s"/,//" <<< "${COMP_UPTIME[2]}" )
echo "${COMP_UPTIME[0]}"
echo "Up for: $COMP_UPTIME2 minutes"
#echo "Most Resource-hungry process ${TASKS_ALL[1]}"
sleep 1;
    done
com
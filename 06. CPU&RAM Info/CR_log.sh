#!/bin/bash
CURR_USER=$(whoami)
if [ -d /home/"$CURR_USER"/INFO ]; then
:
else
mkdir /home/"$CURR_USER"/INFO
fi

while :
do
{ clear ;

mapfile -d " " COMP_TIME < <(uptime);
echo "${COMP_TIME[1]}";

mapfile -t MEM_INFO < <( free -m );
echo "${MEM_INFO[1]}";

sleep 3; 
} | tee /home/"$CURR_USER"/INFO/info.txt
done

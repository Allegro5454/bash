#!/bin/bash
CURR_USER=$(whoami)
mkdir -p /home/"$CURR_USER"/INFO
CURR_DATE=$(date | awk '{print "_"$4"_"_$3"_"_$2}' | sed s'\:\-\' | sed s'\:\-\' ) 
while :
do
 clear ;
{

uptime | awk '{print $1}'

RAM_USG=$( free -m | grep Mem: | awk '{print $3 / $2 * 100 }' )
if [ $(awk -v r="$RAM_USG" 'BEGIN { print ( r <= 80 ) }') -eq 1 ]; then
echo -e "RAM usage: $RAM_USG % "
else
echo -e "High RAM usage: $RAM_USG % "
fi

TOTAL1=$( awk -v total=0 '/cpu / { for ( i=2 ; i <= NF; i++) { total += $i } print total } ' /proc/stat )
IDLE1=$( awk '/cpu / { print $5 }' /proc/stat )

sleep 1;

TOTAL2=$( awk -v total=0 '/cpu / { for ( i=2 ; i <= NF; i++) { total += $i } print total } ' /proc/stat )
IDLE2=$( awk '/cpu / { print $5 }' /proc/stat )

DELTA_TOTAL=$( awk -v TOTAL1="$TOTAL1" -v TOTAL2="$TOTAL2" 'BEGIN { DELTA = TOTAL2 - TOTAL1 } END { print DELTA }' <<<"" )
DELTA_IDLE=$( awk -v IDLE1="$IDLE1" -v IDLE2="$IDLE2" 'BEGIN { DELTA = IDLE2 - IDLE1 } END { print DELTA}' <<< "" )

CPU_USG=$(awk -v DELTA_TOTAL="$DELTA_TOTAL" -v DELTA_IDLE="$DELTA_IDLE" 'BEGIN { CPU_USG = ( DELTA_TOTAL - DELTA_IDLE ) / DELTA_TOTAL * 100 } END { print CPU_USG }' <<<"" )

if [ $(awk -v c="$CPU_USG" 'BEGIN { print ( c <= 80 ) }') -eq 1 ] ; then
echo -e "CPU usage: $CPU_USG % "
else
echo -e "High CPU usage: $CPU_USG % "
fi

} | tee -a /home/"$CURR_USER"/INFO/info"$CURR_DATE".txt
sleep 59;
done

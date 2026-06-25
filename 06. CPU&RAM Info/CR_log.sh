#!/bin/bash
CURR_USER=$(whoami)
mkdir -p /home/"$CURR_USER"/INFO
CURR_DATE=$(date +-%m-%d-%H%M ) 
while :
do
 clear ;
{

uptime | awk '{print $1}'

awk '/MemTotal:/ {tot=$2} /MemAvailable:/ {avl=$2} END {suma = (tot - avl) / tot * 100
if ( suma<=80 ) print "Memory usage:" suma"%"; else print "High memory usage: " suma"%" }' /proc/meminfo

read tot idle < <(awk -v total=0 '/^cpu[[:space:]]/
{ for ( i=2 ; i <= NF; i++) { total += $i } 
print total, $5
exit } ' /proc/stat)
sleep 1;

awk -v tot2=0 -v tot="$tot" -v idle="$idle" '
{idle2=$5
for ( i=2 ; i <= NF; i++) { tot2 += $i }
dlt_tot= ( tot2 - tot )
dlt_idle= (idle2 - idle)
CPU_USG = (dlt_tot - dlt_idle) / dlt_tot * 100
if (CPU_USG <= 80 ) 
print "Cpu Usage: "CPU_USG"%";
else 
print "High Cpu Usage: "CPU_USG "%";
exit} ' /proc/stat
} | tee -a /home/"$CURR_USER"/INFO/info"$CURR_DATE".txt
sleep 59;
done

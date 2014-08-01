#!/bin/bash
ram_total=$(awk '/MemTotal/ {printf( "%.2f\n", $2 / 1024 )}' /proc/meminfo)
ram_free=$(awk '/MemFree/ {printf( "%.2f\n", $2 / 1024 )}' /proc/meminfo)
cpu_name=$(grep 'model name' /proc/cpuinfo | cut -d: -f2 |cut -d@ -f1 |head -1)
cpu_usage_percentage=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}')
uptime=$(uptime | grep -ohe 'up .*' | sed 's/,//g' | awk '{ print $2" "$3 }')
load_1=$(uptime | sed 's/.*load average: //' | awk -F\, '{print $1}')
load_2=$(uptime | sed 's/.*load average: //' | awk -F\, '{print $2}')
load_3=$(uptime | sed 's/.*load average: //' | awk -F\, '{print $3}')
iowait=$(iostat -c|awk '/^ /{print $4}')
ping_us=$(ping -c 1 184.105.253.14 | tail -1| awk -F '/' '{print $5}')
ping_eu=$(ping -c 1 216.66.80.30 | tail -1| awk -F '/' '{print $5}')
ping_asia=$(ping -c 1 216.218.221.42 | tail -1| awk -F '/' '{print $5}')
os_version=$(cat /etc/redhat-release)
if [ -z "$os_version" ]
	then
	os_verison=$(cat /etc/debian_version)
fi
curl --data "ram_total=$ram_total&ram_free=$ram_free&cpu_name=$cpu_name&uptime=$uptime&load_1=$load_1&load_2=$load_2&load_3=$load_3&iowait=$iowait&ping_us=$ping_us&ping_eu=$ping_eu&ping_asia=$ping_asia" http://wiki.crowncloud.net/statts/index.php

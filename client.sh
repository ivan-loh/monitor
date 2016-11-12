#!/bin/bash

server=`hostname`
apikey=<auth apikey>
endpoint=<endpoint url>

# load
load0=`cat /proc/loadavg | awk '{print $1}'`
load1=`cat /proc/loadavg | awk '{print $2}'`
load2=`cat /proc/loadavg | awk '{print $3}'`

# memory
tot=$(awk '{ if (/MemTotal:/) {print $2} }' </proc/meminfo)
free=$(awk '{ if (/MemFree:/) {print $2} }' </proc/meminfo)
pers=$(echo "scale=0; 100 - 100 * $free / $tot" | bc)

json="{\"host\": \"$server\", \"load0\": $load0, \"load1\": $load1, \"load2\": $load2, \"memory\": $pers }"

curl -k -H "Content-Type: application/json" -H "x-apikey: $apikey" -X POST -d "$json" '$endpoint' 

#!/bin/bash
#
# for use on *buntu systems.
#
# Add this to your crontab
# * * * * * bash /path/to/script/client.sh > /tmp/monitor-client.log 2> /tmp/monitor-client-error.log

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

# others
timezone=`cat /etc/timezone`
since=`uptime -s`
uptime=`uptime -p`
servertime=`date`


json="{
        \"host\": \"$server\",
        \"load0\": $load0,
        \"load1\": $load1,
        \"load2\": $load2,
        \"memory_total\": \"$tot kB\",
        \"memory_free\": \"$free kB\",
        \"memory_free\": $pers,
        \"up_since\": \"$since\",
        \"uptime\": \"$uptime\",
        \"server_time\": \"$servertime\",
        \"timezone\": \"$timezone\"
}"

curl -k -H "Content-Type: application/json" -H "x-apikey: $apikey" -X POST -d "$json" '$endpoint'

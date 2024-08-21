#!/bin/bash

time_since() {
    echo "$1 seconds ago" | awk '
    { 
        min=int($1/60); 
        hour=int(min/60); 
        day=int(hour/24); 
        min=min%60; hour=hour%24; 
        result="";
        if (day > 0) result=sprintf("%dd ", day); 
        if (hour > 0) result=sprintf("%s%dh ", result, hour); 
        result=sprintf("%s%dm", result, min);
        printf "%-10s", result;
    }'
}

time_until() {
    local future_time="$1"
    local future_epoch=$(date -d "$future_time" +"%s" 2>/dev/null)
    local current_time=$(date +"%s")
    local time_difference=$((future_epoch - current_time))
    echo "$time_difference"
}

echo -e "\nCron Job Running:"
ps -eo pid,etime,cmd | grep -v grep | grep -v "/usr/sbin/cron" | grep -v "pg_cron" | grep cron\.log

echo -e "\nLast Run Cron Jobs:"
last_runs=$(grep -i "cron" /var/log/syslog | grep CMD | tail -n 10)
current_time=$(date +"%s")

if [ -z "$last_runs" ]; then
    echo "No cron jobs found in the logs."
else
    while IFS= read -r last_run; do
        last_run_time=$(echo "$last_run" | awk '{print $1 " " $2 " " $3}' | sed 's/,/./g' | cut -d'.' -f1)
        last_run_cmd=$(echo "$last_run" | awk '{$1=$2=$3=""; print $0}' | sed 's/.*CMD //')

        last_run_epoch=$(date -d "$last_run_time" +"%s" 2>/dev/null)
        if [ $? -ne 0 ]; then
            echo "Error parsing the date: $last_run_time"
            continue
        fi

        time_difference=$((current_time - last_run_epoch))
        time_ago=$(time_since $time_difference)

        echo "$time_ago - $last_run_cmd"
    done <<< "$last_runs"
fi

echo -e "\nComing soon:"
crontab -l | grep -v '^#' | while IFS= read -r cron_job; do
    cron_schedule=$(echo "$cron_job" | awk '{print $1, $2, $3, $4, $5}')
    cron_cmd=$(echo "$cron_job" | awk '{$1=$2=$3=$4=$5=""; print $0}')

    next_run=$(crontime "$cron_schedule")
    next_run_time=$(echo "$next_run" | awk '{print $1 " " $2}')
    time_difference=$(time_until "$next_run_time")
    time_ago=$(time_since $time_difference)

    echo "$time_ago - $cron_cmd"
done

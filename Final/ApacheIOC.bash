#!/bin/bash
logfile=$1
iocfile=$2
output="report.txt"
> "$output"
while read -r ioc; do
    grep "$ioc" "$logfile" | awk '{print $1, $4, $7}' | sed 's/\[//g' >> "$output"
done < "$iocfile"

echo "Report of Apache Logs with IOC's  saved to $output"

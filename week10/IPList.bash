#!/bin/bash

[ $# -ne 1 ] && echo "Usage: $0 <Prefix>" && exit 1

prefix=$1

[ ${#prefix} -lt 5 ] && \
printf "Prefix length is too short\nPrefix Example: 10.0.17\n" && \
exit 1

for i in {1..254}
do
	ping -c 1 -W 1 -n $prefix.$i | grep "64 bytes from" | grep $prefix | \
	grep -oE "$prefix\.[0-9]+"
done

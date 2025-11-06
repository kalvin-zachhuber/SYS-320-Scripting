#!/bin/bash

file="/var/log/apache2/access.log"

cat "$file" | grep "curl" | tr -s ' ' | cut -d' ' -f1 | sort | uniq -c

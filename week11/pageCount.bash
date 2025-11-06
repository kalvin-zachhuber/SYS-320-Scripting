#!/bin/bash
cat /var/log/apache2/access.log | tr -s ' ' | cut -d' ' -f7 | grep '\.html' | sort | uniq -c

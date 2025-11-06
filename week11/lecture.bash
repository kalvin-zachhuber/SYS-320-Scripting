#!/bin/bash

file="/var/log/apache2/access.log"

grep 'page2.html' "$file" | tr -s ' '| cut -d' ' -f1,7

#!/bin/bash

url="http://10.0.17.47/IOC.html"
output="IOC.txt"
curl -s "$url" | grep -oP '(?<=<td>)[^<]+' | sed -n '1~2p' > "$output"

echo "IOCs from $url saved to $output"

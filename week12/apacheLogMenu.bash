#! /bin/bash

logFile="/var/log/apache2/access.log"
iocFile="ioc.txt"

function displayAllLogs(){
cat "$logFile"
}

function displayOnlyIPs(){
        cat "$logFile" | cut -d ' ' -f 1 | sort -n | uniq -c
}

# function: displayOnlyPages:
# like displayOnlyIPs - but only pages
function displayOnlyPages(){
        echo "Displaying only pages visited:"
        cat "$logFile" | awk '{print $7}' | sort | uniq -c | sort -nr
}

function histogram(){
local visitsPerDay=$(cat "$logFile" | cut -d " " -f 4,1 | tr -d '['  | sort \
                              | uniq)
# This is for debugging, print here to see what it does to continue:
# echo "$visitsPerDay"

        :> newtemp.txt  # what :> does is in slides
echo "$visitsPerDay" | while read -r line;
do
local withoutHours=$(echo "$line" | cut -d " " -f 2 \
                                     | cut -d ":" -f 1)
local IP=$(echo "$line" | cut -d  " " -f 1)
         
local newLine="$IP $withoutHours"
echo "$IP $withoutHours" >> newtemp.txt
done
cat "newtemp.txt" | sort -n | uniq -c
}

# function: frequentVisitors:
# Only display the IPs that have more than 10 visits
# You can either call histogram and process the results,
# Or make a whole new function.
function frequentVisitors(){
        echo "Frequent Visitors:"
        :> freqtemp.txt
        cat "$logFile" | awk '{print $1, $4}' | tr -d '[' | cut -d ":" -f 1 \
                | sort | uniq -c > freqtemp.txt
        awk '$1 > 10 {print $0}' freqtemp.txt
}

# function: suspiciousVisitors
# Manually make a list of indicators of attack (ioc.txt)
# filter the records with these indicators of attack
# only display the unique count of IP addresses.  
function suspiciousVisitors(){
        echo "Suspicious Visitors:"
        :> suspiciousTemp.txt
        while read -r indicator;
        do
                grep "$indicator" "$logFile" | awk '{print $1}' >> suspiciousTemp.txt
        done < "$iocFile"
        sort suspiciousTemp.txt | uniq -c | sort -nr
}


while :
do
echo "PLease select an option:"
echo "[1] Display all Logs"
echo "[2] Display only IPS"
echo "[3] Display only Pages"
echo "[4] Histogram"
echo "[5] Frequent Visitors"
echo "[6] Suspicious Visitors"
echo "[7] Quit"

read userInput
echo ""

if [[ "$userInput" == "7" ]]; then
echo "Goodbye"
break

elif [[ "$userInput" == "1" ]]; then
echo "Displaying all logs:"
displayAllLogs

elif [[ "$userInput" == "2" ]]; then
echo "Displaying only IPS:"
displayOnlyIPs

elif [[ "$userInput" == "3" ]]; then
displayOnlyPages

elif [[ "$userInput" == "4" ]]; then
echo "Histogram:"
histogram

elif [[ "$userInput" == "5" ]]; then
frequentVisitors

elif [[ "$userInput" == "6" ]]; then
suspiciousVisitors

else
echo "Invalid option! Please select a valid number between 1 and 7."
fi
done

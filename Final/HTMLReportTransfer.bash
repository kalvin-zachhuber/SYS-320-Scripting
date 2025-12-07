#!/bin/bash

report_txt="/home/champuser/SYS-320-Scripting/Final/report.txt"
report_html="/home/champuser/SYS-320-Scripting/Final/report.html"
web_dir="/var/www/html"

{
echo "<html>"
echo "<body>"
echo "<h3>Access logs with IOC indicators:</h3>"
echo "<table border='1'>"

while read -r line; do
    echo "<tr><td>${line// /</td><td>}</td></tr>"
done < "$report_txt"

echo "</table>"
echo "</body>"
echo "</html>"
} > "$report_html"

sudo mv "$report_html" "$web_dir/"

echo "Report file has been moved to HTML at: $web_dir/report.html"

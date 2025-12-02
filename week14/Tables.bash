#!/bin/bash

link="http://10.0.17.47/Assignment.html"

fullPage=$(curl -s "$link")

formattedPage=$(echo "$fullPage" | xmlstarlet format --html --recover 2>/dev/null)

# Temperatures (table id="temp", column 1)
temps=$(echo "$formattedPage" | \
  xmlstarlet select -t -m '//table[@id="temp"]//tr[position()>1]' \
  -v 'td[1]' -n)

# Dates (table id="temp", column 2)
dates=$(echo "$formattedPage" | \
  xmlstarlet select -t -m '//table[@id="temp"]//tr[position()>1]' \
  -v 'td[2]' -n)

# Pressures (table id="press", column 1)
pressures=$(echo "$formattedPage" | \
  xmlstarlet select -t -m '//table[@id="press"]//tr[position()>1]' \
  -v 'td[1]' -n)

rows=$(echo "$temps" | wc -l)

for ((i=1; i<=rows; i++)); do
  temp=$(echo "$temps" | sed -n "${i}p")
  date=$(echo "$dates" | sed -n "${i}p")
  pres=$(echo "$pressures" | sed -n "${i}p")
  echo "$pres $temp $date"
done

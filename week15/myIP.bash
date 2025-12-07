ip -4 -o addr show up scope global | awk '{print $4}' | cut -d/ -f1

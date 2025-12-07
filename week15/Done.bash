#!/bin/bash

myIP=$(bash myIP.bash)

# Todo-1: Create a helpmenu function that prints help for the script
helpmenu() {
  echo "Usage:"
  echo "  $(basename "$0") -n {internal|external}"
  echo "  $(basename "$0") -s {internal|external}"
  echo
  echo "Options:"
  echo "  -n    Use nmap to list open ports"
  echo "  -s    Use ss to list listening ports"
  echo
  echo "Arguments:"
  echo "  internal   Show services listening on localhost (127.0.0.1)"
  echo "  external   Show services listening on the network (${myIP})"
  echo
  echo "Examples:"
  echo "  $(basename "$0") -n external"
  echo "  $(basename "$0") -n internal"
  echo "  $(basename "$0") -s external"
  echo "  $(basename "$0") -s internal"
}

# Return ports that are serving to the network (nmap on myIP)
ExternalNmap() {
  echo "Nmap scan against ${myIP}:"
  nmap "$myIP" | awk '/^[0-9]+\/tcp/ {print $1, $3}'
}

# Return ports that are serving to localhost (nmap on localhost)
InternalNmap() {
  echo "Nmap scan against localhost:"
  nmap localhost | awk '/^[0-9]+\/tcp/ {print $1, $3}'
}

# Only IPv4 ports listening from network (non-localhost) using ss
ExternalListeningPorts() {
  echo "Ports listening externally (ss):"
  ss -tulpn | awk '$1=="LISTEN" && $5 !~ /127\.0\.0\.1/ {print $5, $7}'
}

# Only IPv4 ports listening from localhost using ss
InternalListeningPorts() {
  echo "Ports listening on localhost (ss):"
  ss -tulpn | awk '$1=="LISTEN" && $5 ~ /127\.0\.0\.1/ {print $5, $7}'
}

# Todo-3: If the program is not taking exactly 2 arguments, print helpmenu
if [ "$#" -ne 2 ]; then
  echo "Error: this script expects exactly 2 arguments."
  helpmenu
  exit 1
fi

# Todo-4: Use getopts to accept options -n and -s (both will have an argument)
while getopts ":n:s:" opt; do
  case "$opt" in
    n)
      case "$OPTARG" in
        internal)
          InternalNmap
          ;;
        external)
          ExternalNmap
          ;;
        *)
          echo "Error: -n needs 'internal' or 'external'."
          helpmenu
          exit 1
          ;;
      esac
      ;;
    s)
      case "$OPTARG" in
        internal)
          InternalListeningPorts
          ;;
        external)
          ExternalListeningPorts
          ;;
        *)
          echo "Error: -s needs 'internal' or 'external'."
          helpmenu
          exit 1
          ;;
      esac
      ;;
    \?)
      echo "Error: invalid option '-$OPTARG'."
      helpmenu
      exit 1
      ;;
    :)
      echo "Error: option '-$OPTARG' requires an argument."
      helpmenu
      exit 1
      ;;
  esac
done

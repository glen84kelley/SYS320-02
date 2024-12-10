#!/bin/bash

myIP=$(bash myIP2.bash)


# Todo-1: Create a helpmenu function that prints help for the script
function helpMenu(){
echo "   HELP MENU"
echo "-------------"
echo "-n: Add -n as an argument for this script to use nmap"
echo " -n external: External NMAP scan"
echo " -n internal: Internal NMAP scan"
echo "-s: Add -s as an argument for this script to use ss"
echo " -s external: External ss(Netstat) scan"
echo " -s internal: Internal ss(Netstat) scan"
echo "Usage: bash networkchecker.bash -n/-s external/internal"
echo "-------------"
}

# Return ports that are serving to the network
function ExternalNmap(){
  rex=$(nmap "${myIP}" | awk -F"[/[:space:]]+" '/open/ {print $1,$4}' )
  echo "External Nmap Result: $rex"
}

# Return ports that are serving to localhost
function InternalNmap(){
  rin=$(nmap localhost | awk -F"[/[:space:]]+" '/open/ {print $1,$4}' )
  echo "Internal Nmap Result: $rin"
}


# Only IPv4 ports listening from network
function ExternalListeningPorts(){

# Todo-2: Complete the ExternalListeningPorts that will print the port and application
# that is listening on that port from network (using ss utility)
  ss -tuln | awk 'NR>1 {if ($4 == "0.0.0.0" || $4 == "::" || $4 !~ /^127\./) print $4, $5}'
}


# Only IPv4 ports listening from localhost
function InternalListeningPorts(){
  ilpo=$(ss -ltpn | awk  -F"[[:space:]:(),]+" '/127.0.0./ {print $5,$9}' | tr -d "\"")
  echo "internal listening ports: $ilpo"
}



# Todo-3: If the program is not taking exactly 2 arguments, print helpmenu
if [ $# -ne 2 ]; then
  helpMenu
  exit 1
fi
# Todo-4: Use getopts to accept options -n and -s (both will have an argument)
# If the argument is not internal or external, call helpmenu
# If an option other then -n or -s is given, call helpmenu
# If the options and arguments are given correctly, call corresponding functions
# For instance: -n internal => will call NMAP on localhost
#               -s external => will call ss on network (non-local)

while getopts "n:s:" option; do
  case $option in
    n)
      if [[ "$OPTARG" == "internal" ]]; then
        InternalNmap
      elif [[ "$OPTARG" == "external" ]]; then
        ExternalNmap
      else
        helpMenu
      fi
      ;;
    s)

      if [[ "$OPTARG" == "internal" ]]; then
        InternalListeningPorts
      elif [[ "$OPTARG" == "external" ]]; then
        ExternalListeningPorts
      else
        helpMenu
      fi
      ;;
    *)
      helpMenu
      ;;
  esac
done


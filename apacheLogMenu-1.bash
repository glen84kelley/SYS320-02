#! /bin/bash

logFile="/var/log/apache2/access.log.1"

function displayAllLogs(){
	cat "$logFile"
}

function displayOnlyIPs(){
        cat "$logFile" | cut -d ' ' -f 1 | sort -n | uniq -c
}

# function: displayOnlyPages:
# like displayOnlyIPs - but only pages
function displayOnlyPages()
{
	cat "$logFile" | cut -d ' ' -f 7 | sort | uniq -c
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
# Call histogram and process the results
# Do not forget to separate the 
# number and check with a condition whether it is greater than 10
# the output should be almost identical to histogram
# only with daily number of visits that are greater than 10 
function frequentVisitors()
{
	local result=$(histogram)

	echo "$result" | while read -r count ipWithoutHour; do
		local ip=$(echo "$ipWithoutHour" | cut -d " " -f 1)
		local hour=$(echo "ipWithoutHour" | cut -d " " -f 2)

		if [ "$count" -gt 10 ]; then
			echo "$count $ip $hour"
		fi
	done
}


# function: suspiciousVisitors
# Manually make a list of indicators of attack (ioc.txt)
# filter the records with this indicators of attack
# only display the unique count of IP addresses.  
# Hint: there are examples in slides
function suspiciousVisitors()
{
	local iocFile="ioc.txt"

	if [ ! -f "$iocFile" ]; then
		echo "IOC file ($iocFile) not found!"
		return 1
	fi

	local iocs=($(cat "$iocFile"))

	local suspiciousLog="suspiciousLogs.txt"
	> "$suspiciousLog"

	for ioc in "${iocs[@]}"; do
		grep -i "$ioc" "$logFile" >> "$suspiciousLog"
	done

	local suspiciousIPs=$(cut -d " " -f 1 "$suspiciousLog" | sort | uniq)

	local count=$(echo "$suspiciousIPs" | wc -l)
	echo "Number of unique suspicious IP addresses: $count"

	echo "Suspicious IPs:"
	echo "$suspiciousIPs"
}
# Keep in mind that I have selected long way of doing things to 
# demonstrate loops, functions, etc. If you can do things simpler,
# it is welcomed.

while :
do
	echo "PLease select an option:"
	echo "[1] Display all Logs"
	echo "[2] Display only IPS"
	# Display only pages visited
	echo "[4] Histogram"
	# Frequent visitors
	# Suspicious visitors
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

	# Display only pages visited
	elif [[ "$userInput" == "3" ]]; then
		echo "Displaying only Pages:"
		displayOnlyPages

	elif [[ "$userInput" == "4" ]]; then
		echo "Histogram:"
		histogram

        # Display frequent visitors
	elif [[ "$userInput" == "5" ]]; then
		echo "Frequent Visitors:"
		frequentVisitors
	# Display suspicious visitors
	elif [[ "$userInput" == "6" ]]; then
		echo "Suspicious Visitors:"
		suspiciousVisitors
	# Display a message, if an invalid input is given
	else
		echo "Invalid Input"
	fi
done


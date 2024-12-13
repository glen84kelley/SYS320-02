link="http://10.0.17.6/IOC-1.html"
logFile="access.log"

ioc=$(curl -sL "$link" | \
xmlstarlet select --template --value-of "//table//tr//td" | \
awk 'NR % 2 == 1')

for var1 in $ioc;
do
grep -i "$var1" "$logFile" | \
awk '{print $1, $4, $7}' >> report.txt
done

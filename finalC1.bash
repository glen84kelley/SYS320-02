
link="http://10.0.17.6/IOC-1.html"

ioc=$(curl -sL "$link" | \
xmlstarlet select --template --value-of "//table//tr//td" | \
awk 'NR % 2 == 1')

cnt=$(echo "$ioc" | wc -l)
for (( i=1; i<="${cnt}"; i++ ))
do
var1=$(echo "$ioc" | head -n $i | tail -n 1)
echo "$var1" >> IOC.txt
done


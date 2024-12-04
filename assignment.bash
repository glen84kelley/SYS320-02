link="http://10.0.17.30/Assignment.html" 

#sets dateTime equal to the values of the temp table that are on an even line (date/time section)
dateTime=$(curl -sL "$link" | \
xmlstarlet select --template --value-of "//table[@id='temp']//tr//td" | \
awk 'NR % 2 == 0')

#sets temp equal to the values of the temp table on the odd lines (temperature)
temp=$(curl -sL "$link" | \
xmlstarlet select --template --value-of "//table[@id='temp']//tr//td" | \
awk 'NR % 2 == 1')

#sets press equal to the values of the press table on the odd lines (pressure)
press=$(curl -sL "$link" | \
xmlstarlet select --template --value-of "//table[@id='press']//tr//td" | \
awk 'NR % 2 == 1')
#count of the elements in press (luckily it can be representative of the count of the other variables
cnt=$(echo "$press" | wc -l)
for (( i=1; i<="${cnt}"; i++ ))
do
#sets the variable equal to the ith line of the table (tail is for it to end at that line)
var1=$(echo "$press" | head -n $i | tail -n 1)
var2=$(echo "$temp" | head -n $i | tail -n 1)
var3=$(echo "$dateTime" | head -n $i | tail -n 1)
echo "$var1 $var2 $var3"
done


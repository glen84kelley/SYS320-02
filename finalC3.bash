inFile="report.txt"
outFile="report.html"

echo "<html>" > "$outFile"
echo "<body>" >> "$outFile"
echo "<table>" >> "$outFile"
while IFS= read -r line
do
fields=($line)

if [ ${#fields[@]} -ge 6 ]; 
then
echo "<tr><td>${fields[0]}</td><td>${fields[3]}</td><td>${fields[5]}</td></tr>" >> "$outFile"
fi
done < "$inFile"
echo "</table>" >> "$outFile"
echo "</body>" >> "$outFile"
echo "</html>" >> "$outFile"

sudo mv "$outFile" //var/www/html/
#I cannot figure out why this won't run!!!!!!!!


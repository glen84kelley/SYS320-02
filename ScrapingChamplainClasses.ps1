function gatherClasses(){

$page = Invoke-WebRequest -TimeoutSec 2 http://localhost/Courses.html

# Get all the tr elements of HTML document
$trs=$page.ParsedHtml.body.getElementsByTagName("tr")

# Empty array to hold results
$FullTable = @()
for($i=1; $i -lt $trs.length; $i++){ # Going over every tr element

    # Get every td element of current tr element
    $tds = $trs[$i].getElementsByTagName("td")
    

    # Want to separate start time and end time from one time field
    $Times = $tds[5].innerText.Split("-")

    $FullTable += [pscustomobject]@{"Class Code" = $tds[0].innerText;
                                    "Title" = $tds[1].innerText;
                                    "Days" = $tds[4].innerText;
                                    "Time Start" = $Times[0];
                                    "Time End" = $Times[1];
                                    "Instructor" = $tds[6].innerText;
                                    "Location" = $tds[9].innerText;

}

}
return $FullTable
}


function daysTranslator($FullTable){

#go over every record in the table
for($i=0; $i -lt $FullTable.length; $i++){
# Empty array to hold days for every record
$Days =@()

# If you see "M" -> Monday
if($FullTable[$i].Days -ilike "M*"){ $Days += "Monday" }

#If you see "T" followed by T,W, or F -> Tuesday
if($FullTable[$i].Days -ilike "*T*[TWF]*"){ $Days += "Tuesday" }
ElseIf($FullTable[$i].Days -ilike "T"){ $Days += "Tuesday" }

# If you see "W" -> Wednesday
if($FullTable[$i].Days -ilike "*W"){ $Days += "Wednesday" }

# If you see "TH" -> Thursday
if($FullTable[$i].Days -ilike "*TH"){ $Days += "Thursday" }

# If you see "W" -> Friday
if($FullTable[$i].Days -ilike "*F"){ $Days += "Friday" }

# Make the switch
$FullTable[$i].Days = $Days -join ', '
}

return $FullTable
}
$classes = gatherClasses
$translatedClasses = daysTranslator $classes

#$translatedClasses

# List all the classes of Instructor Furkan Paligu
#$translatedClasses | Select-Object "Class Code", Instructor, Location, Days, "Time Start", "Time End" | Where-Object { $_.Instructor -eq "Furkan Paligu" }

# List all the classes of JOYC 310 on Mondays, only display Class Code and Times
# Sort by Start Time
#$translatedClasses | Where-Object { ($_.Location -ilike "JOYC 310") -and ($_.Days -contains "Monday") } | `
 #      Sort-Object "Time Start" | Select-Object "Time Start", "Time End", "Class Code"

# Make a list of all the instructors that teach at least 1 course in
# SYS, SEC, NET, FOR, CSI, DAT
# Sort by name, and make it unique
$ITSInstructors = $translatedClasses | Where-Object {($_."Class Code" -ilike "SYS*") -or `
                                                      ($_."Class Code" -ilike "NET*") -or `
                                                      ($_."Class Code" -ilike "SEC*") -or `
                                                      ($_."Class Code" -ilike "FOR*") -or `
                                                      ($_."Class Code" -ilike "CSI*") -or `
                                                      ($_."Class Code" -ilike "DAT*") } `
                                                      | Select-Object "Instructor" `
                                                      | Sort-Object "Instructor" -Unique
$ITSInstructors

# Group all the instructors by the number of classes they are teaching
            
#I COULD NOT FOR THE LIFE OF ME GET THIS!
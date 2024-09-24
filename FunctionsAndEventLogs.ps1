Add-Type -AssemblyName System.Security

function logsForLastNDays
{
param (
[int]$n
)


#Get login and logoff records from windows events and save to a variable
#Get the last n days
$loginouts = Get-EventLog System -Source Microsoft-Windows-Winlogon -After (Get-Date).AddDays(-$n)




$loginoutsTable = @() # Empty array to fill customly
for ($i = 0; $i -lt $loginouts.Count; $i++) {
    # Creating event property value
    $event = ""
    if ($loginouts[$i].InstanceId -eq 7001) { $event = "Logon" }
    elseif ($loginouts[$i].InstanceId -eq 7002) { $event = "Logoff" }

    
    $userSid = $loginouts[$i].ReplacementStrings[1]
    $user = ""

    try {
        $sid = New-Object System.Security.Principal.SecurityIdentifier($userSid)
        $user = $sid.Translate([System.Security.Principal.NTAccount]).Value
    } catch {
        $user = "Unknown"
    }

    # Adding each new line (in form of a custom object) to our empty array
    $loginoutsTable += [pscustomobject]@{
        "Time"  = $loginouts[$i].TimeGenerated
        "Id"    = $loginouts[$i].InstanceId
        "Event" = $event
        "User"  = $user
    }
}

$loginoutsTable

}
logsForLastNDays -n 7


function computerStartStop
{
param (
[int]$n
)

#Get records from windows events and save to a variable
#Get the last n days
$startstops = Get-EventLog System -Source EventLog -After (Get-Date).AddDays(-$n) | Where-Object { $_.EventID -eq 6005 -or $_.EventID -eq 6006 } 




$startstopsTable = @() # Empty array to fill customly
for ($i = 0; $i -lt $startstops.Count; $i++) {
    # Creating event property value
    $event = ""
    if ($startstops[$i].EventID -eq 6005) { $event = "Start" }
    elseif ($startstops[$i].EventID -eq 6006) { $event = "ShutDown" }

    

    $user = "System"


    # Adding each new line (in form of a custom object) to our empty array
    $startstopsTable += [pscustomobject]@{
        "Time"  = $startstops[$i].TimeGenerated
        "Id"    = $startstops[$i].EventID
        "Event" = $event
        "User"  = $user
    }
}

$startstopsTable

}
computerStartStop -n 200
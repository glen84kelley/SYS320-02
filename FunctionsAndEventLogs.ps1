# Get login and logoff records from windows events.
Get-EventLog System -Source Microsoft-Windows-Winlogon

#Get login and logoff records from windows events and save to a variable
#Get the last 14 days
$loginouts = Get-EventLog System -Source Microsoft-Windows-Winlogon -After (Get-Date).AddDays(-14)


Add-Type -AssemblyName System.Security

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
        "User"  = $userName
    }
}

$loginoutsTable



function Show-Menu {
    Clear-Host
    Write-Host "Please choose an option:"
    Write-Host "1. Display last 10 Apache logs"
    Write-Host "2. Display last 10 failed logins for all users"
    Write-Host "3. Display at risk users"
    Write-Host "4. Start Chrome web browser and navigate to champlain.edu"
    Write-Host "5. Exit"
}

function Get-UserChoice {
    $choice = Read-Host "Enter your choice (1-5)"
    
    while ($choice -lt 1 -or $choice -gt 5) {
        Write-Host "Invalid choice. Try again..."
        $choice = Read-Host "Enter your choice (1-5)"
    }
    
    return $choice
}

do {
    Show-Menu
    $userChoice = Get-UserChoice

    switch ($userChoice) {
        1 {
            # Call the function to display last 10 Apache logs
            function ApacheLogs1(){
$logsNotFormatted = Get-Content C:\xampp\apache\logs\access.log -Tail 10
$tableRecords = @()

for($i=0; $i -lt $logsNotFormatted.Count; $i++){
# split a string into words
$words = $logsNotFormatted[$i].Split(" ");
$tableRecords += [pscustomobject]@{ "IP" = $words[0];
                                    "Time" = $words[3].Trim('[');
                                    "Method" = $words[5].Trim('"');
                                    "Page" = $words[6];
                                    "Protocol" = $words[7];
                                    "Response" = $words[8];
                                    "Referrer" = $words[10];
                                    "Client" = $words[11..($words.Count - 1)]; }


}
return $tableRecords | Where-Object { $_.IP -match "10.*" }
}
$tableRecords = ApacheLogs1
$tableRecords | Format-Table -AutoSize -Wrap
        }
        2 {
            function getFailedLogins {
    $failedlogins = Get-EventLog security | Where { $_.InstanceID -eq 4625 }

    $failedloginsTable = @()

    foreach ($log in $failedlogins) {
        $usrlines = getMatchingLines $log.Message "*Account Name*"
        $usr = $usrlines[1].Split(":")[1].Trim()

        $dmnlines = getMatchingLines $log.Message "*Account Domain*"
        $dmn = $dmnlines[1].Split(":")[1].Trim()

        $user = "$dmn\$usr"

        $failedloginsTable += [pscustomobject]@{
            "Time" = $log.TimeGenerated
            "Id" = $log.InstanceId
            "Event" = "Failed"
            "User" = $user
        }
    }

    # Sort by TimeGenerated in descending order and take the last 10 entries
    return $failedloginsTable | Sort-Object Time -Descending | Select-Object -First 10
}

            getFailedLogins
        }
        3 {
            Write-Host "Oops i think i missed that one..."
            }
        4 {
            
            if(!(Get-Process -Name chrome))
{
    Start-Process 'C:\Program Files\Google\Chrome\Application\chrome.exe' -ArgumentList '--start-fullscreen', 'https://www.champlain.edu/'
} else {
                Write-Host "Chrome is already running."
            }
        }
        5 {
            Write-Host "Exiting menu. cya!"
        }
        default {
            Write-Host "Bro you gotta choose 1-5"
        }
    }

    if ($userChoice -ne 5) {
        Read-Host "Press Enter to continue..."
    }

} while ($userChoice -ne 5)

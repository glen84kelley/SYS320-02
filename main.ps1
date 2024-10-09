. (Join-Path $PSScriptRoot "Users.ps1")
. (Join-Path $PSScriptRoot "Event-Logs.ps1")
. (Join-Path $PSScriptRoot "String-Helper.ps1")

Clear-Host

$Prompt = "`n"
$Prompt += "Please choose your operation:`n"
$Prompt += "1 - List Enabled Users`n"
$Prompt += "2 - List Disabled Users`n"
$Prompt += "3 - Create a User`n"
$Prompt += "4 - Remove a User`n"
$Prompt += "5 - Enable a User`n"
$Prompt += "6 - Disable a User`n"
$Prompt += "7 - Get Log-In Logs`n"
$Prompt += "8 - Get Failed Log-In Logs`n"
$Prompt += "9 - Exit`n"
$Prompt += "10 - List at Risk Users`n"


$operation=$true

while ($operation) {
    Write-Host $Prompt
    $choice = Read-Host 

    while($operation){

    
    Write-Host $Prompt | Out-String
    $choice = Read-Host 


    if($choice -eq 9){
        Write-Host "Goodbye" | Out-String
        exit
        $operation = $false 
    }

    elseif($choice -eq 1){
        $enabledUsers = getEnabledUsers
        Write-Host ($enabledUsers | Format-Table | Out-String)
    }

    elseif($choice -eq 2){
        $notEnabledUsers = getNotEnabledUsers
        Write-Host ($notEnabledUsers | Format-Table | Out-String)
    }


    # Create a user
    elseif($choice -eq 3){ 

            $name = Read-Host -Prompt "Please enter the username for the new user"
            $password = Read-Host -AsSecureString -Prompt "Please enter the password for the new user"

            if (checkUser $name) {
                Write-Host "User $name already exists."
                continue
            }

            if (-not (checkPassword $password)) {
                Write-Host "Password does not meet complexity requirements."
                continue
            }

            createAUser $name $password
            Write-Host "User: $name is created." | Out-String
        }
         # Remove a user
    elseif($choice -eq 4){

        $name = Read-Host -Prompt "Please enter the username for the user to be removed"


            if (-not (checkUser $name)) {
                Write-Host "User $name does not exist."
                continue
            }

            removeAUser $name
           Write-Host "User: $name Removed." | Out-String
        }


    # Enable a user
    elseif($choice -eq 5){

            $name = Read-Host -Prompt "Please enter the username for the user to be enabled"

            if (-not (checkUser $name)) {
                Write-Host "User $name does not exist."
                continue
            }

            enableAUser $name
             Write-Host "User: $name Enabled." | Out-String
    }


    # Disable a user
    elseif($choice -eq 6){

        $name = Read-Host -Prompt "Please enter the username for the user to be disabled"


            if (-not (checkUser $name)) {
                Write-Host "User $name does not exist."
                continue
            }

            disableAUser $name
             Write-Host "User: $name Disabled." | Out-String
    }


    elseif($choice -eq 7){

        $name = Read-Host -Prompt "Please enter the username for the user logs"


            if (-not (checkUser $name)) {
                Write-Host "User $name does not exist."
                continue
            }

            $days = Read-Host -Prompt "Please enter the number of days for logs"
            $userLogins = getLogInAndOffs $days

            Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String)
    }


    elseif($choice -eq 8){

        $name = Read-Host -Prompt "Please enter the username for the user's failed login logs"


            if (-not (checkUser $name)) {
                Write-Host "User $name does not exist."
                continue
            }

            $days = Read-Host -Prompt "Please enter the number of days for logs"
            $userLogins = getFailedLogins $days

            Write-Host ($userLogins | Where-Object { $_.User -ilike "*$name"} | Format-Table | Out-String)
        }
     elseif($choice -eq 10){

            $days = Read-Host -Prompt "Please enter the number of days to check for at-risk users"
            $atRiskUsers = getAtRiskUsers $days
            Write-Host ($atRiskUsers | Format-Table | Out-String)
        }
        
        else {
            Write-Host "Invalid choice. Please select a valid option from the menu."
        }
    }
}

function checkUser($username) {
    $allUsers = getEnabledUsers + getNotEnabledUsers
    return $allUsers.Name -contains $username
}

function checkPassword($password) {
    if ($password.Length -lt 6) { return $false }
    if ($password -notmatch '[a-zA-Z]') { return $false }
    if ($password -notmatch '\d') { return $false }
    if ($password -notmatch '[!@#$%^&*()]') { return $false }
    return $true
}

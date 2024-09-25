function Who-Visited {
    param(
        [string]$Page,
        [int]$HttpCode,
        [string]$BrowserName
    )

    $regex = [regex] "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"

    $baseInfo = Get-Content C:\xampp\apache\logs\access.log 
    $fullTable =@()

    for($i=0; $i -lt $baseInfo.Count; $i++){

    $pieces = $baseInfo[$i].Split(" ");

    $fullTable += [pscustomobject]@{ "IP" = $pieces[0];
                                     "Page" = $pieces[6];
                                     "Code" = $pieces[8];
                                     "Browser" = $pieces[21];


    }
    }
    return $fullTable | Where-Object { ($_.IP -match $regex) -and ($_.Page -ilike $Page) -and ($_.Code -ilike $HttpCode) -and ($_.Browser -ilike $BrowserName) }
    }
    

    #Get-Content C:\xampp\apache\logs\access.log 
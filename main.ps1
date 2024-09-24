. (Join-Path $PSScriptRoot 'FunctionsAndEventLogs.ps1')

clear

#Get Login and Logoffs from the last 15 days
$loginoutsTable = logsForLastNDays -n 15
$loginoutsTable

#Get startup and shutdowns from the last 25 days
$startstopsTable = computerStartStop -n 25
$startstopsTable
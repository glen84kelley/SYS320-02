.(Join-Path $PSScriptRoot "Apache-Logs.ps1")
$call = Who-Visited -Page "/index.html" -HttpCode 200 -BrowserName "Chrome*"

$call
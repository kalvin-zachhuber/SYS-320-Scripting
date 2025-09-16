. (Join-Path $PSScriptRoot 'PCStartFunction.ps1')
. (Join-Path $PSScriptRoot 'LogonFunction.ps1')

clear

# Get Login and Logoffs from the last 15 days
$loginoutsTable = LogonFunction -Days 15
$loginoutsTable

# Get Shut Downs from the last 25 days
$shutdownsTable = PCStartFunction -Days 25
$shutdownsTable

# Get Start Ups from the last 25 days
$startupsTable = PCStartFunction -Days 25
$startupsTable



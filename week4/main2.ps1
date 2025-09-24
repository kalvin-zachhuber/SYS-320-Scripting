param(
    [string]$Page,
    [int]$Status,
    [string]$Browser
)

. "$PSScriptRoot\Apache-Logs.ps1"     # dot-source the function

Get-ApacheIPs -Page $Page -Status $Status -Browser $Browser |
    Group-Object | Sort-Object Count -Descending |
    Select-Object Count, Name
. "$PSScriptRoot\PARSINGAPACHELOGS.ps1"

$tableRecords = ApacheLogs1
$tableRecords | Format-Table -AutoSize -Wrap
param(
    [string]$Page,
    [int]$Status,
    [string]$Browser
)

. "$PSScriptRoot\Apache-Logs.ps1"     # dot-source the function

Get-ApacheIPs -Page $Page -Status $Status -Browser $Browser |
    Group-Object | Sort-Object Count -Descending |
    Select-Object Count, Name

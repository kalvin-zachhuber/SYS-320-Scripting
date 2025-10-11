. (Join-Path $PSScriptRoot 'String-Helper.ps1')
. (Join-Path $PSScriptRoot 'Event-Logs.ps1')
. (Join-Path $PSScriptRoot 'Users.ps1')
. (Join-Path $PSScriptRoot 'apachelogparser.ps1')

function Show-Menu {
    Clear-Host
    Write-Host ""
    Write-Host "Please choose an operation:" -ForegroundColor Cyan
    Write-Host "1 - Display last 10 apache logs (uses ApacheLogs1)"
    Write-Host "2 - Display last 10 failed logins for all users (uses getFailedLogins)"
    Write-Host "3 - Display at risk users (>10 failed logins in 30 days)"
    Write-Host "4 - Start Chrome and navigate to champlain.edu (only if Chrome is not running)"
    Write-Host "5 - Exit"
    Write-Host ""
}

function Read-Choice {
    while ($true) {
        $raw = Read-Host "Enter your choice (1-5)"
        if ($raw -match '^[1-5]$') { return [int]$raw }
        Write-Warning "Invalid selection. Please enter a number between 1 and 5."
    }
}

function Show-Last10ApacheLogs {
    try {
        $out = ApacheLogs1
        if ($null -eq $out) { return }
        if ($out -is [string]) {
            $out = $out -split "`r?`n" | Where-Object { $_ -and ($_ -notmatch '^\s*$') }
        }
        $out | Select-Object -Last 10 | Format-Table -AutoSize
    } catch { Write-Error $_ }
}

function Show-Last10FailedLogins {
    try {
        $failed = getFailedLogins 30
        if ($failed) {
            $failed | Sort-Object Time -Descending | Select-Object -First 10 | Format-Table -AutoSize
        }
    } catch { Write-Error $_ }
}

function Show-AtRiskUsers {
    try {
        $failed = getFailedLogins 30
        if ($failed) {
            $failed |
                Group-Object User |
                Where-Object { $_.Count -gt 10 } |
                Select-Object @{n='Count';e={$_.Count}}, @{n='User';e={$_.Name}} |
                Sort-Object Count -Descending |
                Format-Table -AutoSize
        }
    } catch { Write-Error $_ }
}

function Ensure-ChromeToChamplain {
    try {
        if (-not (Get-Process -Name chrome -ErrorAction SilentlyContinue)) {
            $cands = @(
                "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
                "$env:ProgramFiles(x86)\Google\Chrome\Application\chrome.exe"
            )
            $exe = $cands | Where-Object { Test-Path $_ } | Select-Object -First 1
            if ($exe) { Start-Process -FilePath $exe -ArgumentList 'https://www.champlain.edu' }
            else { Start-Process 'https://www.champlain.edu' }
        }
    } catch { Write-Error $_ }
}

do {
    Show-Menu
    $choice = Read-Choice
    switch ($choice) {
        1 { Show-Last10ApacheLogs }
        2 { Show-Last10FailedLogins }
        3 { Show-AtRiskUsers }
        4 { Ensure-ChromeToChamplain }
        5 { Write-Host "Exiting... Goodbye!" -ForegroundColor Cyan }
    }
    if ($choice -ne 5) { Write-Host ""; Read-Host "Press Enter to return to the menu" }
} while ($choice -ne 5)

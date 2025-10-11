. (Join-Path $PSScriptRoot Users.ps1)
. (Join-Path $PSScriptRoot Event-Logs.ps1)

Clear-Host

# Build prompt
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
$Prompt += "9 - List At-Risk Users ( >10 failed logins )`n"
$Prompt += "10 - Exit`n"

function Read-MenuChoice {
    param([int]$Min = 1, [int]$Max = 10)
    $raw = Read-Host "Enter your choice"
    if (-not ($raw -as [int])) { return $null }
    $n = [int]$raw
    if ($n -lt $Min -or $n -gt $Max) { return $null }
    return $n
}

# Use helper if available, otherwise fallback to native cmds
function _GetEnabledUsers {
    if (Get-Command getEnabledUsers -ErrorAction SilentlyContinue) {
        return getEnabledUsers
    } else {
        return (Get-LocalUser | Where-Object Enabled | Select-Object Name, SID)
    }
}
function _GetDisabledUsers {
    if (Get-Command getNotEnabledUsers -ErrorAction SilentlyContinue) {
        return getNotEnabledUsers
    } else {
        return (Get-LocalUser | Where-Object { -not $_.Enabled } | Select-Object Name, SID)
    }
}

while ($true) {

    Write-Host $Prompt -ForegroundColor Cyan
    $choice = Read-MenuChoice
    if ($null -eq $choice) {
        Write-Warning "Invalid selection. Please enter a number between 1 and 10."
        continue
    }

    switch ($choice) {
        1 {
            _GetEnabledUsers | Format-Table -AutoSize
        }
        2 {
            _GetDisabledUsers | Format-Table -AutoSize
        }
        3 {
            $name = Read-Host "Enter new username"
            if (-not $name) { Write-Warning "Username cannot be empty."; break }
            $pw = Read-Host "Enter temporary password" -AsSecureString
            try {
                if (Get-Command createAUser -ErrorAction SilentlyContinue) {
                    createAUser -name $name -password $pw
                } else {
                    New-LocalUser -Name $name -Password $pw -AccountNeverExpires:$true -PasswordNeverExpires:$true
                    Add-LocalGroupMember -Group 'Users' -Member $name -ErrorAction SilentlyContinue
                }
                Write-Host "User '$name' created." -ForegroundColor Green
            } catch {
                Write-Error $_
            }
        }
        4 {
            $name = Read-Host "Enter username to remove"
            if (-not $name) { Write-Warning "Username cannot be empty."; break }
            try {
                if (Get-Command removeAUser -ErrorAction SilentlyContinue) {
                    removeAUser -name $name
                } else {
                    Remove-LocalUser -Name $name
                }
                Write-Host "User '$name' removed." -ForegroundColor Yellow
            } catch {
                Write-Error $_
            }
        }
        5 {
            $name = Read-Host "Enter username to enable"
            if (-not $name) { Write-Warning "Username cannot be empty."; break }
            try {
                if (Get-Command enableAUser -ErrorAction SilentlyContinue) {
                    enableAUser -name $name
                } else {
                    Enable-LocalUser -Name $name
                }
                Write-Host "User '$name' enabled." -ForegroundColor Green
            } catch { Write-Error $_ }
        }
        6 {
            $name = Read-Host "Enter username to disable"
            if (-not $name) { Write-Warning "Username cannot be empty."; break }
            try {
                if (Get-Command disableAUser -ErrorAction SilentlyContinue) {
                    disableAUser -name $name
                } else {
                    Disable-LocalUser -Name $name
                }
                Write-Host "User '$name' disabled." -ForegroundColor Yellow
            } catch { Write-Error $_ }
        }
        7 {
            $days = Read-Host "Show login/logoff events for how many days back?"
            if (-not ($days -as [int])) { Write-Warning "Please enter a valid number of days."; break }
            if (Get-Command getLogInAndOffs -ErrorAction SilentlyContinue) {
                getLogInAndOffs -timeBack ([int]$days) | Sort-Object Time -Descending | Format-Table -AutoSize
            } else {
                Write-Warning "getLogInAndOffs function not available."
            }
        }
        8 {
            $days = Read-Host "Show failed logins for how many days back?"
            if (-not ($days -as [int])) { Write-Warning "Please enter a valid number of days."; break }
            if (Get-Command getFailedLogins -ErrorAction SilentlyContinue) {
                getFailedLogins -timeBack ([int]$days) | Sort-Object Time -Descending | Format-Table -AutoSize
            } else {
                Write-Warning "getFailedLogins function not available."
            }
        }
        9 {
            $days = Read-Host "Consider failed logins in the last how many days?"
            if (-not ($days -as [int])) { Write-Warning "Please enter a valid number of days."; break }
            if (Get-Command getFailedLogins -ErrorAction SilentlyContinue) {
                $failed = getFailedLogins -timeBack ([int]$days)
                $failed |
                    Group-Object User |
                    Where-Object { $_.Count -gt 10 } |
                    Select-Object @{n='Count';e={$_.Count}}, @{n='Name';e={$_.Name}} |
                    Sort-Object Count -Descending |
                    Format-Table -AutoSize
            } else {
                Write-Warning "getFailedLogins function not available."
            }
        }
        10 { break }
    }

    if ($choice -eq 10) { break }
}

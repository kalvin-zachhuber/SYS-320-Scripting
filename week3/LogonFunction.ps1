function LogonFunction {
    param(
        [int]$Days
    )

    $loginouts = Get-EventLog Security -source Microsoft-Windows-Security-Auditing -After (Get-Date).AddDays(-$Days)

    $loginoutsTable = @() 
    for($i=0; $i -lt $loginouts.Count; $i++) {
        $event = ""
        if($loginouts[$i].InstanceId -eq 4624) { $event="Logon" }
        if($loginouts[$i].InstanceId -eq 4634) { $event="Logoff" }

        $sidText = $loginouts[$i].ReplacementStrings[0]

        $user = $sidText
        try {
            $sidObj = New-Object System.Security.Principal.SecurityIdentifier($sidText)
            $user = $sidObj.Translate([System.Security.Principal.NTAccount]).Value
        } catch { 
        
        }

        $loginoutsTable += [PSCustomObject]@{
            "Time"  = $loginouts[$i].TimeGenerated
            "Id"    = $loginouts[$i].InstanceId
            "Event" = $event
            "User"  = $user
        }
    }

    return $loginoutsTable
}

$results = LogonFunction -Days 14
$results | Format-Table -AutoSize

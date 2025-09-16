function PCStopFunction {
    param(
        [int]$Days
    )

    $startStops = Get-EventLog -LogName System -Source EventLog -After (Get-Date).AddDays(-$Days)

    $startStopTable = @()
    for ($i = 0; $i -lt $startStops.Count; $i++) {

        $event = ""
        if ($startStops[$i].EventID -eq 6005) { $event = "Startup" }   
        if ($startStops[$i].EventID -eq 6006) { $event = "Shutdown" }  

        if ($event -ne "") {
            $startStopTable += [PSCustomObject]@{
                "Time"  = $startStops[$i].TimeGenerated          
                "Id"    = $startStops[$i].EventID               
                "Event" = $event                                 
                "User"  = "System"                               
            }
        }
    }

    return $startStopTable
}

$bootResults = PCStopFunction -Days 14
$bootResults | Format-Table -AutoSize

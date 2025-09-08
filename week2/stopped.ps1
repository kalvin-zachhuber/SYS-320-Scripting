Get-Service | Where-Object { $_.Status -eq 'Stopped' } |
    Sort-Object DisplayName |
    Export-Csv -Path "StoppedServices.csv"
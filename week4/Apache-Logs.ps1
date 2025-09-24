function Get-ApacheIPs {
    param(
        [string]$Page,
        [int]$Status,
        [string]$Browser,
        [string]$LogPath = 'C:\xampp\apache\logs\access.log'
    )

    $ipRx = '\b(\d{1,3}\.){3}\d{1,3}\b'

    Get-Content $LogPath |
        Select-String -Pattern " $Status " |
        Where-Object {
            $_.Line -imatch $Browser -and
            ( $_.Line -match [regex]::Escape($Page) -or $_.Line -match [regex]::Escape("/$Page") )
        } |
        ForEach-Object { [regex]::Match($_.Line, $ipRx).Value } |
        Where-Object { $_ }        # keep only non-empty IPs
}

$chrome = Get-Process -Name "chrome" -ErrorAction SilentlyContinue
if (-not $chrome) {
    Start-Process "chrome.exe" "https://www.champlain.edu"
}
else {
    Stop-Process -Name "chrome" -Force
}
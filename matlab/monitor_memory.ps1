# monitor_memory.ps1
param (
    [int]$PIDToMonitor,
    [string]$LogFile,
    [string]$FlagFile
)

# Pulisce il log precedente
Remove-Item -Path $LogFile -ErrorAction SilentlyContinue

# Continua a registrare finché non viene creato il file "FLAGFILE" da MATLAB
while (-not (Test-Path -Path $FlagFile)) {
    $process = Get-Process -Id $PIDToMonitor -ErrorAction SilentlyContinue
    if ($process) {
        # Salva la memoria in KB
        $memKB = [math]::Round($process.WorkingSet64 / 1024)
        $memKB | Out-File -FilePath $LogFile -Append
    }
    Start-Sleep -Milliseconds 5 # Campiona ogni 5ms
}
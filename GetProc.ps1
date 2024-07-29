#######################################################################
## Copyright (c) 2024 Ricky Visser / Gamecode64                      ##
#######################################################################
## Getting windows process stats for zabbix, given by user parameter ##
#######################################################################


param (
    [string]$ProcName
)

$Proc = Get-Process -Name $ProcName -ErrorAction SilentlyContinue

if ($null -ne $Proc) {
    $CPU = (Get-WmiObject Win32_PerfFormattedData_PerfProc_Process -Filter "IDProcess=$($Proc.Id)").PercentProcessorTime
    $Mem = [math]::round($Proc.WorkingSet64 / 1KB, 2)
    Write-Output "$ProcName, $CPU, $Mem"
} else {
    Write-Output "null, 0, 0"
}


# Place this line in your zabbix_agentd.conf or in zabbix_agent2.conf Depending on your agent version
# UserParameter=process.stats[*],powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Program Files\Zabbix Agent2\scripts\GetProc.ps1" "$1"

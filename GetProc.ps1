#######################################################################
## Copyright (c) 2024 Ricky Visser / Gamecode64                      ##
#######################################################################
## Getting windows process stats for zabbix, given by user parameter ##
#######################################################################


# ProcName: Process name to monitor
# Type:
#   1: CPU
#   2: MEM
param (
    [string]$ProcName,
    [int]$Type
)

$Proc = Get-Process -Name $ProcName -ErrorAction SilentlyContinue

if ($null -ne $Proc) {
    $Out = "null"
    if( $Type -eq 1)
    {
        $Out = (Get-WmiObject Win32_PerfFormattedData_PerfProc_Process -Filter "IDProcess=$($Proc.Id)").PercentProcessorTime
    }
    elseif( $Type -eq 2)
    {
        $Out = [math]::round($Proc.WorkingSet64 / 1KB, 2)
    }
    
    Write-Output "$Out"
} else {
    Write-Output "null"
}


# Place these lines in your zabbix_agentd.conf or in zabbix_agent2.conf Depending on your agent version
# UserParameter=process.stats.CPU[*],powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Program Files\Zabbix Agent2\scripts\GetProc.ps1" "$1" 1
# UserParameter=process.stats.Mem[*],powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Program Files\Zabbix Agent2\scripts\GetProc.ps1" "$1" 2

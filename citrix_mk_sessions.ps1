# 
# 
# Local check for check_mk to track the citrix sessions in an MK pool
#
#
# Script: citrix_mk_sessions.ps1
# Author: Olaf Assmus
# Version: 1.0
# Date: 01-04-2010
# Details: 	Check the current session count for a citrix mk catalog
#			The check_mk user has to be a member of the citrix admin group
			
# Usage:
# .\citrix_mk_sessions.ps1 "HomeOfficePc_Pool" "MK HomeOfficePc"
# 		<<<local>>>
# 		0 Sessions_HomeOfficePc_Pool sessions=232 We have 232 Sessions on that pool
#
# .\citrix_mk_sessions.ps1 "HomeOfficePc_Pool" "MK HomeOfficePc" 200
#		<<<local>>>
#		2 Sessions_HomeOfficePc_Pool sessions=220 We have 220 Sessions on that pool. The pool is full.
#
#

param (
[String]$servicename="Servicename",
[String]$mk_name="MK Catalogname",
[int]$crit="400"
)

#Import PS Snapin for Citrix
if ((Get-PSSnapin "Citrix.Common.Commands" -EA silentlycontinue) -eq $null) {
	try { Add-PSSnapin Citrix.* -ErrorAction Stop }
	catch { write-error "Error Citrix.* Powershell snapin"; Return }
}

$sessions = (Get-BrokerSession -CatalogName $mk_name | select BrokeringUserName).Count

Write-Output "<<<local>>>"
if ($sessions -lt $crit)
    {
    #if count is below 400 we are fine
    Write-Output "0 Sessions_$servicename sessions=$sessions We have $sessions Sessions on that pool"
    }
else
    {
    #if the count is over 400 we get create a warning
    Write-Output "2 Sessions_$servicename sessions=$sessions We have $sessions Sessions on that pool. The pool is full."
    }
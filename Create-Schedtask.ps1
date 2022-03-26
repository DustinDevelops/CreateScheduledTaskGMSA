<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2019 v5.6.167
	 Created on:   	11/12/2019 4:02 PM
	 Created by:   	Dustin Jones
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>


$DomainFQDN = (Get-WmiObject Win32_ComputerSystem).Domain
$Domain = (Get-ADDomain $DomainFQDN)
$DomainName = ($Domain.Name)

If (Test-ADServiceAccount GMSA)
{
	# Stale Script
	if (!(Test-Path -Path "C:\Program Files\PS\Stale\"))
	{
		New-Item -ItemType directory -Path "C:\Program Files\PS\DJ\"
	}
	$Settings = New-ScheduledTaskSettingsSet -StartWhenAvailable
	$action = New-ScheduledTaskAction -Execute "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -WorkingDirectory "C:\Program Files\PS\DJ\" -Argument '-file .\Test-DNSIpv6.ps1'
	$trigger = New-ScheduledTaskTrigger -RepetitionInterval (New-TimeSpan -Minutes 10) -At 16:20 -RepetitionDuration (New-TimeSpan -Days 3) -Once 
	$principal = New-ScheduledTaskPrincipal -UserID "$DomainName\GMSA$" -LogonType Password
	
	Register-ScheduledTask TestDNSTask -Action $action -Trigger $trigger -Principal $principal -Settings $Settings
}
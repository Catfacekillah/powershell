####################################################################
# enableaccount.ps1                                                #
# Enables AD Account and adds ticket number to account description #
# v1.0 2021                                                        #
####################################################################

[CmdletBinding()]

Param (
    # This is the list of users you want to query.
    [Parameter(Mandatory = $true)]
    [string]$user = $null,
    [Parameter(Mandatory = $true)]
    [string]$ticket = $null
)

# Import PowerShell module
import-module activedirectory

# Disable account and update description with ticket number
Write-Host "Enabling $user... "
Enable-ADAccount $user -Confirm:$false
Get-ADUser $user -Properties Description | ForEach-Object { 
    Set-ADUser $user -Description "$($_.Description), Enabled $ticket"
}
Write-Host "$user is enabled"
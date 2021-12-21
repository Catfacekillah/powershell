#########################################################################
# Name: showusergroups.ps1                                              #
# Purpose: Displays group memberships of user account                   #
# Version 2.0                                                           #
# tehill                                                                #
#########################################################################

[CmdletBinding()]

Param (
    # This is the list of users you want to query.
    [Parameter(Mandatory = $true)]
    [string]$user = $null
)

# Import AD module
import-module activedirectory

# Query user and display list of group memberships
(Get-ADuser -Identity $user -Properties MemberOf, PrimaryGroupID).MemberOf | Get-ADGroup | Select-Object name | Sort-Object name | Out-String
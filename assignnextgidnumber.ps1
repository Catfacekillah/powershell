###############################################################
# assigngidnumber.ps1                                         #
# Assigns next unused gidnumber in sequence to AD group       #
# v.10 2021                                                   #
###############################################################

[CmdletBinding()]
Param (
    # Set required account information
    [Parameter(Mandatory = $true)]
    [string]$groupname = $null
)

# Import modules
Import-Module activedirectory

# Clear gidvalues
$newgid = $null
$gidnums = $null

# Retrieve next unused gidnumber
$gidnums = Get-adgroup -Properties gidnumber -LDAPFilter "(gidnumber=*)" | Select-Object -ExpandProperty gidnumber | Where-Object { 
    $_ -gt 549999 -and $_ -lt 649999 
} | Measure-Object -Maximum | Select-Object -ExpandProperty Maximum
$newgid = $gidnums + 1

# Assign gidnumber to group and display result

Set-ADGroup -Identity $groupname -Replace @{
     gidnumber = "$newgid" 
    }
Write-Host "$newgid has been assigned to $groupname"
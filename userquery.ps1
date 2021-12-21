#######################################################
# userquery.ps1                                       #
# Queries user and returns defined list of attributes #
# v1.0 2021                                           #
#######################################################

[CmdletBinding()]
    Param (
        # This is the list of users you want to query.
        [Parameter(Mandatory = $true)]
        [Array]$users = $null
    )

Import-Module ActiveDirectory

# Hash variables for last logon timestamp and date of last password change
$hash_lastLogonTimestamp = @{
    Name="lastLogonTimestamp";Expression={
        ([datetime]::FromFileTime($_.lastLogonTimestamp))
    }
}

$hash_pwdLastSet = @{
    Name="pwdLastSet";Expression={
        ([datetime]::FromFileTime($_.pwdLastSet))
    }
}

# Hash variable for password expiration date: Not currently implemented
#$hash_pwdExpiry = @{
#    Name="pwdExpiry";Expression={
#        ([datetime]::FromFileTime($_.pwdExpiry))
#    }
#}
#(Get-ADUser -Identity fullenwarth -Properties
#msDS-UserPasswordExpiryTimeComputed).'msDS-UserPasswordExpiryTimeComputed' |ForEach-Object -Process
#{[datetime]::FromFileTime($_)}


# Query users and display results
foreach ($user in $users) {
    Get-ADUser $user -Properties * | Select-Object DistinguishedName, SamAccountName, Description, EmailAddress, `
    Officephone, Title, extensionattribute13, extensionattribute5, extensionattribute4, extensionattribute3, `
    extensionattribute8, extensionattribute15, extensionattribute12, whencreated, Enabled, LockedOut, BadPWdCount, `
    $hash_lastLogonTimestamp, $hash_pwdLastSet,`

        # Password expiration conversion
        @{
           Name="pwdExpiry";Expression={
                (Get-ADuser $user -Properties msDS-UserPasswordExpiryTimeComputed).'msDS-UserPasswordExpiryTimeComputed' |ForEach-Object -Process {
                    [datetime]::FromFileTime($_)
                }
                }
            } ,
        # Account expiration conversion
        @{ 
            Name="AcctExpiry";Expression={
                [datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed") 
            }
         }
        } Format-List | Out-String -width 115| Format-List
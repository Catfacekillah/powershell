###############################################
# checkdns.ps1                                #
# Runs nslookup against hostname and IP lists #
# v1.0 2021                                   #
###############################################

# Define IP and hostname list path - enter desired filepath for text files
$hostnamefile = 'C:\UserName\DNS\'
$ipfile = 'C:\UserName\DNS\'

# Create hostname list if not found
if (-not(Test-Path -Path $hostnamefile -Pathtype Leaf)) {
    do {
        $uhostname = Read-Host -Prompt "Enter hostname"
        Add-Content .\hostnames.txt "$uhostname"
        $confirmation = Read-Host "Enter another hostname? (Y/N)"
    }
    until ($confirmation -eq 'N')
    Write-Host "Hostname list created at $hostnamefile`n"
}

# If hostname list is found, show message and continue
else {
    Write-host "`nHostname list found at $hostnamefile`n"
}

# Create IP list if not found
if (-not(Test-Path -Path $ipfile -PathType Leaf)) {
    do {
        $uip = Read-Host -Prompt "Enter IP address"
        Add-Content .\ips.txt "$uip"
        $confirmation = Read-Host "Enter another address? (Y/N)"
    }
    until ($confirmation -eq 'N')
    Write-Host "`nIP list created at $ipfile`n"
}

# If IP list is found, show message and continue
else {
    Write-Host "IP list found at $ipfile`n"
}

$hostnames = Get-Content .\hostnames.txt
$ips = Get-Content .\ips.txt

# Check hostnames list
Write-Host "`nChecking hostnames...`n"
Start-Sleep -s 2
Foreach ($hostname in $hostnames) {
    $addresses = $null

    try {
        $addresses = [System.Net.Dns]::GetHostAddresses("$hostname").IPAddressToString
    }

    catch {
        $addresses = "is not found"
    }

    foreach ($Address in $addresses) {
        write-host $hostname, "is" $addresses
    }
}
Write-Host "`nDone"

# Check IP addresses list
Write-Host "`nChecking IP addresses...`n"
Start-Sleep -s 2
Foreach ($ip in $ips) {
    $name = nslookup $ips 2> $null | select-string -Pattern "Name:"
    if 
    ( ! $name ) {
        $name = ""
    }
    $name = $name.ToString()
    
    if
    ($name.StartsWith("Name:")) {
        $name = (($name -split ":")[1]).Trim()
    }
    
    else {
        $name = "not found"
    }
    foreach ($ips in $ips) {
        write-host $ips, "is" $name
    }
}
Write-Host "`nDone`n"

# Keep/remove lists and exit
$Readhost = Read-Host "Remove hostname and IP lists? Y/N"
Switch ($Readhost) {
    Y {
        Write-Host "`nRemoving lists`n" 
        Remove-Item $ipfile
        Remove-Item $hostnamefile
    }
    N { 
        Exit 
    }
}
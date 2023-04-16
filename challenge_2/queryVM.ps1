[CmdletBinding()]
param (

    [Parameter(Mandatory=$true)]
    [string]
    $Key,

    # Value of the field
    [Parameter(Mandatory=$true)]
    [string]
    $Value
)


Write-Host "Fetching Virtual machine with $($Key) with value $($Value)."

az vm list --query "[?$($key)=='$($Value)']" -o json

# For example

# .\queryVM.ps1 -Key "name" -Value "vm-2018" 
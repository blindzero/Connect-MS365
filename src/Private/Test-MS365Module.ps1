function Test-MS365Module {
    [CmdletBinding()]
    param (
        # service module to be tested, must be known service
        [Parameter(Mandatory=$True,Position=1)]
        [ValidateSet('MSOL','EOL','Teams','SPO','SCC','AAD')]
        [String]
        $Service
    )

    <#
    .SYNOPSIS

    Checks if a module of a given service to connect is installed.

    .DESCRIPTION

    Checks if a module of a given service to connect is installed.
    Service name needs to be passed.

    .PARAMETER Service
    Name of service to check installed modules for.

    .INPUTS

    None. You cannot pipe objects to Add-Extension.

    .OUTPUTS

    // <OBJECTTYPE>. TBD.

    .EXAMPLE

    Test-MS365Module -Service MSOL

    .LINK

    http://github.com/blindzero/Connect-MS365

    #>

    # Set Splatting argument list for Get-Module used to determine if module is existing
    $GetModulesSplat = @{
        ListAvailable = $True
        Verbose	      = $False
    }

    # TODO #10: changing to settings array containing module names making switch unnecessary

    Switch($Service) {
        # Microsoft Online Service
        MSOL {
            If ($null -eq (Get-Module @GetModulesSplat -Name "MSOnline")) {
                $False
            }
            Else {
                $True
            }
        }
        # Exchange Online Service or Security Compliance Center
        {($_ -eq "EOL") -or ($_ -eq "SCC")} {
            If ($null -eq (Get-Module @GetModulesSplat -Name "ExchangeOnlineManagement")) {
                $False
            }
            Else {
                $True
            }
        }
        # Teams
        Teams {
            If ($null -eq (Get-Module @GetModulesSplat -Name "MicrosoftTeams")) {
                $False
            }
            Else {
                $True
            }
        }
        # SPO
        SPO {
            If ($null -eq (Get-Module @GetModulesSplat -Name "Microsoft.Online.SharePoint.PowerShell")) {
                $False
            }
            Else {
                $True
            }
        }
        # AzureAD
        AAD {
            If ($null -eq (Get-Module @GetModulesSplat -Name "AzureAD")) {
                $False
            }
            Else {
                $True
            }
        }
    }
}

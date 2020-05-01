function Test-MS365Module {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True,Position=1)]
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

    $GetModulesSplat = @{
        ListAvailable = $True
        Verbose	      = $False
    }

    Switch($Service) {
        MSOL {
            If ($null -eq (Get-Module @GetModulesSplat -Name "MSOnline")) {
                $False
            }
            Else {
                $True
            }
        }
        EOL {
            If ($null -eq (Get-Module @GetModulesSplat -Name "ExchangeOnlineManagement")) {
                $False
            }
            Else {
                $True
            }
        }
    }
}

<#
.SYNOPSIS
Connects to a given online service of Microsoft.

.DESCRIPTION
Connects to a given online service of Microsoft.
One or multiple service names can be chosen.

.PARAMETER Service
Specifies the service to connect to. May be a list of multiple services to use.

.PARAMETER MFA
Toggles MFA usage. Not requesting PSCredential object.

.INPUTS
None. You cannot pipe objects to Add-Extension.

.OUTPUTS
// <OBJECTTYPE>. TBD.

.EXAMPLE
Connect-MS365 -Service MSOL

.EXAMPLE
Connect-MS365 -Service MSOL -MFA

.EXAMPLE
Connect-MS365 -Service MSOL,EOL -MFA

.LINK
https://github.com/blindzero/Connect-MS365

#>
function Connect-MS365 {

    [OutputType()]
    [CmdletBinding(DefaultParameterSetName)]
    param (
        #service parameter to define to which services to connect to
        #are validated against available / implemented services
        [Parameter(Mandatory=$True, Position = 1)]
        [ValidateSet('MSOL','EOL')]
        [string[]]
        $Service,
        #mfa parameter if mfa authentication is necessary
        #used later to determine different connection commands and is not using PScredential object
        [Parameter(Mandatory=$False, Position = 2, ParameterSetName = 'MFA')]
        [Switch]
        $MFA,
        [Parameter(Mandatory = $False, Position = 3, ParameterSetName = 'Credential')]
        [PSCredential]
        $Credential
    )

    # dont gather PSCredential object if MFA is set
    If (($MFA -ne $True) -and (!($Credential))) {
        Write-Verbose "Gathering PSCredentials object for non MFA sign on"
        $Credential = Get-Credential -Message "Please enter your Office 365 credentials"
    }
    
    # iterating through each service listed in service parameter
    # each service is passing PSCredential object if MFA not set or leaves it out if set
    ForEach ($ServiceItem in $Service) {
        Write-Verbose "Create session to Service $ServiceItem"
        Switch($ServiceItem) {
            # Microsoft Online service
            MSOL {
                if ($MFA) {
                    Connect-MSOL
                }
                else {
                    Connect-MSOL -Credential $Credential
                }
                continue
            }
            # Exchange Online service
            EOL {
                if ($MFA) {
                    Connect-EOL
                }
                else {
                    Connect-EOL -Credential $Credential
                }
                continue
            }
        }
        Write-Verbose "Create session to Service $ServiceItem done."
    }

    Write-Verbose "Connect-MS365 terminated."
}

# Export only the functions using PowerShell standard verb-noun naming.
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.
Export-ModuleMember -Function Connect-MS365

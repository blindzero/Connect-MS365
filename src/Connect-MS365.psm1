<#
.SYNOPSIS
Connects to a given online service of Microsoft.

.DESCRIPTION
Connects to a given online service of Microsoft.
One or multiple service names can be chosen.

.PARAMETER Service
Specifies the service to connect to.

.INPUTS
None. You cannot pipe objects to Add-Extension.

.OUTPUTS
// <OBJECTTYPE>. TBD.

.EXAMPLE
Connect-MS365 -Service MSOL

.LINK
https://github.com/blindzero/Connect-MS365

#>
function Connect-MS365 {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True, Position = 1)]
        [ValidateSet('MSOL')]
        [string[]]
        $Service
    )

    Write-Verbose "Gathering Credentials object to sign in at chosen service $Service"
    $Credential = Get-Credential -Message "Enter your credentials to log in at $Service"

    ForEach ($Item in $Service) {
        Write-Verbose "Create session to Service $Item"
        Switch($Item) {
            MSOL {
                Connect-MSOL -Credential $Credential
                continue
            }
        }
        Write-Verbose "Create session to Service $Item terminated."
    }

    Write-Verbose "Connect-MS365 terminated."
}

# Export only the functions using PowerShell standard verb-noun naming.
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.
Export-ModuleMember -Function Connect-MS365

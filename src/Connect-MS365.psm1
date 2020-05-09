<#
.SYNOPSIS
Connects to a given online service of Microsoft.

.DESCRIPTION
Connects to a given online service of Microsoft.
One or multiple service names can be chosen. Supports connection handling for
- Microsoft Online (MSOL) - aka AzureAD v1
- Exchange Online (EOL)
- Teams
- SharePoint Online (SPO)
- Security and Compliance Center (SCC)
- Azure ActiveDirectory (AAD) v2

.PARAMETER Service
Specifies the service to connect to. May be a list of multiple services to use.

.PARAMETER MFA
Toggles MFA usage. Not requesting PSCredential object.

.INPUTS
None. You cannot pipe objects to Add-Extension.

.OUTPUTS
// <OBJECTTYPE>. TBD.

.EXAMPLE
Description: Connect to Microsoft Online without using MFA
Connect-MS365 -Service MSOL

.EXAMPLE
Description: Connect to Microsoft Online by using MFA
Connect-MS365 -Service MSOL -MFA

.EXAMPLE
Description: Connect to Microsoft Online and Exchange Online by using MFA
Connect-MS365 -Service MSOL,EOL -MFA

.EXAMPLE
Description: Connect to SharePoint Online without MFA to connect to MyName-admin.sharepoint.com
Connect-MS365 -Service SPO -SPOOrgName MyName

.EXAMPLE
Description: Connect to SharePoint Online with MFA to connect to MyName-admin.sharepoint.com 
Connect-MS365 -Service SPO -SPOOrgName MyName -MFA

.EXAMPLE
Description: Connect to Security and Compliance Center with MFA  
Connect-MS365 -Service SCC -MFA

.EXAMPLE
Description: Connect to Azure ActiveDirectory with MFA  
Connect-MS365 -Service AAD -MFA

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
        [ValidateSet('MSOL','EOL','Teams','SPO','SCC','AAD')]
        [string]
        $Service,
        #spoorg parameter for connection to SPO service
        #needed by connect cmdlet to assemble admin Url
        [Parameter(Mandatory=$False, Position = 2)]
        [string]
        [Alias('SPOOrg')]
        $SPOOrgName,
        #mfa parameter if mfa authentication is necessary
        #used later to determine different connection commands and is not using PScredential object
        [Parameter(Mandatory=$False, Position = 3, ParameterSetName = 'MFA')]
        [Switch]
        $MFA,
        #Credential parameter to receive previously created PSCredential object.
        #Primarily needed for testing calls 
        [Parameter(Mandatory=$False, Position = 3, ParameterSetName = 'Credential')]
        [PSCredential]
        $Credential
    )

    # dont gather PSCredential object if MFA is set
    If (($MFA -ne $True) -and (!($Credential))) {
        Write-Verbose "Gathering PSCredentials object for non MFA sign on"
        $Credential = Get-Credential -Message "Please enter your Office 365 credentials"
    }
    
    # TODO #10: changing to settings array containing module names making switch unnecessary

    # iterating through each service listed in service parameter
    # each service is passing PSCredential object if MFA not set or leaves it out if set
    ForEach ($ServiceItem in $Service) {
        Write-Verbose "Create session to Service $ServiceItem"
        Switch($ServiceItem) {
            # Microsoft Online service
            MSOL {
                $ServiceName = "Microsoft Online / AzureAD v1"
                $ModuleName = "MSOnline"

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
                $ServiceName = "Exchange Online"
                $ModuleName = "ExchangeOnlineManagement"

                if ($MFA) {
                    Connect-EOL
                }
                else {
                    Connect-EOL -Credential $Credential
                }
                continue
            }
            # Teams service
            Teams {
                $ServiceName = "Microsoft Teams"
                $ModuleName = "MicrosoftTeams"

                if ($MFA) {
                    Connect-Teams
                }
                else {
                    Connect-Teams -Credential $Credential
                }
                continue
            }
            # Security and Compliance Center
            SCC {
                $ServiceName = "Security & Compliance Center"
                $ModuleName = "ExchangeOnlineManagement"

                if ($MFA) {
                    Connect-SCC
                }
                else {
                    Connect-SCC -Credential $Credential
                }
                continue
            }
            # AzureAD
            AAD {
                $ServiceName = "AzureAD v2"
                $ModuleName = "AzureAD"

                if ($MFA) {
                    Connect-AAD
                }
                else {
                    Connect-AAD -Credential $Credential
                }
                continue
            }
            # SPO service
            SPO {
                $ServiceName = "SharePoint Online"
                $ModuleName = "Microsoft.Online.SharePoint.PowerShell"

                If (!($SPOOrgName)) {
                    Write-Error 'To connect to SharePoint Online you have to provide the -SPOOrgName parameter.'
                    continue
                }
                Else {
                    Write-Verbose "Assembling SPOOrgUrl from $SPOOrgName"
                    $SPOOrgUrl = "https://$($SPOOrgName)-admin.sharepoint.com"
                    Write-Verbose "Created $SPOOrgUrl"
                }
                
                if ($MFA) {
                    Write-Verbose "Connecting to SharePoint Online at $SPOOrgUrl without Credential"
                    Connect-SPO -SPOOrgUrl $SPOOrgUrl
                }
                else {
                    Write-Verbose "Connecting to SharePoint Online at $SPOOrgUrl with $Credential"
                    Connect-SPO -SPOOrgUrl $SPOOrgUrl -Credential $Credential
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

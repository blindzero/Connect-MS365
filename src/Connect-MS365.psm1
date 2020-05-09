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
- Azure Platform (AZ)

.PARAMETER Service
Specifies the service to connect to. May be a list of multiple services to use.

.INPUTS
None. You cannot pipe objects to Connect-MS365.

.EXAMPLE
Description: Connect to Microsoft Online
Connect-MS365 -Service MSOL

.EXAMPLE
Description: Connect to Microsoft Online and Exchange Online
Connect-MS365 -Service MSOL,EOL

.EXAMPLE
Description: Connect to SharePoint Online to connect to MyName-admin.sharepoint.com
Connect-MS365 -Service SPO -SPOOrgName MyName

.EXAMPLE
Description: Connect to Security and Compliance Center
Connect-MS365 -Service SCC

.EXAMPLE
Description: Connect to Azure ActiveDirectory  
Connect-MS365 -Service AAD

.EXAMPLE
Description: Connect to Microsoft Azure platform
Connect-MS365 -Service AZ

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
        [ValidateSet('MSOL','EOL','Teams','SPO','SCC','AAD','AZ')]
        [string[]]
        $Service,
        #spoorg parameter for connection to SPO service
        #needed by connect cmdlet to assemble admin Url
        [Parameter(Mandatory=$False, Position = 2)]
        [string]
        [Alias('SPOOrg')]
        $SPOOrgName,
        #Credential parameter to receive previously created PSCredential object.
        #Primarily needed for testing calls 
        [Parameter(Mandatory=$False, Position = 3, ParameterSetName = 'Credential')]
        [PSCredential]
        $Credential
    )

    # TODO #10: changing to settings array containing module names making switch unnecessary

    # iterating through each service listed in service parameter
    ForEach ($ServiceItem in $Service) {
        Write-Verbose "Create session to Service $ServiceItem"
        Switch($ServiceItem) {
            # Microsoft Online service
            MSOL {
                $ServiceName = "Microsoft Online / AzureAD v1"
                $ModuleName = "MSOnline"
                $ModuleFindString = $ModuleName

                Connect-MSOL
                continue
            }
            # Exchange Online service
            EOL {
                $ServiceName = "Exchange Online"
                $ModuleName = "ExchangeOnlineManagement"
                $ModuleFindString = $ModuleName

                Connect-EOL
                continue
            }
            # Teams service
            Teams {
                $ServiceName = "Microsoft Teams"
                $ModuleName = "MicrosoftTeams"
                $ModuleFindString = $ModuleName

                Connect-Teams
                continue
            }
            # Security and Compliance Center
            SCC {
                $ServiceName = "Security & Compliance Center"
                $ModuleName = "ExchangeOnlineManagement"
                $ModuleFindString = $ModuleName

                Connect-SCC
                continue
            }
            # AzureAD
            AAD {
                $ServiceName = "AzureAD v2"
                $ModuleName = "AzureAD"
                $ModuleFindString = $ModuleName

                Connect-AAD
                continue
            }
            # Azure
            AZ {
                $ServiceName = "Azure"
                $ModuleName = "Az"
                $ModuleFindString = "Az.*"

                Connect-AZ
                continue
            }
            # SPO service
            SPO {
                $ServiceName = "SharePoint Online"
                $ModuleName = "Microsoft.Online.SharePoint.PowerShell"
                $ModuleFindString = $ModuleName

                If (!($SPOOrgName)) {
                    Write-Error 'To connect to SharePoint Online you have to provide the -SPOOrgName parameter.'
                    continue
                }
                Else {
                    Write-Verbose "Assembling SPOOrgUrl from $SPOOrgName"
                    $SPOOrgUrl = "https://$($SPOOrgName)-admin.sharepoint.com"
                    Write-Verbose "Created $SPOOrgUrl"
                }
                
                Write-Verbose "Connecting to SharePoint Online at $SPOOrgUrl"
                Connect-SPO -SPOOrgUrl $SPOOrgUrl
                continue
            }
        }
        Write-Verbose "Create session to Service $ServiceItem done."
    }

    Write-Verbose "Connect-MS365 done."
}

# Export only the functions using PowerShell standard verb-noun naming.
# Be sure to list each exported functions in the FunctionsToExport field of the module manifest file.
# This improves performance of command discovery in PowerShell.
Export-ModuleMember -Function Connect-MS365

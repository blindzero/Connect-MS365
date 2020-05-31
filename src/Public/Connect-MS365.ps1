function Connect-MS365 {

    [OutputType()]
    [CmdletBinding(DefaultParameterSetName)]
    param (
        #service parameter to define to which services to connect to
        #are validated against available / implemented services
        [Parameter(Mandatory=$True, Position = 1)]
        [ValidateSet('MSOL','EOL','Teams','SPO','SCC','AAD','AZ','S4B')]
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
            # S4B Service
            S4B {
                $ServiceName = "Microsoft Skype4Business"
                $ModuleName = "SkypeOnlineConnector"
                $ModuleFindString = $ModuleName

                Connect-S4B
                continue
            }

        }
        Write-Verbose "Create session to Service $ServiceItem done."
    }

    Write-Verbose "Connect-MS365 done."
}

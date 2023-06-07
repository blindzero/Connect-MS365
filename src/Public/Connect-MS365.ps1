function Connect-MS365 {

    [CmdletBinding(DefaultParameterSetName)]
    [OutputType()]
    
    param (
        #service parameter to define to which services to connect to
        #are validated against available / implemented services
        [Parameter(Mandatory = $true, Position = 1)]
        [ValidateSet('MSOL','EOL','Teams','SPO','SCC','AAD','AZ','S4B')]
        [string[]]
        $Service,
        #spoorg parameter for connection to SPO service
        #needed by connect cmdlet to assemble admin Url
        [Parameter(Mandatory = $false, Position = 2)]
        [string]
        [Alias('SPOOrg')]
        $SPOOrgName,
        #Credential parameter to receive previously created PSCredential object.
        #Primarily needed for testing calls 
        [Parameter(Mandatory = $false, Position = 3, ParameterSetName = 'Credential')]
        [PSCredential]
        $Credential,
        # re-initialize configuration file
        [Parameter(Mandatory = $false, Position = 4, ParameterSetName = 'ReInitConfig')]
        [switch]
        $ReInitConfig = $false
    )

    # TODO #10: changing to settings array containing module names making switch unnecessary

    # we initialize our config, all checks if exists or not / overwriting is done in function
    Initialize-Config -Force:$ReInitConfig

    # reading config data
    $Config = Read-Config

    # iterating through each service listed in service parameter
    ForEach ($ServiceItem in $Service) {
        Write-Verbose "Create session to Service $ServiceItem"
        Switch($ServiceItem) {
            # Microsoft Online service
            MSOL {
                $ServiceName = "Microsoft Online / AzureAD v1"
                $ModuleName = "MSOnline"
                $ModuleFindString = $ModuleName

                if ($PSVersionTable.PSEdition -eq "Desktop") {
                    Connect-MSOL
                    continue
                }
                else {
                    Write-Error "PowerShell module ``$ModuleName`` is not supported by PowerShell Core."
                    continue
                }
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

                Write-Verbose "Using ExchangeOnlineManagement module for SCC replacement."
                Connect-SCC
                continue
            }
            # AzureAD
            AAD {
                $ServiceName = "AzureAD v2"
                $ModuleName = "AzureAD"
                $ModuleFindString = $ModuleName

                if ($PSVersionTable.PSEdition -eq "Desktop") {
                    Connect-AAD
                    continue
                }
                else {
                    Write-Error "PowerShell module ``$ModuleName`` is not supported by PowerShell Core."
                    continue
                }
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

                if ($PSVersionTable.PSEdition -eq "Desktop") {
                    Connect-AAD
                    continue
                }
                else {
                    Write-Error "PowerShell module ``$ModuleName`` is not supported by PowerShell Core."
                    continue
                }

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
        Write-Verbose "Create session to Service $ServiceItem ended."
    }

    Write-Verbose "Connect-MS365 ended."
}

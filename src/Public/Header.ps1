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
- Skype for Business Online service (S4B)

.PARAMETER Service
Specifies the service to connect to. May be a list of multiple services to use.

.PARAMETER SPOOrgName
Parameter that specifices the organization name for SharePointOnline. Used to create SPO Admin URL.

.PARAMETER ReInitConfig
Forces to initialize config file in $env:LOCALAPPDATA\Connect-MS365\Connect-MS365.Config.psd1 although file exist.

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

.EXAMPLE
Description: Connect to Microsoft Skype for Business Online service
Connect-MS365 -Service S4B

.LINK
https://github.com/blindzero/Connect-MS365

#>

#Requires -Version 5.1

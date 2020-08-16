# Connect-MS365

## 02-USAGE

When installed properly (see 01-INSTALLATION.md), the module Connect-MS365 should be automatically available within your system.

Start Connect-MS365 by using

```powershell
Connect-MS365 -Service <list of services> [-SPOOrgName <name of sharepoint org>]
```

The service you want to connect is selected by `-Service` parameter, followed by one of the supported services

* __MSOL__ - Microsoft Online / Azure ActiveDirectory

  Uses [MSOnline](https://docs.microsoft.com/powershell/azure/active-directory/overview?view=azureadps-1.0) module to connect to basic Microsoft Online services.

  See the [CmdLet reference](https://docs.microsoft.com/powershell/module/msonline) for all available commands.

* __EOL__ - Microsoft Exchange

  Uses [ExchangeOnlineManagement](https://docs.microsoft.com/powershell/exchange/exchange-online/exchange-online-powershell-v2/exchange-online-powershell-v2) (Exchange Online PowerShell v2) module to connect to Microsoft Exchange Online.

  _Old plain Remote PowerShell connections are not supported anymore! Please see the documentation for the new CmdLets available._

* __Teams__ - Microsoft Teams

  Uses [MicrosoftTeams](https://docs.microsoft.com/microsoftteams/teams-powershell-overview) module to connect to Microsoft Teams.

  See the [CmdLet reference](https://docs.microsoft.com/en-us/powershell/module/teams) for all available commands.

* __SPO__ - Microsoft SharePoint Online

  Uses [Microsoft.Online.SharePoint.PowerShell](https://docs.microsoft.com/en-us/powershell/sharepoint/sharepoint-online/introduction-sharepoint-online-management-shell) module to connect to Microsoft Teams.

  Needs additional -SPOOrgName parameter.

  See the [CmdLet reference](https://docs.microsoft.com/en-us/powershell/module/sharepoint-online/) for all available commands.

* __SCC__ - Office365 Security & Compliance Center

  Uses [ExchangeOnlineManagement](https://docs.microsoft.com/powershell/exchange/exchange-online/exchange-online-powershell-v2/exchange-online-powershell-v2) (Exchange Online PowerShell v2) module to connect to Office365 Security & Compliance Center.

  _Old plain Remote PowerShell connections are not supported anymore! Please see the documentation for the new CmdLets available._

* __AAD__ - Microsoft Azure ActiveDirectory / AzureAD

  Uses [AzureAD](https://docs.microsoft.com/en-us/powershell/azure/active-directory/overview) module to connect to Microsoft Azure ActiveDirectory.

  See the CmdLet reference for all available commands.

* __AZ__ - Microsoft Azure Platform

  Uses [Az](https://docs.microsoft.com/de-de/powershell/azure) module to connect to Microsoft Azure ActiveDirectory.

  See the [CmdLet reference](https://docs.microsoft.com/de-de/powershell/module/?view=azps-3.8.0) for all available commands.

* __S4B__ - Microsoft Skype for Business (credits to [RasmusAaen](https://github.com/RasmusAaen))

  Uses SkypeOnlineConnector module to connect to Microsoft Skype for Busines.
  As SkypeOnlineConnector is not published on powershellgallery.com it must be [installed manually](https://www.microsoft.com/en-us/download/details.aspx?id=39366) if not available.

  See the [CmdLet reference](https://docs.microsoft.com/en-us/powershell/module/skype/?view=skype-ps) for all available commands.

### Multi Factor Authentication (MFA)

By version 1.1.0 modern authentication usage is default, incl. MFA functionality.
Passing PSCredential object was removed.

### Module Installations

When connecting the necessary module is checked and can be installed autoamtically if not available. No manual installation of modules...yah!

### Module Updates

For each module invocation the online available version is checked. If a newer version is available, user is prompted for (optional) update.

### Configuration

For configuration see [03-CONFIGURATION.md](03-CONFIGURATION.md).

### Details

For further details see [Connect-MS365.md](Connect-MS365.md)

# ReleaseNotes Connect-MS365

Powershell module to connect to all MS365 services and install required packages.

(c) by [Matthias Fleschuetz](https://github.com/blindzero)
[https://github.com/blindzero/Connect-MS365](https://github.com/blindzero/Connect-MS365)

## ToDos / Wishlist

- [#19](https://github.com/blindzero/Connect-MS365/issues/19) Azure CLI
- [#9](https://github.com/blindzero/Connect-MS365/issues/9) Proxy Support
- [#21](https://github.com/blindzero/Connect-MS365/issues/21) CSP connections support
- [#23](https://github.com/blindzero/Connect-MS365/issues/23) user config files

## v1.2.0

### New Features

- [#24](https://github.com/blindzero/Connect-MS365/issues/24) added Skype for Business option

### Changes

- re-enabling code notary git signature check

### Fixes

## v1.1.0

### New

- [#15 Module Updater](https://github.com/blindzero/Connect-MS365/issues/15)
  Comparing installed and available module version and prompt to update.
- [#7 Support MS Azure](https://github.com/blindzero/Connect-MS365/issues/7)
  Uses Az module and Connect-AzAccount

### Changes

- Removed -MFA switch and Credential passing

### Fixes

- [#18 Service parameter not accepting multiple services](https://github.com/blindzero/Connect-MS365/issues/18)

## v1.0.0

### New

All features from pre-release versions:

- #5 Adding support for Office365 Security & Compliance Center
- #6 Adding support for Azure ActiveDirectory (AzureAD, AAD) v2
- #2 Adding support for SharePoint Online service (SPO)
- Adding generated psm1 docs to docs dir in src
- #1 Adding support for MS Exchange Online service (EOL)
- Adding support for Microsoft Online service (MSOL) a.k.a. AzureAD v1
- Installs MSOnline module if not available

### Fix

- correction SCC function unit test to SCC script (calles wrong script for test)
- Manifest tags compatible for powershellgallery.com upload by removing spaces
- removing Umlauts

## v0.0.6

### New

- #5 Adding support for Office365 Security & Compliance Center
- #6 Adding support for Azure ActiveDirectory (AzureAD, AAD) v2

### Fix

- correction SCC function unit test to SCC script (calles wrong script for test)

## v0.0.5

- #2 Adding support for SharePoint Online service (SPO)
- Adding generated psm1 docs to docs dir in src

## v0.0.4

- #3 Adding support for MS Teams service (Teams)
- Adding additional docs for Installation and Usage

## v0.0.3

- #1 Adding support for MS Exchange Online service (EOL)

## v0.0.2

- Manifest tags compatible for powershellgallery.com upload by removing spaces
- removing Umlauts

## v0.0.1

- Adding support for Microsoft Online service (MSOL) a.k.a. AzureAD v1
- Installs MSOnline module if not available

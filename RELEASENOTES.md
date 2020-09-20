# ReleaseNotes Connect-MS365

Powershell module to connect to all MS365 services and install required packages.

(c) by [Matthias Fleschuetz](https://github.com/blindzero)
[https://github.com/blindzero/Connect-MS365](https://github.com/blindzero/Connect-MS365)

## ToDos / Wishlist

- [#19](https://github.com/blindzero/Connect-MS365/issues/19) Azure CLI
- [#9](https://github.com/blindzero/Connect-MS365/issues/9) Proxy Support
- [#21](https://github.com/blindzero/Connect-MS365/issues/21) CSP connections support
- [#23](https://github.com/blindzero/Connect-MS365/issues/23) user config files
- adding PSDeply for Github and PSGallery release

## v1.3.0

### New Features

- config file in $env:LOCALAPPDATA\Connect-MS365\Connect-MS365.Config.psd1 for deffault user settings
  - initializes automatically if not existing
  - switch to re-initialize config if existing ```Connect-MS365 -ReInitConfig```
- config ```DefaultUserPrinicipalName``` to avoid UPN input, used by
  - EOL
  - S4B
  - SCC

### Changes

- implementing Azure Pipelines
  - splitting build tasks in separate files
  - psakeFile depending on BHBuildEnvironment
  - adding azure-pipelines.yml
- scope of installed powershell modules changed to 'CurrentUser'

### Fixes

- Fix AAD module installer

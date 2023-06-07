# Connect-MS365

## 01-INSTALLATION

### Prerequisites

The following requirements must be installed _prior_ installation of Connect-MS365.

* [PowerShell v5.1](https://www.microsoft.com/en-us/download/details.aspx?id=54616) or
  [PowerShell v7.3.4](https://github.com/PowerShell/powershell/releases)

  Check your PS version with `$PSVersionTable`.
  We need at least Version 5.1 on Desktop edition.
  Core edition is tested with PowerShell 7.3.4, but may work with earlier versions as well.

* [PowerShellGet](https://learn.microsoft.com/en-us/powershell/gallery/powershellget/overview)
  (should be available automatically)

  Check if available with
  
  ```powershell
  Find-Module PowerShellGet -ListAvailable
  ```

  Otherwise install with
  
  ```powershell
  Install-Module -Name PowerShellGet -Force
  ```

* [ExchangeOnlineManagement Module v3](https://www.powershellgallery.com/packages/ExchangeOnlineManagement) - if used with PS Core 7

  It is recommended to use EXOv3 module with PowerShell 7 as authentication issues may occure if older EXO modules are used.
  If you face any issue that authentication libraries cannot be loaded, make sure that EXOv3 is installed and available for `Connect-MS365`.

### Installation

#### Install by Install-Module from PowerShellGallery

Installation from online [PowerShellGallery](https://powershellgallery.com) by using PowerShellGet function `Install-Module`.

```powershell
Install-Module Connect-MS365
```

#### Manual Installation

With this method you may install Connect-MS365 manually to your PowerShell environment.

1. __Download Connect-MS365__ from one of the following sources

   * [PowerShellGallery Package](https://www.powershellgallery.com/packages/Connect-MS365#manual-download)

   * [GitHub](https://github.com/blindzero/Connect-MS365/releases)

2. __Extract Package__ by unzipping the downloaded package.

3. __Install Connect-MS365 Module__

   Put the extracted packages content into one of the PowerShell module directories which automatically loads the module:

   * `$env:USERPROFILE\Documents\WindowsPowerShell\modules`
   * `$env:ProgramFiles\WindowsPowerShell\Modules`

### Verify

After installation open a new powershell session and verify the availability of `Connect-MS365` command.

```powershell
Get-Module Connect-MS365 -ListAvailable
```

## Usage

see [02-USAGE.md](/docs/02-USAGE.md) for usage instructions

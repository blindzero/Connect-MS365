![PowerShell Gallery Version (including pre-releases)](https://img.shields.io/powershellgallery/v/Connect-MS365?include_prereleases)
![PowerShell Gallery](https://img.shields.io/powershellgallery/dt/Connect-MS365)

[![Build and Compile Master](https://github.com/blindzero/Connect-MS365/actions/workflows/master-compile.yml/badge.svg)](https://github.com/blindzero/Connect-MS365/actions/workflows/master-compile.yml)

![GitHub milestone](https://img.shields.io/github/milestones/progress/blindzero/Connect-MS365/5)
![GitHub pull requests](https://img.shields.io/github/issues-pr-raw/blindzero/Connect-MS365)
![GitHub issues](https://img.shields.io/github/issues-raw/blindzero/Connect-MS365)
![GitHub closed issues](https://img.shields.io/github/issues-closed-raw/blindzero/Connect-MS365)

# Connect-MS365

Powershell module to connect to all MS365 services and install required modules or packages.

## Purpose

Did you ever the experience that it's complicated to deal with multiple of the different Microsoft cloud-based services and have to remember the specific modules to add, commands to use to connect?
So did I and found myself always looking them up again and again, especially for those used more rarely.

That's all what this module is about: it delivers one central CmdLet function which can be executed to connect to one or many of Microsoft's services and you don't have to care about the single service connection commands.
Additionally it checks and installs the right modules or packages if necessary.

It is inspired by Connect-Office365 by [Bradley Wyatt](https://github.com/bwya77) which I found and used for a while.
As it wasn't published it was something I had to keep and distribute again and again.
Additionally I wanted to add some advanced functions like installing and updating the dependant Microsoft modules.

## Limitations

Unfortunately, adding PowerShell Core support (a.k.a. PowerShell 7) brought some limitations for supported Microsoft 365 services as the required modules do not support PowerShell Core. 
Following Microsoft 365 services are _**NOT**_ supported when using PowerShell 7 / PowerShell core:

* SharePoint Online (SPO)
* Microsoft Online (MSOL)
* Microsoft Azure AD (AAD)

## Documentation

See the [docs](/docs) directory for full documentation.

* Release Notes: [RELEASENOTES.md](RELEASENOTES.md)
  Previous Versions: [00-RELEASENOTES.md](/docs/00-RELEASENOTES.md)
* Installation: [01-INSTALLATION.md](/docs/01-INSTALLATION.md)
* Usage: [02-USAGE.md](/docs/02-USAGE.md)

## License

Connect-MS365 is licensed under terms of GNU Lesser General Publice License (LGPL) v3.0.
For further information see [LICENSE](/LICENSE) file.

## Contribute

As this is my pretty first public PS module project I share, please feel free to comment, feedback and contribute to this.

### Environment

I use the following toolstake to develop and distribute this module:

* PSdepend - defining depencies within the build process, so that they can be installed automatically when needed
* Pester - for simple testing
* psake - task automation for the build process

For further details please see [03-CONTRIBUTE](/docs/03-CONTRIBUTE.md)

### Maintainer

* [blindzero](https://github.com/blindzero)
* ...anybody else?

<!-- TOC URLs -->
[Purpuse]: #purpose
[Documentation]: #documentation
[License]: #license
[Contribute]: #contribute

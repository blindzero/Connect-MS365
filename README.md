# Connect-MS365
Powershell module to connect to all MS365 services and install required packages.

## Purpose

Didn't you had the experience that you find it quite complicated if you have to deal with multiple of the different Microsoft cloud-based services and have to remember the specific modules to add, commands to use to connect and so on?
So did I and I found myself always looking them up again and again, especially for those used more rarely.

That's all what this module is about: it delivers one central CmdLet function that can be executed to connect to one or many of Microsoft's services and you don't have to care about the single service connection commands anymore.
Additionally it checks and installs the right module right away if necessary.

It is inspired by Connect-Office365 by [Bradley Wyatt](https://github.com/bwya77) which I found and used quite a while. As it wasn't published it was something I had to keep, maintain and distribute in our team again and again. Additionally I wanted to add some other advanced functions like installing and updating the dependant Microsoft modules.

## Documentation

See the [docs](/docs) directory for full documentation.

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
[Documentation]: #documentations
[License]: #license
[Contribute]: #contribute

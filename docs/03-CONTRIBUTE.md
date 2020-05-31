# Connect-MS365 > 03-CONTRIBUTE

This documentation should help everybody who want to contribut to this project.
Primarily it shall explain basic principals in the design of this module as well as development workflows and requirements.

## Structure

_How are project files organized and structured?_

```bash
. PowerShell Module Project Root
|__ .github                  |  all Github related files as workflows, issue or pull request templates
|__ .vscode                  |  all shared VSCode and related settings, tasks and scripts (e.g. local git hooks)
|__ build                    |  build tools (PSake properties, psakeFiles)
|   |__ tasks                |  PSake build task includes
|   |__ dependencies.psd1    |  PSDepend build dependencies
|   \__ psakeFile.{ENV}.ps1  |  PSake build definitions (for each build environment)
|__ BuildOutput              |  default build output directory
|__ docs                     |  static docs for manual reading (generated doc added by build task)
|__ src                      |  all module code files
|   |__ Private              |  all 'private' functions, helpers, ...
|   |   \...                 |  
|   |__ Public               |  all 'public', main functions
|   |   \...                 |  
|   |__ Connect-MSS65.psd1   |  module manifest file
|   \__ Connect-MSS65.psm1   |  main module code
|__ tests                    |  all Pester scripts
|   |__ Connect-MS365.Tests.ps1
|   \...                     |
|__ .gitignore               |  standard .gitingore
|__ build.ps1                |  main build script used to start build tasks (psake)
|__ LICENSE                  |  general license information
|__ README.md                |  general README info
\__ RELEASENOTES.md          |  Release history information
```

## Git

### .gitignore

_What should be ignored? ...and what shouldn't?_

* __BuildOutput__ all build outputs should not be committed. If something is generated that needs to be used somewhere else, the build task has to care about pubishing this artifact to another location or system.
This does _not_ include 'build' as this is our default directory for all build-related tools. 

* __IDE configuration__ some settings of your IDE configuration that might include personal information / local system specific things, e.g. .vscode/extensions.json
.vscode/launch.json. What I shared is ```tasks.json``` as it may help others as well to have all common sense on IDE task configuration?
_I also added Git Hook scripts into .vscode (although it is not really vscode-specific, I know) for local Git environments to have consistency through all contributors._

### Commit (messages)

__No commits without message! NOT ONE!__

We are talking about contributing, right? That means at least we are two persons that are working on the same code and might want to understand what the hack the other one was doing...

Commit messages are required!

* __add issue number__ (#) reference in the beginning (if it is issue related); if many issues exist, please reference them all
* __do more commits!__ it is always easier to have precise commit messages if you have more but smaller commits. I personally don't like huuuuge commits with messages like "added one very large module" (which contains 1254 changes, adds and deletes)
* __push!__ as you should have a branch anyway (see below), there is no reason to delay your push (at least if some tested, working state is there). We want to participate from your work and may want to give feedback or take over if you don't want to continue with it.

### Branches & Tags

* __master__  our main developent tree, always the latest state in development
* __feature/abc__ please branch your work for new features into a feature-branch and please use ```feature/```-prefix.

### Signing

__Please sign your commits with your gpg key!__

If you don't do this yet, here is the best [Windows-related documentation](https://jamesmckay.net/2016/02/signing-git-commits-with-gpg-on-windows/) about automatically signing git commits with Windows.

### Git Hooks

At the moment we don't use any local Git hooks. I tend to use Notary (vcn) service, but as this is too complicated and doesn't scale very good I disabled that.

## Development

### Coding

Well...it's just a PowerShell module and I am not a coder myself...so what can I tell...?

Most important is:

* all module source stays in ```src``` directory, all other directories have general or other purposes
* the main module ```Connect-MS365.psm1``` is just invoking ```Connect-<Service>``` cmdlets again
* ```Connect-<Service>``` cmdlets are provided by individual functions in single ```.ps1```-files in ```src\Public``` (although we don't export the functions)
* all other functions (helpers, ...) should be realized in individual ```.ps1```-files in ```src\Private``` (definetely not exported)
* please respect and maintain Manifest file (```Connect-MS365.psd1```)!

In general I try to stick to some basic PowerShell module best-practices I liked a lot when reading them at [Dr. Scripto](https://devblogs.microsoft.com/scripting/the-top-ten-powershell-best-practices-for-it-pros/) and at [powershell-guru.com](http://powershell-guru.com/).
Another nice one can be found at [PoshCode's GitHub](https://github.com/PoshCode/PowerShellPracticeAndStyle).

Yes, I know...it seems that even my fingers try to ignore some of them. So if you find anything to improve into those best practices...please feel free :grin:
* Don't use alias (write 'Set-Location' instead of 'cd', use )
* Don't rely on positional parameters (e.g. for Copy-Item we use -path and -destination)
* Use try-catch and some use the catch-part and use try{} for all actions considered as a transaction
* Avoid Out-Null cmdlet and redirecting to $null (for performance reasons). Better to cast to [void] `[void]$array.Add('A)` or assign to $null `$null = $array.Add('A')`
* Use single quotes for string (') instead of double quotes (") if not necessary, as they disable variable expansion and unexpected results are reduced
* Always Start With CmdletBinding and at least consider make use of its features as accepting pipelining.
* Write full sentences as inline comment documentation (for further details see below)

#### Naming Conventions and Formatting

* We use 'PascalCase' for all names (variables, module, functions, attributes, classes, enum, fields, constants, ...).
* We use 'lowercase' for language keywords (foreach, operators, ...)
* Please use Verb-Noun for cmdlets, functions, etc. and avoid plural nouns.
* We use '[One True Brace Style variant by K&R](https://github.com/PoshCode/PowerShellPracticeAndStyle/issues/81#issuecomment-285835313)': opening braces "{" are at end of line, closing braces "}" at the beginning of the line.
* 4 spaces are one indent
* limit outputs to max of 115 chars per line (e.g. PowerShell has default max of 120), consider use of "[Splatting](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_splatting?view=powershell-5.1)"
* Spaces around assignments, parameters and operators\
`$variable = Get-Content -Path $FilePath -Wait:($ReadCount -gt 0) -TotalCount ($ReadCount * 5)`

### Tests

We use _Pester_ and _PSScriptAnalyzer_ to have tests on our code.

There are the following three stages in testing:

* __Unit Tests__

  This are all tests that should be tested directly while developing and don't need any other components.
  They are executed by build task ```PesterUnit``` with ```Invoke-Pester -Tags Unit```.

* __Integration Tests__

  This are all tests that should be tested after build process which creates some additional components as well.
  They are executed by build task ```PesterUnit``` with ```Invoke-Pester -Tags Integration```.

* __Script Analyze__

  We use ```PSScriptAnalyzer``` to analyze our PowerShell code against some standard best practices.
  It is executed by build task ```Analyze``` with ```Invoke-ScriptAnalyzer```.
  
  Warnings are not blocking, Errors are blocking other succeeding build tasks.
  Some warnings can not be solved, e.g. it is complaining about Connect-Teams using a plural term Team_S_ what should be avoided...well...yeah...

#### What should be tested?

Well, I think here is a lot room to improve...

As I am not a developer I am not a testing specialist as well. At least I try to test the following parts:

* __main module__
  * is available itself
  * parameters of root module (Type, Mandatory, ...)
  * valid PowerShell code
  * manifest file available
* __functions__
  * parameters of functions (using ```InModuleScope```)
  * functions _not_ beeing available directly (outside ```InModuleScope```)
* __builded module (integration)__
  * valid manifest file
  * ExternalHelp XML is generated
  * root docs files are available

### Documentation

__Please maintain the documentation as well!__

If you contribute please update our documentation. This consists at least of the following

* __Inline Documentation__

  We use inline PowerShell documentation to automatically generate help files and outputs for ```Get-Help``` cmdlet.
  * Module's main inline documentation stays _outside_ the ```function()```
  * Functions` inline documentations stay _inside_ the ```functon()```
  * add semantic descriptional written sentences to explain your code steps
  
  This is a requirement by our automatic help generator...

* __Parameter Documentation__

  Please use inline documentation & ```HelpMessage``` for parameters:

  ```powershell
  param (
        # my inline comment for the $Module parameter
        [Parameter(Mandatory=$true,Position=1,HelpMessage="My Modules Helpmessage")]
        [String]
        $Module
    )
  ```

* __ReleaseNotes__

  Usually I have prepared ```src\RELEASENOTES.md``` with a skeleton for the next version when I have done a release.
  Just add some line to ```New Features```, ```Changes``` or ```Fixes```.
  The line should be in the format of:

  ```markdown
  - #<IssueId> description / title as in RELEASENOTES.md
  ```

* __docs\*.md Files__

  Please maintain ```.md```-files in ```docs``` accordingly.
  If something changes in installation process: ```01-INSTALLATION.md```
  If you add / change functionality that is directly invoked by the user, please maintain ```02-USAGE.md```.

  _There is no need to manually maintain ```Connect-MS365.md``` as it is automatically generated by our build process.

### Build

:info: We provide two ways of building our stuff:

1. __manual compile, build, test with `build.ps1`__

   This is primarily meant to be used within development before committing / pushing your code into the repository, you get similiar results as our CI would deliver later.

   Just call ```build.ps1 [-Task]<taskname>``` to execute one of the build tasks.
   Build outputs are created in ```BuildOutput```-directory with ```<ModuleName>``` subfolder.

   It supports the following parameters:

   * ```-Task <taskname>```

     The name of build task, defined in ```psakeFile.ps1```. If dependencies are defined, depending tasks are executed first.

   * ```-Bootstrap```

     This executes a bootstrap procedure and sets up all necessary modules.
     For details see below.

   * ```-Help```

     Displays Help and lists all defined build tasks

2. __CI / CD with AppVeyor__

   We have an [AppVeyor project](https://ci.appveyor.com/project/blindzero/connect-ms365) for CI / CD pipelining.

   It is building and testing on _all branches_, except for update of `*.md`-files and commit messages include something as\
   `update readme.*|update readme.*s|update docs.*|update version.*|*readme*`.

   It is performing tests and creates an artifact zip-file `Connect-MS365-vX.Y.<buildnumber>.zip`.

   AppVeyor is configured in [appveyor.xml](https://github.com/blindzero/Connect-MS365/blob/master/appveyor.yml).

   __Later: (TODO)__\
   Deployments (see below) are triggered on `master`-branch commits that don't have any PR number.

#### Build Requirements / Dependencies

The following other modules and tools are needed as dependencies for our build environment:

*  __PowerShellGet__ and __NuGet__\
   [PowerShellGet](https://github.com/PowerShell/PowerShellGet) provides latest interfaces for PowerShellGallery.com where we are fetching our dependencies from and want to publish our stuff later together with [NuGet](https://github.com/PowerShellOrg/NuGet).
* __PSDepend__\
   [PSDepend](https://github.com/RamblingCookieMonster/PSDepend) is really a nice module to define depending modules in one `dependencies.psd1` file with versions and let them be processed all together.
* __PSake__\
   We use [PSake](https://github.com/psake/psake) as our build task tool.
* __BuildHelpers__\
   [BuildHelpers](https://github.com/RamblingCookieMonster/BuildHelpers) is another module from really appreciated work of "RamblingCookieMonster". It helps to set up some consistent env variables for the build process. It e.g. provides an easy way to differentiate between AppVeyor and manual environment, provides additional Git information.
* __Pester__\
   What else should we use as the well-known PowerShell testing framework [Pester](https://github.com/pester/Pester) for our unit and integration testings?
* __PSScriptAnalyzer__\
   Another module to provide information on PowerShell code quality and standard is [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)
* __platyPS__\
   [platyPS](https://github.com/PowerShell/platyPS) is used to generate external help files in MarkDown.

#### PSake Build Tasks

_Both_ build processes use [PSake](https://github.com/psake/psake) for build automation.
PSake is using `psakeFile` definitions for its tasks and workflows (dependencies, descriptions).
As both processes have different needs we extended this by the following logic:

1. `build.ps1` is providing basic invocation wrapper.\
   It detects the build environment ($env:BHBuildEnvironment).
2. The `$psakeFile` is defined based on the schema `psakeFile.<Environment>.ps1`. Manual builds are using `Unknown`.
3. `Invoke-PSake` is called and the `$psakeFile` is passed.

The following build tasks are defined for _manual build_ and depend on each other:

| Task | Description | Depends On (Unknown) | Depends On (AppVeyor) |
| --- | --- | --- | --- |
| __Init__ |Initializing some stuff (here just some info output)|||
| __Clean__ |Removes existing build outputs in build directory| `init`||
| __Compile__ (__default__)|Creates build output directory; 'compiles' one large `psm1`-file by concatenating Private and Public ps1 into psm1 file|`Clean`|`Clean`|
|__Analyze__|Invoking `PSScriptAnalyzer`, puts result output to build directory|`Compile`||
|__PesterUnit__|Runs Pester Tests with `-Tag Unit`|`Compile`||
|__TestUnit__|wrapper task|`Analyze, PesterUnit`|`Analyze, PesterUnit`|
|__CreateMDHelp__|generates module MD file by using `New-MarkdownHelp`|`Compile`|`Compile`|
|__UpdateMDHelp__|updates generated module MD file by using `Update-MarkdownHelpModule`|`CreateMDHelp`|`CreateMDHelp`|
|__CreateExternalHelp__|generates external help XML file from compiled `psm1`-file by using `New-ExternalHelp`|`UpdateMDHelp`|`UpdateMDHelp`|
|__GenerateHelp__|wrapper task|`CreateExternalHelp`|`CreateExternalHelp`|
|__Build__|adding additional content (GeneratedHelp header to psm1, LICENSE.md, README.md and RELEASENOTES.md files, ...) to build output|`Compile, CreateExternalHelp`|`Compile, CreateExternalHelp`|
|__PesterIntegration__|Runs Pester Tests with `-Tag Integration`|`Build`||
|__TestIntegration__|wrapper task|`Analyze, PesterIntegration`|`Analyze, PesterIntegration`|
| __Publish__ |Publishs module from build output directory to PowerShellGallery by `Publish-Module` after complete Integration run|`TestIntegration`||

#### Build Workflow

So what I usually do is, 

1. Develop my stuff, including tests
2. Execute `build.ps1 PesterUnit`, this will Compile psm1-file and test it
3. Do manual testing by

   * Import compiled module by using `Import-Module -Force <buildOutDir>\<modulename>\<modulename.psd1>`
   * do you testing...

4. Execute Integration Testing (will include all other important tasks) `build.ps1 TestIntegration`
5. Commit / Push / PR

## Releasing

In future, releasing should be done automatically by AppVeyor CI/CD workflow.
Until then, it is a manually process.

### Versioning

We use standard [SemVer versioning](https://semver.org/), which means ```X.Y.Z```

* X --> MAJOR - a major change that makes APIs etc. incompatible or has really huge / important changes or added functionality (yeah very precise, I know :wink: ).
  
  I would call it a _upgrade_.
* Y --> MINOR - adding new functionality which is backward compatible.

  I refer to this as _update_.

* Z --> BUILD - the buildnumber, generated by AppVeyor CI/CD.

It might be that fixes are not released separately but included in next minor version update.

### Workflow

1. __PowerShellGallery__

   We are releasing directly to [powershellgallery.com](https://powershellgallery.com) by using our build task ```build.ps1 Publish```.

   Publishing requires a version counter increase, otherwise publishing will fail. You need a API Key that needs to be set in your systems environment as ```NUGET_API_KEY``` (if you get this from me, I really really trust you :blush: ).

2. __Github__

   Additionally create a release on our [Github page](https://github.com/blindzero/Connect-MS365/releases).

   * __Tag__: vX.Y.Z (usually from master, as long as we don't have to many people working on master)
   * __Title__: vX.Y.Z
   * __Text__: I use the following template:

   ```markdown
   # Connect-MS365 vX.Y.Z

   :wave: Hi there, the first feature update release is out!
   Please share your Feedback, create Issues or raise your your Questions at our GitHub Issues.

   ## New Features

   - #<IssueId> description / title as in RELEASENOTES.md

   ## Changes

   - #<IssueId> description / title as in RELEASENOTES.md

   ## Fixes

   - #<IssueId> description / title as in RELEASENOTES.md

   ## Documentation

   * Install: [01-INSTALL.md](https://github.com/blindzero/Connect-MS365/blob/master/docs/01-INSTALLATION.md)
   * Usage: [02-USAGE.md](https://github.com/blindzero/Connect-MS365/blob/master/docs/02-USAGE.md)
   ```

   * __Binaries__: I stopped manually attaching a nuget-package. If users want manual installations...they should have a look at powershellgallery.com.

## Contributing

The easiest way to contribute is:

* just create your fork in Github
* do your stuff
* create a pull request

### Pull Request

The pull request shall contain

* "[#IssueId] Title"
* Detailed description what you did to achieve the title. What did you add? What did you change or delete? What is the improvement?

### Direct Contribution

If you want to contribute directly, please contact us directly by creating an [issue](https://github.com/blindzero/Connect-MS365/issues/new?labels=question&template=question.md&title=Direct%20contributor%20rights). But please understand that I will have some check here first...

## Contributors

* [blindzero](https://github.com/blindzero)
* [RasmusAaen](https://github.com/RasmusAaen)

<!-- TOC URLs -->
[Structure]: #structure
[Git]: #git
[Development]: #development
[Contributors]: #contributors

# Connect-MS365 > 03-CONTRIBUTE

This documentation should help everybody who want to contribut to this project.
Primarily it shall explain basic principals in the design of this module as well as development workflows and requirements.

## Structure

_How are project files organized and structured?_

```bash
. PowerShell Module Project Root
|__ .github                  |  all Github related files as workflows, issue or pull request templates
|__ .vscode                  |  all shared VSCode and related settings, tasks and scripts (e.g. local git hooks)
|__ build                    |  default build output directory
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
|__ dependencies.psd1        |  build dependencies for PSDepend
|__ LICENSE                  |  general license information
|__ psakeFile.ps1            |  build task definitions (PSake)
|__ README.md                |  general README info
\__ RELEASENOTES.md          |  Release history information
```

## Git

### .gitignore

_What should be ignored? ...and what shouldn't?_

* __build__ all build outputs should not be committed. If something is generated that needs to be used somewhere else, the build task has to care about pubishing this artifact to another location or system

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

### Hooks

At the moment we don't use any local Git hooks. I tend to use Notary (vcn) service, but as this is too complicated and doesn't scale very good I disabled that.

## Development

### Coding

Well...it's just a PowerShell module and I am not a coder myself...so what can I tell...?

Most important is:

* all module source stays in ```src``` directory, all other directories have general or other purposes
* the main module ```Connect-MS365.psm1``` is just invoking ```Connect-<Service>``` cmdlets again
* ```Connect-<Service>``` cmdlets are provided by individual functions in single ```.ps1```-files in ```src\Public``` (although we don't export the functions)
* all other functions (helpers, ...) should be realized in individual ```.ps1```-files in ```src\Private``` (definetely not exported)
* please respect and maintain Manifest file (```Conect-MS365.psd1```)!

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
        [Parameter(Mandatory=$True,Position=1,HelpMessage="My Modules Helpmessage")]
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

Some words about building everything...

Just call ```build.ps1 [-Task]<taskname>``` to execute one of the build tasks.
Build outputs are created in ```build```-directory with subfolders for ```<ModuleName>\<VersionByManifest>```.

It supports the following parameters:

* ```-Task <taskname>```

  The name of build task, defined in ```psakeFile.ps1```. If dependencies are defined, depending tasks are executed first.

* ```-Bootstrap```

  This executes a bootstrap procedure and sets up all necessary modules:

  * Install Nuget PackageProvider
  * Setting ```PSGallery``` as ```PSRepository```
  * Install [PSDepend](https://github.com/RamblingCookieMonster/PSDepend)
  * ```PSDepend``` processes all dependencies from ```dependencies.psd1```

* ```-Help```

  Displays Help

#### PSake Build Tasks

We use [PSake](https://github.com/psake/psake) for build automation.
PSake is using ```psakeFile.ps1``` for definition of build tasks.
Build tasks can have dependencies to execute predeccessing tasks they depend on.

The following build tasks are defined and depend on each other:

| Task | Description | Depends On |
| --- | --- | --- |
| __Init__ |Initializing some stuff (here just some info output)||
| __Clean__ |Removes existing build outputs in build directory| ```init```|
| __Compile__ |Creates build output directory; 'compiles' one large ```psm1```-file by concatenating Private and Public ps1 into psm1 file|```Clean```| 
|__PesterUnit__|Runs Pester Tests with ```-Tag Unit```|```Compile```|
|__GenerateHelp__|wrapper task|```UpdateMarkdownHelp, CreateExternalHelp```|
|__CreateExternalHelp__|generates external help XML file from compiled ```psm1```-file by using ```New-ExternalHelp```|```CreateMarkdownHelp```|
|__CreateMarkdownHelp__|generates module MD file by using ```New-MarkdownHelp```|```Compile```|
|__UpdateMarkDownHelp__|updates generated module MD file by using ```Update-MarkdownHelpModule```|```CreateMarkdownHelp```|
|__Build__|adding additional content (GeneratedHelp header to psm1, LICENSE.md, README.md and RELEASENOTES.md files, ...) to build output|```Compile, UpdateMarkDownHelp, CreateExternalHelp```|
|__TestIntegration__ (__default__)|wrapper task|```Analyze, PesterIntegration```|
|__Analyze__|Invoking ```PSScriptAnalyzer```, puts result output to build directory|```Compile```|
|__PesterIntegration__|Runs Pester Tests with ```-Tag Integration```|```Build```|
| __Publish__ |Publishs module from build output directory to PowerShellGallery by ```Publish-Module``` after complete Integration run|```TestIntegration```|

#### Build Workflow

So what I usually do is, 

1. Develop my stuff, including tests
2. Execute ```build.ps1 PesterUnit```, this will Compile psm1-file and test it
3. Do manual testing by

   * Import compiled module by using ```Import-Module -Force <buildOutDir>\<modulename>\vx.y.z\<modulename.psd1>```
   * do you testing...

4. Execute Integration Testing (will include all other important tasks) ```build.ps1 TestIntegration```
5. Commit / Push / PR

## Releasing

### Versioning

We use standard [SemVer versioning](https://semver.org/), which means ```X.Y.Z```

* X --> MAJOR - a major change that makes APIs etc. incompatible or has really huge / important changes or added functionality (yeah very precise, I know :wink: ).
  
  I would call it a _upgrade_.
* Y --> MINOR - adding new functionality which is backward compatible.

  I refer to this as _update_.

* Z --> PATCH - a fix, patch or whatever that should only repair broken things.

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

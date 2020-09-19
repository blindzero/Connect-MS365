[CmdletBinding(DefaultParameterSetName = 'Task')]
param (
    # build tasks to execute
    [Parameter(ParameterSetName = 'Task', Position = 0)]
    [string[]]
    $Task = 'default',

    # bootstrap dependencies needed
    [switch]
    $Bootstrap,

    # list available build tasks
    [Parameter(ParameterSetName = 'Help')]
    [switch]
    $Help
)

$ErrorActionPreference = 'Stop'

# start bootstrapping when switch is set
if ($Bootstrap.IsPresent) {
    $null = Get-PackageProvider -Name Nuget -ForceBootstrap
    # add PSGallery as repository to install packages
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    # test if PSDepend is not available...
    if (!(Get-Module -Name PSDepend -ListAvailable)) {
        # and install PSDepend as it will handle all other installations
        Install-Module -Name PSDepend -Scope CurrentUser -Repository PSGallery
    }
    # import PSDepend separately after installing
    Import-Module -Name PSDepend -Verbose:$false
    # install all other dependencies by PSDepend
    Invoke-PSDepend -Path '.\build\dependencies.psd1' -Install -Import -Force -Recurse:$true -WarningAction SilentlyContinue
    # and then install as we do not do anything else
    exit 0
}

# run psake for building itself

# setup build environment with BuildHelpers and manual variables
Write-Verbose "Invoke BuildHelpers"
# get buildhelper environment
Set-BuildEnvironment -Force

# set build dir from buildhelpers project path (base) + build
$buildDir           = Join-Path -Path $env:BHProjectPath -ChildPath 'build'
Write-Verbose "Using `$buildDir: $buildDir"
# set build task dir from buildhelpers project path (base) + tasks
$buildTasksDir      = Join-Path -Path $buildDir -ChildPath 'tasks'
Write-Verbose "Using `$buildTasksDir: $buildTasksDir"

# define psakeFile depending on BHBuildSystem
$psakeFile = (Join-Path -Path $buildDir -ChildPath "psakeFile.$env:BHBuildSystem.ps1")
Write-Verbose "Using `$psakeFile: $psakeFile"

# getting psake properties
$psakePropertiesFile = (Join-Path -Path $buildDir -ChildPath 'psake.properties.ps1')
Write-Verbose "Using `$psakeProperties: $psakePropertiesFile"

# getting psake task files to include in psake 
$taskFiles = (Get-Item -Path (Join-Path -Path $buildTasksDir -ChildPath '*.ps1'))
Write-Verbose "Found `$taskFiles: $taskFiles"

# assemling properties array to be passed to psake from all variables before
$psakeParameters = @{
    "buildDir" = $buildDir;
    "buildTasksDir" = $buildTasksDir;
    "psakeFile" = $psakeFile;
    "psakePropertiesFile" = $psakePropertiesFile;
    "taskFiles" = $taskFiles
}

if ($PSCmdlet.ParameterSetName -eq 'Help') {
    # getting defined psake tasks and formatting help output
    Get-PSakeScriptTasks -buildFile $psakeFile |
        Format-Table -Property Name, Description, Alias, DependsOn
}
else {
    Write-Verbose "Tasklist: $Task"
    # real psake invoke with tasks and defined psakefile
    Invoke-Psake -buildFile $psakeFile -taskList $Task -parameters $psakeParameters -nologo
    exit ( [int](! $psake.build_success ))
}
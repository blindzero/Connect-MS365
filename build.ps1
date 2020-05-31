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

if ($Bootstrap.IsPresent) {
    Get-PackageProvider -Name Nuget -ForceBootstrap | Out-Null
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
    if (!(Get-Module -Name PSDepend -ListAvailable)) {
        Install-Module -Name PSDepend -Scope CurrentUser -Repository PSGallery
    }
    Import-Module -Name PSDepend -Verbose:$false
    Invoke-PSDepend -Path '.\build\dependencies.psd1' -Install -Import -Force -Recurse:$true -WarningAction SilentlyContinue
    exit 0
}

# run psake itself

# setup build environment with BuildHelpers and manual variables
Write-Verbose "Invoke BuildHelpers"
Set-BuildEnvironment -Force

$buildDir           = Join-Path -Path $env:BHProjectPath -ChildPath 'build'
Write-Verbose "Using `$buildDir: $buildDir"
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

# assemling properties array to be passed to psake
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
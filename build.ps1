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
    Import-Module -Name PSDepend -Verbose:$False
    Invoke-PSDepend -Path '.\dependencies.psd1' -Install -Import -Force -Recurse:$true -WarningAction SilentlyContinue
    exit 0
}

# run psake itself

# setup build environment
Set-BuildEnvironment -Force

# define psakeFile depending on BHBuildSystem
if ($BHBuildSystem -eq "AppVeyor") {
    $psakeFile = '.\appveyor.psakeFile.ps1'
}
else {
    $psakeFile = '.\psakeFile.ps1'
}

if ($PSCmdlet.ParameterSetName -eq 'Help') {
    Get-PSakeScriptTasks -buildFile $psakeFile |
        Format-Table -Property Name, Description, Alias, DependsOn
}
else {
    if $Invoke-Psake -buildFile $psakeFile -tasklist $Task -nologo
    exit ( [int](! $psake.build_success ))
}
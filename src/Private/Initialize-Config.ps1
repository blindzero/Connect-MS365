function Initialize-Config {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false,Position=1,HelpMessage="Force switch needed if existing config files should be overrided")]
        [switch]$Force = $false
    )

    <#
    .SYNOPSIS
    Initializes Configuration directory and file if not present.

    .DESCRIPTION
    Initializes Configuration directory and file if not present.
    Uses default template from modules installation directory and puts it to User scope.
    Can be forced by $Force switch parameter.

    .PARAMETER Force
    $Force can be given if the existing files should be overwritten.

    .INPUTS
    None. You cannot pipe objects to Add-Extension.

    .OUTPUTS
    None.

    .EXAMPLE
    PS> Initialize-Config

    .LINK
    http://github.com/blindzero/Connect-MS365

    #>

    # get default config file from module installation path
    $DefaultConfigDir = (Split-Path -Path (Get-Module -Name Connect-MS365).Path -Parent)
    $ConfigFileName = "Connect-MS365.Config.psd1"
    # where the file is within Configuration sub dir
    $DefaultConfigFilePath = "$($DefaultConfigDir)\Configuration\$($ConfigFileName)"
    # destination directory for configfiles
    $ConfigDir = "$($env:LOCALAPPDATA)\Connect-MS365\"
    $ConfigPath = "$($ConfigDir)\$($ConfigFileName)"

    # check if config directory exists
    if (!(Get-Item -Path $ConfigDir -ErrorAction SilentlyContinue)) {
        $null = (New-Item -Path $ConfigDir -ItemType Directory)
        Write-Verbose "Config directory created: $ConfigDir"
    }
    else {
        Write-Verbose "Config directory $ConfigDir already exists. Skipping."
    }

    # if we want to enforce new file OR the file is not existing
    if (($Force) -or (!(Get-Item -Path $ConfigPath -ErrorAction SilentlyContinue))) {
        # we place the default file in our config dir
        Write-Verbose "Initializing config file from $DefaultConfigFilePath to $ConfigPath"
        Copy-Item -Path $DefaultConfigFilePath -Destination $ConfigPath -Force:$Force
    }
    else {
        # just verbose output that nothing is done
        Write-Verbose "Config file $ConfigPath already exists. Skipping."
    }
}

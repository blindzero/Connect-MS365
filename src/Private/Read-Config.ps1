function Read-Config {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$False,Position=1,HelpMessage="path and filename to configfile to read")]
        [string]$ConfigFile = "$($env:LOCALAPPDATA)\Connect-MS365\Connect-MS365.Config.psd1"
    )

    <#
    .SYNOPSIS
    Reads Configuration variables from given configfile.

    .DESCRIPTION
    Reads Configuration variables from given configfile.
    Uses default config dir place, if no other configfile path is passed.

    .PARAMETER ConfigFile
    String parameter for configuration path and file to read configuration from.

    .INPUTS
    None. You cannot pipe objects to Add-Extension.

    .OUTPUTS
    None.

    .EXAMPLE
    PS> Read-Config

    .LINK
    http://github.com/blindzero/Connect-MS365

    #>

    # test if given config file is available
    if (Test-Path -Path $ConfigFile) {
        # Import all from given config file 
        try {
            $Config = Import-PowerShellDataFile -Path $ConfigFile
            Write-Verbose -Message "Config successfully read from $ConfigFile to `$Config"
            if ($VerbosePreference -eq "Continue") {
                foreach ($ConfEntry in $Config.GetEnumerator()) {
                    Write-Verbose -Message "Config $($ConfEntry.Key) = $($ConfEntry.Value)"
                }
            }
            return $Config 
        }
        catch {
            $ErrorMessage = $_.Exception.Message
            Write-Error -Message "Could not read configfile $ConfigFile.`n$ErrorMessage" -Category OpenError
            throw
        }
    }
    else {
        Write-Error -Message "No config file found at $($ConfigFile). It should be initialized automatically if not existing?!" -Category ObjectNotFound
        throw
    }
}

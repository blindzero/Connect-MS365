function Install-MS365Module {
    [CmdletBinding()]
    param (
        # service module to be installed, must be known service
        [Parameter(Mandatory=$True,Position=1)]
        [String]
        $Module
    )

    <#
    .SYNOPSIS
    Installs modules to connect for a given service.

    .DESCRIPTION
    Installs modules to connect for a given service.
    ModuleName name needs to be passed.

    .PARAMETER Module
    Name of powershell module to install.

    .INPUTS
    None. You cannot pipe objects to Add-Extension.

    .OUTPUTS
    // <OBJECTTYPE>. TBD.

    .EXAMPLE
    Install-MS365Module -Module MSOnline

    .LINK
    http://github.com/blindzero/Connect-MS365

    #>
    
    $InstallChoice = Read-Host -Prompt "Module $Module is not present or update was triggered. Perform Install? (Y/n)"
    If (($InstallChoice.Length -eq 0) -or ($InstallChoice.ToLower() -eq "y")) {
        try {
            Install-Module -Name $Module -Scope CurrentUser -Force -ErrorAction Stop
        }
        catch {
            $ErrorMessage = $_.Exception.Message
            Write-Error -Message "Could not install Module $ModuleName.`n$ErrorMessage" -Category ConnectionError
            Break
        }
        continue
    }
}

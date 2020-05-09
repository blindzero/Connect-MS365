function Install-MS365Module {
    [CmdletBinding()]
    param (
        # service module to be installed, must be known service
        [Parameter(Mandatory=$True,Position=1)]
        [ValidateSet('MSOL','EOL','Teams','SPO','SCC','AAD')]
        [String]
        $Service
    )

    <#
    .SYNOPSIS

    Installs modules to connect for a given service.

    .DESCRIPTION

    Installs modules to connect for a given service.
    Service name needs to be passed.

    .PARAMETER Service
    Name of service to check installed modules for.

    .INPUTS

    None. You cannot pipe objects to Add-Extension.

    .OUTPUTS

    // <OBJECTTYPE>. TBD.

    .EXAMPLE

    Install-MS365Module -Service MSOL

    .LINK

    http://github.com/blindzero/Connect-MS365

    #>

    switch($Service) {
        MSOL {
            $ModuleName = "MSOnline"
        }
        {($_ -eq "EOL") -or ($_ -eq "SCC")} {
            $ModuleName = "ExchangeOnlineManagement"
        }
        Teams {
            $ModuleName = "MicrosoftTeams"
        }
        SPO {
            $ModuleName = "Microsoft.Online.SharePoint.PowerShell"
        }
        AAD {
            $ModuleName = "AzureAD"
        }
    }

    $InstallCommand = "-Command &{ Install-Module -Name $ModuleName -Scope AllUsers }"
    $InstallChoice = Read-Host -Prompt "$ModuleName Module is not present! Install it (Y/n)"
    If (($InstallChoice -eq "") -or ($InstallChoice -eq "y") -or ($InstallChoice -eq "Y")) {
        try {
            Start-Process -Filepath powershell -ArgumentList $InstallCommand -Verb RunAs -Wait
        }
        catch {
            $ErrorMessage = $_.Exception.Message
            Write-Error -Message "Could not install Module $ModuleName.`n$ErrorMessage" -Category ConnectionError
            Break
        }
        continue
    }
}

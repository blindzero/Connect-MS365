function Test-MS365Module {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True,Position=1)]
        [String]
        $Service
    )

    <#
    .SYNOPSIS

    Checks if a module of a given service to connect is installed.

    .DESCRIPTION

    Checks if a module of a given service to connect is installed.
    Service name needs to be passed.

    .PARAMETER Service
    Name of service to check installed modules for.

    .INPUTS

    None. You cannot pipe objects to Add-Extension.

    .OUTPUTS

    // <OBJECTTYPE>. TBD.

    .EXAMPLE

    Test-MS365Module -Service MSOL

    .LINK

    http://github.com/blindzero/Connect-MS365

    #>

    $GetModulesSplat = @{
        ListAvailable = $True
        Verbose	      = $False
    }

    Switch($Service) {
        MSOL {
            If ($null -eq (Get-Module @GetModulesSplat -Name "MSOnline")) {
                $False
            }
            Else {
                $True
            }
        }
    }
}

function Install-MS365Module {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True,Position=1)]
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

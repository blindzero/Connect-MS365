function Test-MS365Module {
    [CmdletBinding()]
    param (
        # service module to be tested, must be known service
        [Parameter(Mandatory=$true,Position=1)]
        [String]
        $Module
    )

    <#
    .SYNOPSIS
    Checks if a module of a given service to connect is installed.

    .DESCRIPTION
    Checks if a module of a given service to connect is installed.
    Service name needs to be passed.

    .PARAMETER Module
    Name of module to check installation.

    .INPUTS
    None. You cannot pipe objects to Add-Extension.

    .OUTPUTS
    // <OBJECTTYPE>. TBD.

    .EXAMPLE
    Test-MS365Module -Module MSOnline

    .LINK
    http://github.com/blindzero/Connect-MS365

    #>

    # Set Splatting argument list for Get-Module used to determine if module is existing
    $GetModulesSplat = @{
        ListAvailable = $true
        Verbose	      = $false
    }

    # Finding installed module, will be $null if not available on system
    $ModuleInstalled = (Get-Module @GetModulesSplat -Name $ModuleFindString)
    # Extracting Version of installed module
    if ($ModuleInstalled) {
        $ModuleInstalledVer = $ModuleInstalled.Version.ToString()
    }
    # Finding available module online
    $ModuleAvailable = (Find-Module -Name $ModuleFindString -ErrorAction SilentlyContinue)
    # Extracting Version of available module online
    if ($ModuleAvailable) {
        $ModuleAvailableVer = $ModuleAvailable.Version.ToString()
    }

    # initialize $TestResult
    $TestResult = $Null

    # return $false if module is not installed
    If ($null -eq $ModuleInstalled) {
        Write-Verbose "$ModuleName was not found."
        $TestResult = $false
    }
    Else {
        # otherwise compare installed and available version
        If ($ModuleInstalledVer -lt $ModuleAvailableVer) {
            # if newer version is available online prompt for update
            do {
                $confirm = Read-Host -Prompt "New $ModuleName version $ModuleAvailableVer is available (installed: $ModuleInstalledVer). Update? [Y/n]"
                if ($confirm.Length -eq 0) {
                    $confirm = "y"
                }
            } while (($confirm.ToLower() -ne "n") -and ($confirm.ToLower() -ne "y"))
            # if confirmed ...
            If (($confirm.Length -eq 0) -or ($confirm.toLower() -eq "y")) {
                Write-Verbose "Updating Module $ModuleName from $ModuleInstalledVer to $ModuleAvailableVer"
                # return $false to be catched and update triggered
                $TestResult = $false
            }
            # if not confimed only do verbose logging and return true as update is optional
            Else {
                Write-Verbose "Skipping update of $ModuleName"
                $TestResult = $true
            }
        }
        Else {
            Write-Verbose "$ModuleName is latest available version $ModuleAvailableVer"
            $TestResult = $true
        }
    }

    return [Bool]$TestResult
}

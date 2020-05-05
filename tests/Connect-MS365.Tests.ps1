if (!($env:BHProjectPath)) {
    Set-BuildEnvironment -Path $PSScriptRoot\..
}

$moduleName = $MyInvocation.MyCommand.Name.Split(".")[0]
$ModuleManifest = "$($pwd)\$($moduleName).psd1"

$TestCredentialArgs = @("some-user@domain.tld",(ConvertTo-SecureString "somePassw0rd" -AsPlainText -Force))
$TestCredential = New-Object -TypeName PSCredential -ArgumentList $TestCredentialArgs
            

Describe "$moduleName Module Unit Tests" -Tags ('Unit','Integration') {
    Context "Module Setup Tests" {
        It "Has root module $moduleName.psm1" {
            "$pwd\$moduleName.psm1" | Should -Exist
        }
        It "Has the module manifest $moduleName.psd1" {
            "$pwd\$moduleName.psd1" | Should -Exist
            "$pwd\$moduleName.psd1" | Should -FileContentMatch "$moduleName.psm1"
        }
        It "$moduleName is valid PowerShell code" {
            $psFile = Get-Content -Path "$pwd\$moduleName.psm1" -ErrorAction Stop
            $errors = $null
            [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
            $errors.Count | Should -Be 0
        }
    }
    Context "Module Paramter Tests" {
        if (!(Get-Command $moduleName -ErrorAction SilentlyContinue)) {
            Import-Module "$($pwd)\$($moduleName).psm1"
        }

        It "Has Parameter -Service" {
            Get-Command $moduleName | Should -HaveParameter Service -Mandatory -Type String
        }

        It "Parameter -Service Validation" {
            { . $moduleName -Service NotValid } | Should Throw
        }

        It "Has Parameter -MFA" {
            Get-Command $moduleName | Should -HaveParameter MFA -Not -Mandatory
            Get-Command $moduleName | Should -HaveParameter MFA -Type Switch
        }

        It "Has Parameter -Credential" {
            Get-Command $moduleName | Should -HaveParameter Credential -Not -Mandatory
            Get-Command $moduleName | Should -HaveParameter Credential -Type PSCredential
        }

        It "Has Parameter -SPOOrgName" {
            Get-Command $moduleName | Should -HaveParameter SPOOrgName -Not -Mandatory
            Get-Command $moduleName | Should -HaveParameter SPOOrgName -Type String
        }
    }
}

Describe "Function Tests" -Tags ('Unit') {
    It "Functions not direct invokable Tests" {
        { Get-Command Connect-EOL } | Should Throw
        { Get-Command Connect-MSOL } | Should Throw
        { Get-Command Connect-Teams } | Should Throw
        { Get-Command Connect-SPO } | Should Throw
        { Get-Command Test-MS365Module } | Should Throw
        { Get-Command Install-MS365Module } | Should Throw
        { Get-Command Set-WindowTitle } | Should Throw
    }
    InModuleScope -ModuleName $moduleName {
        Context "Function Connect-EOL.ps1 Tests" {
            It "Has Parameter -Credential" {
                Get-Command Connect-EOL | Should -HaveParameter Credential
            }
        }
        Context "Function Connect-MSOL.ps1 Tests" {
            It "Has Parameter -Credential" {
                Get-Command Connect-MSOL | Should -HaveParameter Credential -Type PSCredential
                Get-Command Connect-MSOL | Should -HaveParameter Credential -Not -Mandatory
            }
        }
        Context "Function Connect-Teams.ps1 Tests" {
            It "Has Parameter -Credential" {
                Get-Command Connect-Teams | Should -HaveParameter Credential -Type PSCredential
                Get-Command Connect-Teams | Should -HaveParameter Credential -Not -Mandatory
            }
        }
        Context "Function Connect-SPO.ps1 Tests" {
            It "Has Parameter -Credential" {
                Get-Command Connect-SPO | Should -HaveParameter Credential -Type PSCredential
                Get-Command Connect-SPO | Should -HaveParameter Credential -Not -Mandatory
            }
            It "Has Parameter -SPOOrgName" {
                Get-Command Connect-SPO | Should -HaveParameter SPOOrgUrl -Type String
                Get-Command Connect-SPO | Should -HaveParameter SPOOrgUrl -Mandatory
            }
        }
        Context "Function Set-WindowTitle.ps1 Tests" {
            It "Has Parameter -Service" {
                Get-Command Set-WindowTitle | Should -HaveParameter Service -Type String -Mandatory
            }
        }
        Context "Function Test-MS365Module.ps1 Tests" {
            It "Has Parameter -Service" {
                Get-Command Test-MS365Module | Should -HaveParameter Service -Type String -Mandatory
            }
            It "Validates Parameter -Service" {
                {. Test-MS365Module -Service NonValid } | Should Throw
            }
        }
        Context "Function Install-MS365Module.ps1 Tests" {
            It "Has Parameter -Service" {
                Get-Command Install-MS365Module | Should -HaveParameter Service -Type String -Mandatory
            }
            It "Validates Parameter -Service" {
                {. Install-MS365Module -Service NonValid } | Should Throw
            }
        }
    }
}

Describe "$moduleName Integration Tests" -Tags ('Integration') {
    Context "Integrated Manifest Test" {
        It 'Passes Test-ModuleManifest' {
            Test-ModuleManifest -Path $ModuleManifest | Should Not BeNullOrEmpty
            $? | Should Be $true
        }
    }
    Context "Generated ExternalHelp XML Tests" {
        It "Has ExternalHelp XML generated" {
            "$pwd\en-us\$moduleName-help.xml" | Should -Exist
        }
        It "Has $moduleName.md doc file" {
            "$pwd\docs\$moduleName.md" | Should -Exist
        }
    }
    Context "Root doc file Tests" {
        It "Has root LICENSE file" {
            "$pwd\LICENSE" | Should -Exist
        }
        It "Has root documentation files" {
            "$pwd\README.md" | Should -Exist
            "$pwd\RELEASENOTES.md" | Should -Exist
        }
    }
}

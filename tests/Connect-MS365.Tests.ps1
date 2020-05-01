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
            Get-Command $moduleName | Should -HaveParameter Service -Mandatory -Type String[]
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
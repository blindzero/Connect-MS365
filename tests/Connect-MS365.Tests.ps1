if (!($env:BHProjectPath)) {
    Set-BuildEnvironment -Path $PSScriptRoot\..
}

$cwd = $outputModVerDir
$moduleName
$ModuleManifest = "$($cwd)\$($moduleName).psd1"

Describe "$moduleName Module Test" {
    Context 'Module Setup' {
        It "Has root module $moduleName.psm1" {
            "$cwd\$moduleName.psm1" | Should -Exist
        }
        It "Has the module manifest $moduleName.psd1" {
            "$cwd\$moduleName.psd1" | Should -Exist
            "$cwd\$moduleName.psd1" | Should -FileContentMatch "$moduleName.psm1"
        }
        It "$moduleName is valid PowerShell code" {
            $psFile = Get-Content -Path "$cwd\$moduleName.psm1" -ErrorAction Stop
            $errors = $null
            [System.Management.Automation.PSParser]::Tokenize($psFile, [ref]$errors)
            $errors.Count | Should -Be 0
        }
    }
}
Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifest | Should Not BeNullOrEmpty
        $? | Should Be $true
    }
}

$ModuleManifest = "$outputModVerDir\*.psd1"

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifest | Should Not BeNullOrEmpty
        $? | Should Be $true
    }
}


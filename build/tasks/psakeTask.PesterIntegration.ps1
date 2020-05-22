Function PSakeTask-PesterIntegration {
    Push-Location
    if (!($env:BHProjectPath)) {
        Set-BuildEnvironment -Path $PSScriptRoot
    }

    $origModulePath = $env:PSModulePath
    if ( $env:PSModulePath.Split($pathSeparator) -notcontains $outputDir ) {
        $env:PSModulePath = ($outputDir + $pathSeparator + $origModulePath)
    }

    Remove-Module -Name $moduleName -ErrorAction SilentlyContinue -Verbose:$false
    Import-Module -Name $outputModDir -Force -Verbose:$false
    $testResultsXml = Join-Path -Path $outputDir -ChildPath 'testResults.xml'
    Set-Location -PassThru $outputModDir | Out-Null
    $testResults = Invoke-Pester -Path $testsDir -Tag Integration -PassThru -OutputFile $testResultsXml -OutputFormat NUnitXML

    if ($testResults.FailedCount -gt 0) {
        $testFailedCount = $testResults.FailedCount
        Write-Error -Message "$testFailedCount Pester Integration Tests failed!"
        $testResults | Format-List
    }
    Pop-Location
    $env:PSModulePath = $origModulePath
}
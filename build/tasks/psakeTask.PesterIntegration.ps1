Function PSakeTask-PesterIntegration {
    Push-Location
    if (!($env:BHProjectPath)) {
        Set-BuildEnvironment -Path $PSScriptRoot
    }

    $origModulePath = $env:PSModulePath
    if ( $env:PSModulePath.Split($pathSeparator) -notcontains $outputDir ) {
        $env:PSModulePath = ($outputDir + $pathSeparator + $origModulePath)
    }
    # Cleanup module if loaded
    Remove-Module -Name $moduleName -ErrorAction SilentlyContinue -Verbose:$false
    # Import Module to be tested
    Import-Module -Name $outputModDir -Force -Verbose:$false
    # set path for test results output
    $testResultsXml = Join-Path -Path $outputDir -ChildPath 'testResultsIntegration.xml'
    # construct pester configuration object
    $PesterConfiguration = [PesterConfiguration]::Default
    $PesterConfiguration.Run.Path = $testsDir
    $PesterConfiguration.Run.PassThru = $True
    $PesterConfiguration.Filter.Tag = 'Integration'
    $PesterConfiguration.Should.ErrorAction = 'Continue'
    $PesterConfiguration.TestResult.Enabled = $true
    $PesterConfiguration.TestResult.OutputPath = $testResultsXml

    # goto output directory of module built
    $null = Set-Location -PassThru $outputModDir
    # invoke real testing based on configuration object
    $testResults = Invoke-Pester -Configuration $PesterConfiguration

    if ($testResults.FailedCount -gt 0) {
        $testFailedCount = $testResults.FailedCount
        Write-Error -Message "$testFailedCount Pester Integration Tests failed!"
        $testResults | Format-List
    }
    Pop-Location
    $env:PSModulePath = $origModulePath
}
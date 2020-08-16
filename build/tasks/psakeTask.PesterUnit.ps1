Function PSakeTask-PesterUnit {
    Push-Location
    if (!($env:BHProjectPath)) {
        Set-BuildEnvironment -Path $PSScriptRoot
    }

    $origModulePath = $env:PSModulePath
    if ( $env:PSModulePath.Split($pathSeparator) -notcontains $outputModDir ) {
        $env:PSModulePath = ($outputModDir + $pathSeparator + $origModulePath)
    }

    Remove-Module -Name $moduleName -ErrorAction SilentlyContinue -Verbose:$false
    Import-Module -Name $outputModDir -Force -Verbose:$false
    $testResultsXml = Join-Path -Path $outputDir -ChildPath 'testResultsUnit.xml'
    $null = Set-Location -PassThru $outputModDir
    $testResults = Invoke-Pester -Path $testsDir -Tag Unit -PassThru -OutputFile $testResultsXml -OutputFormat NUnitXML

    if ($testResults.FailedCount -gt 0) {
        $testFailedCount = $testResults.FailedCount
        Write-Error -Message "$testFailedCount Pester Integration Tests failed!"
        $testResults | Format-List
    }
    Pop-Location
    $env:PSModulePath = $origModulePath
}
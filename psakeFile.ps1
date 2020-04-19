Properties {
    $projectRoot        = $env:BHProjectPath
    if (!($projectRoot)) {
        $projectRoot    = $PSScriptRoot
    }
    $moduleName         = $env:BHProjectName
    $psVersion          = $PSVersionTable.PSVersion.Major
    $pathSeparator      = [IO.Path]::PathSeparator

    $manifestFile       = $env:BHPSModuleManifest
    $manifest           = Import-PowerShellDataFile -Path $manifestFile

    $srcDir             = $env:BHModulePath
    $srcPrivateDir      = Join-Path -Path $srcDir -ChildPath 'Private'
    $srcPublicDir       = Join-Path -Path $srcDir -ChildPath 'Public'
    $srcDocsDir         = Join-Path -Path $projectRoot -ChildPath 'docs'
    $tests              = Join-Path -Path $projectRoot -ChildPath 'tests'
    $licenseFile        = "$projectRoot\LICENSE"
    $readmeFile         = "$projectRoot\README.md"
    $releaseNotesFile   = "$projectRoot\RELEASENOTES.md"
    $srcAdditionalFiles = @(
        $licenseFile,
        $readmeFile,
        $releaseNotesFile
    )

    $outputDir          = Join-Path -Path $projectRoot -ChildPath 'build'
    $outputModDir       = Join-Path -Path $outputDir -ChildPath $moduleName
    $outputModVerDir    = Join-Path -Path $outputModDir -ChildPath $manifest.ModuleVersion
    $outputModDocsDir   = Join-Path -Path $outputModVerDir -ChildPath "docs"
    $extHelpPath        = Join-Path -Path $outputModVerDir -ChildPath "en-us"
    $moduleGuid         = $manifest.GUID
}

Task default -depends Test

Task Init {
    "`nSTATUS: Testing with PowerShell version $psVersion"
    Get-Item ENV:BH*
    # "General Settings"
    # "`tUsing `$projectRoot    $projectRoot"
    # "`tUsing `$moduleName     $moduleName"
    # "`tUsing `$psVersion      $psVersion"
    # "`tUsing `$pathSeparator  $pathSeparator"
    # "Source"
    # "`tUsing `$srcDir         $srcDir"
    # "`tUsing `$srcPrivateDir  $srcPrivateDir"
    # "`tUsing `$srcPublicDir   $srcPublicDir"
    # "`tUsing `$manifestFile   $manifestFile"
    # "`tUsing `$tests          $tests"
    # "Outputs"
    # "`tUsing `$outputDir      $outputDir"
    # "`tUsing `$outputModDir   $outputModDir"
    # "`tUsing `$outputModVerDir $outputModVerDir"
    "`n"
} -description "Initialize build environment"

Task Test -Depends Init, Analyze, Pester -description "Run test suite"

Task Analyze -Depends Build {
    $analysis   = Invoke-ScriptAnalyzer -Path $outputModVerDir -Verbose:$false
    $errors     = $analysis | Where-Object { $_.Severity -eq 'Error' }
    $warnings   = $analysis | Where-Object { $_.Severity -eq 'Warning' }

    if (($errors.Count -eq 0) -and ($warnings.Count -eq 0)) {
        '`tPSScriptAnalyzer passed: 0 Warnings || 0 Errors'
    }

    if (@($errors).Count -gt 0) {
        Write-Error -Message "PSScript Analyzer failed: Errors found!"
        $errors | Format-Table
    }

    if (@($warnings).Count -gt 0) {
        Write-Warning -Message "PSScript Analyzer found warnings!"
        $warnings | Format-Table
    }
} -description 'Run-PSScriptAnalyzer'

Task Pester -Depends Build {
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
    Set-Location -PassThru $outputModVerDir | Out-Null
    $testResults = Invoke-Pester -Path $tests -Tag Integration -PassThru -OutputFile $testResultsXml -OutputFormat NUnitXML

    if ($testResults.FailedCount -gt 0) {
        $testFailedCount = $testResults.FailedCount
        Write-Error -Message "$testFailedCount Pester Tests failed!"
        $testResults | Format-List
    }
    Pop-Location
    $env:PSModulePath = $origModulePath
} -description 'Run Pester Tests'

Task CreateMarkdownHelp -Depends Compile {
    Import-Module -Name $outputModDir -Verbose:$false -Global
    $mdFiles = New-MarkdownHelp -Module $moduleName -OutputFolder $outputModDocsDir -Verbose:$false
    "`tMarkdown help files created at [$mdFiles]"
    Remove-Module $moduleName -Verbose:$false
} -description 'Create initial markdown help files'

Task UpdateMarkdownHelp -Depends Compile, CreateMarkdownHelp {
    Import-Module -Name $outputModDir -Verbose:$false -Global
    $mdFiles = Update-MarkdownHelpModule -Path $outputModDocsDir -Verbose:$false
    "`tMarkdown help files updated at [$mdFiles]"
} -description 'Update markdown help files'

Task CreateExternalHelp -Depends CreateMarkdownHelp {
    New-ExternalHelp $outputModDocsDir -OutputPath $extHelpPath -Force > $null
} -description 'Create module help from markdown files'

Task GenerateHelp -Depends UpdateMarkdownHelp, CreateExternalHelp

Task Publish -Depends Test {
    "`tPublishing Version [$($manifest.ModuleVersion)] to PSGallery"
    Publish-Module -Path $outputModVerDir -NuGetApiKey $env:NUGET_API_KEY -Repository PSGallery
} -description 'Publish module to PSGallery'

Task Clean -Depends Init {
    Remove-Module $moduleName -Force -ErrorAction SilentlyContinue

    if (Test-Path -Path $outputDir) {
        Get-ChildItem -Path $outputDir -Recurse | Remove-Item -Force -Recurse
    }
    else {
        New-Item $outputDir -ItemType Directory > $null
    }
    "`tCleaned previous output directory [$outputDir]"
} -description "Cleans module output directory"

Task Compile -Depends Clean {
    # create new output directories for module and version
    $modDir = New-Item -Path $outputModDir -ItemType Directory
    New-Item -Path $outputModVerDir -ItemType Directory > $null

    # concat one large module file out of single files
    Write-Verbose -Message 'Creating psm1...'
    $psm1 = Copy-Item -Path (Join-Path -Path $srcDir -ChildPath "$($moduleName).psm1") -Destination $outputModVerDir -PassThru

    Get-ChildItem -Path $srcPrivateDir -Recurse | Get-Content -Raw | Add-Content -Path $psm1 -Encoding UTF8
    Get-ChildItem -Path $srcPublicDir -Recurse | Get-Content -Raw | Add-Content -Path $psm1 -Encoding UTF8

    Copy-Item -Path $manifestFile -Destination $outputModVerDir

    "`tCreated compiled module at [$modDir]"
} -description 'Compiles module from source'

Task Build -depends Compile, UpdateMarkDownHelp, CreateExternalHelp {
    # Adding External Help into psm1
    #$helpXml = New-ExternalHelp $outputModDocsDir -OutputPath $extHelpPath
    $psm1File = "$($outputModVerDir)\$($moduleName).psm1"
    $extHelpHeader = "#.ExternalHelp $($moduleName)-help.xml"
    $psm1Content = (Get-Content -Path $psm1File -Raw)
    $extHelpHeader + "`r`n" + $psm1Content | Out-File -FilePath $psm1File
    "`tModule XML help created at [$psm1File]"
    $addFiles = Copy-Item -Path $srcAdditionalFiles -Destination $outputModVerDir -PassThru
    "`tPut additional files [$addFiles]"
} -description 'Builds module by adding external help'

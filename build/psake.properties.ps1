## Psake build properties
## try to avoid using $env:BH* BuildHelper variables directly in tasks
## defining a lot of variables 

Properties {
    # our root of the project
    $projectRoot        = $env:BHProjectPath
    $moduleName         = $env:BHProjectName

    $psVersion          = $PSVersionTable.PSVersion.Major
    $pathSeparator      = [IO.Path]::PathSeparator

    $manifestFile       = $env:BHPSModuleManifest
    $manifest           = Import-PowerShellDataFile -Path $manifestFile

    $srcDir             = $env:BHModulePath
    $srcPrivateDir      = Join-Path -Path $srcDir -ChildPath 'Private'
    $srcPublicDir       = Join-Path -Path $srcDir -ChildPath 'Public'
    $docsDir            = Join-Path -Path $projectRoot -ChildPath 'docs'
    $testsDir           = Join-Path -Path $projectRoot -ChildPath 'tests'
    $toolsDir           = Join-Path -Path $projectRoot -ChildPath 'tools'
    $licenseFile        = "$projectRoot\LICENSE"
    $readmeFile         = "$projectRoot\README.md"
    $releaseNotesFile   = "$projectRoot\RELEASENOTES.md"
    $configSample       = "$srcDir\Configuration"
    $srcAdditionalFiles = @(
        $licenseFile,
        $readmeFile,
        $releaseNotesFile,
        $configSample
    )

    $outputDir          = $env:BHBuildOutput
    $outputModDir       = Join-Path -Path $outputDir -ChildPath $moduleName
    $outputModDocsDir   = Join-Path -Path $outputModDir -ChildPath "docs"
    $extHelpPath        = Join-Path -Path $outputModDir -ChildPath "en-us"
    $moduleGuid         = $manifest.GUID
}
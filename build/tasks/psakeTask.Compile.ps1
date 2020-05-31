Function PSakeTask-Compile {
    # concat one large module file out of single files
    Write-Verbose -Message 'Creating psm1...'
    # starting with Header as base of psm1 for module
    $psm1 = Copy-Item -Path (Join-Path -Path $srcPublicDir -ChildPath "Header.ps1") -Destination "$outputModDir\$($ModuleName).psm1" -PassThru

    # fetching all public functions and adding to psm1 file
    Get-ChildItem -Path $srcPublicDir -Recurse -Exclude @("Header.ps1","Footer.ps1") | Get-Content -Raw | Add-Content -Path $psm1 -Encoding UTF8
    # fetching all private functions and adding to psm1 file
    Get-ChildItem -Path $srcPrivateDir -Recurse | Get-Content -Raw | Add-Content -Path $psm1 -Encoding UTF8
    # fetching footer and adding to psm1 file
    Get-ChildItem -Path (Join-Path -Path $srcPublicDir -ChildPath "Footer.ps1") -Recurse | Get-Content -Raw | Add-Content -Path $psm1 -Encoding UTF8

    # adding manifest file to build output
    Copy-Item -Path $manifestFile -Destination $outputModDir

    "`tCreated compiled module [$psm1]"
} 

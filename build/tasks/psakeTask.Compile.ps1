Function PSakeTask-Compile {
    # concat one large module file out of single files
    Write-Verbose -Message 'Creating psm1...'
    $psm1 = Copy-Item -Path (Join-Path -Path $srcDir -ChildPath "$($moduleName).psm1") -Destination $outputModDir -PassThru

    Get-ChildItem -Path $srcPrivateDir -Recurse | Get-Content -Raw | Add-Content -Path $psm1 -Encoding UTF8
    Get-ChildItem -Path $srcPublicDir -Recurse | Get-Content -Raw | Add-Content -Path $psm1 -Encoding UTF8

    Copy-Item -Path $manifestFile -Destination $outputModDir

    "`tCreated compiled module at [$outputModDir]"
} 

Function PSakeTask-Build {
    # Adding External Help into psm1
    #$helpXml = New-ExternalHelp $outputModDocsDir -OutputPath $extHelpPath
    $psm1File = "$($outputModDir)\$($moduleName).psm1"
    $extHelpHeader = "#.ExternalHelp $($moduleName)-help.xml"
    $psm1Content = (Get-Content -Path $psm1File -Raw)
    $extHelpHeader + "`r`n" + $psm1Content | Out-File -FilePath $psm1File
    "`tModule XML help created at [$psm1File]"
    $addFiles = Copy-Item -Path $srcAdditionalFiles -Destination $outputModDir -Recurse -PassThru
    "`tPut additional files [$addFiles]"
    Copy-Item -Path $outputModDocsDir\*.md -Destination $docsDir
    "`tPut generated help $outputModDocsDir\*.md into $docsDir"
}
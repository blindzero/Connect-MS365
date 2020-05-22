Function PSakeTask-Publish {
    if ($env:BHBranchName -eq "master") {
        "`tPublishing Version [$($manifest.ModuleVersion)] to PSGallery"
        Publish-Module -Path $outputDir -NuGetApiKey $env:NUGET_API_KEY -Repository PSGallery
    }
    else {
        "`tSkipping Publish as Branch is not master!"
    }
}
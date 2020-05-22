Function PSakeTask-UpdateMDHelp {
    Import-Module -Name $outputModDir -Verbose:$false -Global
    $mdFiles = Update-MarkdownHelpModule -Path $outputModDocsDir -Verbose:$false
    "`tMarkdown help files updated at [$mdFiles]"
    Copy-Item -Path $mdFiles -Destination $docsDir
}
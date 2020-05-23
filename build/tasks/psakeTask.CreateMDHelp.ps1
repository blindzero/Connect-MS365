Function PSakeTask-CreateMDHelp {
    Import-Module -Name $outputModDir -Verbose:$false -Global
    $mdFiles = New-MarkdownHelp -Module $moduleName -OutputFolder $outputModDocsDir -Verbose:$false
    "`tMarkdown help files created at [$mdFiles]"
    Remove-Module $moduleName -Verbose:$false
}
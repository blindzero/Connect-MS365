## hopefully including by wildcards
## issue #299 at psake
Include psake.properties.ps1
Include tasks\psakeTask.Init.ps1
Include tasks\psakeTask.Clean.ps1
Include tasks\psakeTask.Compile.ps1
Include tasks\psakeTask.Analyze.ps1
Include tasks\psakeTask.Build.ps1
Include tasks\psakeTask.CreateMDHelp.ps1
Include tasks\psakeTask.UpdateMDHelp.ps1
Include tasks\psakeTask.PesterIntegration.ps1
Include tasks\psakeTask.PesterUnit.ps1
Include tasks\psakeTask.Publish.ps1
Include tasks\psakeTask.UpdateMDHelp.ps1

Task default -depends Compile

Task Init {
    PSakeTask-Init
} -description "Initialize build environment"

Task Clean -Depends Init {
    PSakeTask-Clean
} -description "Cleans module output directory"

Task Compile -Depends Clean {
    PSakeTask-Compile
} -description 'Compiles ons module file from source'

Task Analyze -Depends Compile {
    PSakeTask-Analyze
} -description 'Analyzes compiled code by PSScriptAnalyzer'

Task PesterUnit -Depends Compile {
    PSakeTask-TestUnit
} -description 'Run Pester Unit Tests'

Task TestUnit -Depends Analyze, PesterUnit -description "Run unit tests suite"

Task CreateMDHelp -Depends Compile {
    PSakeTask-CreateMDHelp
} -description 'Create initial markdown help files'

Task UpdateMDHelp -Depends CreateMDHelp {
    PSakeTask-UpdateMDHelp
} -description 'Update markdown help files'

Task CreateExternalHelp -Depends UpdateMDHelp {
    New-ExternalHelp $outputModDocsDir -OutputPath $extHelpPath -Force > $null
} -description 'Create module help from markdown files'

Task GenerateHelp -Depends UpdateMDHelp, CreateExternalHelp

Task Build -depends Compile, CreateExternalHelp {
    PSakeTask-Build
} -description 'Builds module by adding external help'

Task PesterIntegration -Depends Build {
    PSakeTask-PesterIntegration
} -description 'Run Pester Integration Tests'

Task TestIntegration -Depends Analyze, PesterIntegration -description "Run test suite"

Task Publish -Depends TestIntegration {
    PSakeTask-Publish
} -description 'Publish module to PSGallery'

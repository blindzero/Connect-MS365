Function PSakeTask-Analyze {
    $analysis   = $null
    $analysis   = Invoke-ScriptAnalyzer -Path $outputModDir -Verbose:$false
    $errors     = $analysis | Where-Object { $_.Severity -eq 'Error' }
    $warnings   = $analysis | Where-Object { $_.Severity -eq 'Warning' }

    if (($errors.Count -eq 0) -and ($warnings.Count -eq 0)) {
        "`tPSScriptAnalyzer passed: 0 Warnings || 0 Errors"
    }

    if (@($errors).Count -gt 0) {
        Write-Error -Message "PSScript Analyzer failed: Errors found!"
        $errors | Format-Table
    }

    if (@($warnings).Count -gt 0) {
        Write-Warning -Message "PSScript Analyzer found warnings!"
        $warnings | Format-Table
    }
}

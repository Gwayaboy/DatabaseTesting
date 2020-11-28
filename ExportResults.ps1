param(
    # Database info parameters    
    [string]$connectionString,
    
    # Test Result parameters
    [string]$testResultsFileName,
    [string]$queryTimeout
)

Write-Output "Exporting to tSQLt run to $testResultsFileName"    

(Invoke-SqlCmd -ConnectionString $connectionString -QueryTimeout $queryTimeout -Query "EXEC [tSQLt].[XMLResultFormatter]")[0] | Out-File -FilePath "$testResultsFileName" -NoNewLine

Write-Output "Exported test run to $testResultsFileName"    
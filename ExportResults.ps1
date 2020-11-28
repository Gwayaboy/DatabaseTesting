param(
    # Database info parameters    
    [string]$connectionString,
    
    # Test Result parameters
    [string]$testResultsFileName,
    [string]$queryTimeout
)

mkdir tsqlt-out
cd tSQLt-out
(Invoke-SqlCmd -ConnectionString $connectionString -QueryTimeout $queryTimeout -Query "EXEC [tSQLt].[XMLResultFormatter]")[0] | Out-File -FilePath $testResultsFileName -NoNewLine
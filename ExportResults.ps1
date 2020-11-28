param(
    # Database info parameters    
     [string]$connectionString,
    [string]$queryTimeout = 60,

    # Test Result parameters
    [string]$testResultsFileName
)

Write-Output "Exporting to tSQLt run to $testResultsFileName"    

$destinationDirectory = Split-Path -Path $testResultsFileName
$executingScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

.$executingScriptDirectory\CreateDirectoryIfDoesNotExist.ps1 -destinationDirectory $destinationDirectory


(Invoke-SqlCmd -ConnectionString $connectionString -QueryTimeout $queryTimeout -Query "EXEC [tSQLt].[XMLResultFormatter]")[0] | Out-File -FilePath $testResultsFileName -NoNewLine

Write-Output "Exported test run to $testResultsFileName"    
param(
    # Database info parameters    
    [string]$connectionString,
    [string]$queryTimeout = 60,
    [string]$databaseName, 

    #tSQLt parameters
    $testNameOrClassName = "",

    # Code Coverage parameters
    [string]$openCoverSourceFolder,
    [string]$coberturaFileName 
)

$executingScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$runtSQLtTestsCmd = "EXEC [tSQLt].[RunAll]";
$reportPath = Split-Path -Path $coberturaFileName

if (-not ($testNameOrClassName -eq "")) {
    $runtSQLtTestsCmd = "EXEC [tSQLt].[Run] '$testOrClassName'";       
}

. $openCoverSourceFolder\SQLCover.ps1

$result = Get-CoverTSql "$openCoverSourceFolder\SQLCover.dll" $connectionString $databaseName $runtSQLtTestsCmd

Write-Output "Tests ran successfully. Saving code coverage cover report to $reportPath" 

. $executingScriptDirectory\CreateDirectoryIfDoesNotExist.ps1 -destinationDirectory $reportPath

Export-OpenXml $result $reportPath

#Export-Cobertura $result $reportPath

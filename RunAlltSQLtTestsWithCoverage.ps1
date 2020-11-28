param(
    # Database info parameters    
    [string]$connectionString = "Server=tcp:sqlserver2019demo.uksouth.cloudapp.azure.com,1433;Initial Catalog=tSQLt_Example;User ID=demoadmin;Password=SQLServerP@ssw0rd;" ,
    [string]$queryTimeout = 60,
    [string]$databaseName = "tSQLt_Example",

    #tSQLt parameters
    $testNameOrClassName = "",

    # Code Coverage parameters
    [string]$openCoverSourceFolder = "C:\temp\SQLCover-0.5.0\src\SQLCover\releases\template",
    [string]$coberturaFileName = "C:\temp\coverage\Cobertura.xml"
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



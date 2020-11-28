param(
    # Database info parameters    
    [string]$connectionString,
    
    # Test Result parameters
    [string]$testResultsFileName,
    [string]$queryTimeout
)

Write-Output "Exporting to tSQLt run to $testResultsFileName"    

$destinationDirectory = Split-Path -Path $testResultsFileName

if (-not (Test-Path -LiteralPath $destinationDirectory)) {
    
    try {
        New-Item -Path $destinationDirectory -ItemType Directory -ErrorAction Stop | Out-Null #-Force
    }
    catch {
        Write-Error -Message "Unable to create directory '$destinationDirectory'. Error was: $_" -ErrorAction Stop
    }
    Write-Output "Successfully created directory '$destinationDirectory'."

}
else {
    Write-Output "Directory already existed"
}


(Invoke-SqlCmd -ConnectionString $connectionString -QueryTimeout $queryTimeout -Query "EXEC [tSQLt].[XMLResultFormatter]")[0] | Out-File -FilePath $testResultsFileName -NoNewLine

Write-Output "Exported test run to $testResultsFileName"    
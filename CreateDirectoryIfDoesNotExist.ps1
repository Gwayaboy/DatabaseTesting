param(
    [string] $destinationDirectory 
)

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
    Write-Output "Directory '$destinationDirectory' already exists"
}
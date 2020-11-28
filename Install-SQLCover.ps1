param(
    [String] $releaseUrl = "https://github.com/GoEddie/SQLCover/archive/0.5.0.zip",
    [string]$destinationFolder = "C:\temp\blah"
)

$zipFile = $destinationFolder + $(Split-Path -Path $releaseUrl -Leaf)
$executingScriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent 

. $executingScriptDirectory\CreateDirectoryIfDoesNotExist.ps1 -destinationDirectory $destinationFolder

Write-Output "Downloading $releaseUrl to $zipFile"    

Invoke-WebRequest -Uri $releaseUrl -OutFile $zipFile

Expand-Archive -LiteralPath $zipFile -DestinationPath $destinationFolder -Force
 
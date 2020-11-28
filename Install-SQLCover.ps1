param(
    [String] $releaseUrl = "https://github.com/GoEddie/SQLCover/archive/0.5.0.zip",
    [string]$destinationFolder = "C:\temp\"
)

$zipFile = $destinationFolder + $(Split-Path -Path $releaseUrl -Leaf) 
 
Invoke-WebRequest -Uri $releaseUrl -OutFile $zipFile

Expand-Archive -LiteralPath $zipFile -DestinationPath $destinationFolder -Force
 
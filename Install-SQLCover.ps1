param(
    [string]$dependenciesDirectory = "C:\Dev"
)

$Url = 'https://github.com/GoEddie/SQLCover/archive/0.5.0.zip' 
$ZipFile = $dependenciesDirectory + $(Split-Path -Path $Url -Leaf) 
$Destination= $dependenciesDirectory + '\SQLCover\'
 
Invoke-WebRequest -Uri $Url -OutFile $ZipFile 
 
$ExtractShell = New-Object -ComObject Shell.Application 
$Files = $ExtractShell.Namespace($ZipFile).Items() 
$ExtractShell.NameSpace($Destination).CopyHere($Files) 
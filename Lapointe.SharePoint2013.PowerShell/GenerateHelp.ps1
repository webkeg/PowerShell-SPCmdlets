﻿param(
  [string] $TargetDir = $(throw "TargetDir is required!"),
  [string] $ProjectDir = $(throw "ProjectDir is required!"),
  [string] $Version = $(throw "Version is required!")
)
$path = Split-Path -parent $MyInvocation.MyCommand.Definition  
$helpAsm = "$($ProjectDir)\ReferenceAssemblies\Lapointe.PowerShell.MamlGenerator.dll"
$cmdletAsm = "$($TargetDir)\Lapointe.SharePoint.PowerShell.dll"
Write-Host "Help generation work path: $path"
Write-Host "Help generation maml assembly path: $helpAsm"
Write-Host "Help generation cmdlet assembly path: $cmdletAsm"

#Start-Process "C:\Program Files (x86)\Microsoft SDKs\Windows\v8.1A\bin\NETFX 4.5.1 Tools\gacutil.exe" -ArgumentList "/uf","Lapointe.PowerShell.MamlGenerator"
Start-Process "C:\Program Files (x86)\Microsoft SDKs\Windows\v8.1A\bin\NETFX 4.5.1 Tools\gacutil.exe" -ArgumentList "/uf","Lapointe.SharePoint.PowerShell"

Write-Host "Loading help assembly..."
[System.Reflection.Assembly]::LoadFrom($helpAsm)
Write-Host "Loading cmdlet assembly..."
$asm = [System.Reflection.Assembly]::LoadFrom($cmdletAsm)
$asm
Write-Host "Generating help..."
[Lapointe.PowerShell.MamlGenerator.CmdletHelpGenerator]::GenerateHelp($asm, "$path\POWERSHELL\Help", $true)

cd "$($ProjectDir)"
$file = Resolve-Path .\Package\Package.Template.xml
Write-Host "Updating package file $file..."
[xml]$manifest = Get-Content $file
$manifest.Solution.SharePointProductVersion = $Version
$manifest.Save($file)


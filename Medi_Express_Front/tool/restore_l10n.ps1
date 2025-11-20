# Restores generated localization Dart files from tool/l10n_backup to lib/l10n
# Usage: From project root in PowerShell: .\tool\restore_l10n.ps1

$src = Join-Path $PSScriptRoot 'l10n_backup'
$dst = Join-Path $PSScriptRoot '..\lib\l10n'

if (-not (Test-Path $src)) {
    Write-Error "Backup folder not found: $src"
    exit 1
}

if (-not (Test-Path $dst)) {
    Write-Host "Creating destination folder: $dst"
    New-Item -ItemType Directory -Path $dst | Out-Null
}

Get-ChildItem -Path $src -Filter *.dart | ForEach-Object {
    $destinationFile = Join-Path $dst $_.Name
    Copy-Item -Path $_.FullName -Destination $destinationFile -Force
    Write-Host "Restored $_.Name -> $destinationFile"
}

Write-Host "Restoration complete."

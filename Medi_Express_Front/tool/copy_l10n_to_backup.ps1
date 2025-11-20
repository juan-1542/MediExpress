# Copy generated l10n Dart files from lib/l10n to tool/l10n_backup
$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$src = Join-Path $projectRoot '..\lib\l10n'
$dst = Join-Path $projectRoot 'l10n_backup'

if (-not (Test-Path $dst)) { New-Item -ItemType Directory -Path $dst | Out-Null }

Get-ChildItem -Path $src -Filter *.dart | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination (Join-Path $dst $_.Name) -Force
    Write-Host "Copied $_.Name to backup"
}
Write-Host "Done copying l10n files to backup"


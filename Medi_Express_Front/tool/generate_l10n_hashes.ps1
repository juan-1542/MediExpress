param(
    [string]$OutFile = "$PSScriptRoot\l10n_hash.txt"
)

# Project root is parent of tool folder
$projectRoot = Split-Path -Parent $PSScriptRoot
$src = Join-Path $projectRoot 'lib\l10n'

if (-not (Test-Path $src)) {
    Write-Error "Source folder not found: $src"
    exit 1
}

Get-ChildItem -Path $src -Filter *.dart -ErrorAction SilentlyContinue | ForEach-Object {
    $h = Get-FileHash $_.FullName -Algorithm SHA256
    "$($_.Name) $($h.Hash)"
} | Out-File $OutFile -Encoding UTF8

Write-Host "Wrote hashes to: $OutFile"
Get-Content $OutFile


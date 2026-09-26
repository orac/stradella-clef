# Re-engraves every examples/*.ly to a PDF alongside it. Set $env:LILYPOND to the path of lilypond.exe.
$ErrorActionPreference = 'Stop'

if (-not $env:LILYPOND) { throw 'LILYPOND is not set: point it at lilypond.exe' }

$examples = $PSScriptRoot
$repoRoot = Split-Path $examples -Parent
$failed = @()

foreach ($ly in Get-ChildItem -Path $examples -Filter *.ly) {
    Write-Host "Engraving $($ly.Name)"
    $out = Join-Path $examples $ly.BaseName
    & $env:LILYPOND -I $repoRoot --pdf -o $out $ly.FullName
    if ($LASTEXITCODE -ne 0) { $failed += $ly.Name }
}

if ($failed) { throw "LilyPond failed on: $($failed -join ', ')" }

# BudgieOS GTA SA FPS Booster
# Classic Grand Theft Auto: San Andreas (Windows PC)
# Safe launcher: does not patch the game, edit the registry, or change system settings.

$ErrorActionPreference = "Stop"
$Host.UI.RawUI.WindowTitle = "BudgieOS GTA SA FPS Booster"

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "      BUDGIEOS GTA SA FPS BOOSTER v1.0" -ForegroundColor Cyan
Write-Host "      Classic GTA San Andreas - PC" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This launcher only sets the game's process priority to AboveNormal."
Write-Host "It does not modify GTA files or promise a specific FPS."
Write-Host ""

$gamePath = Read-Host "Enter the full path to gta_sa.exe"

if ([string]::IsNullOrWhiteSpace($gamePath)) {
    Write-Host "No path entered. Exiting." -ForegroundColor Yellow
    Read-Host "Press Enter to close"
    exit 1
}

try {
    $gamePath = (Resolve-Path -LiteralPath $gamePath).Path
} catch {
    Write-Host "File not found: $gamePath" -ForegroundColor Red
    Read-Host "Press Enter to close"
    exit 1
}

if ([System.IO.Path]::GetFileName($gamePath) -ine "gta_sa.exe") {
    Write-Host "For Classic GTA San Andreas, select gta_sa.exe." -ForegroundColor Red
    Read-Host "Press Enter to close"
    exit 1
}

$gameFolder = Split-Path -Parent $gamePath

Write-Host ""
Write-Host "Launching GTA San Andreas..." -ForegroundColor Green

try {
    $game = Start-Process -FilePath $gamePath -WorkingDirectory $gameFolder -PassThru
} catch {
    Write-Host "Could not start the game: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "Press Enter to close"
    exit 1
}

Start-Sleep -Milliseconds 700

try {
    $game.Refresh()
    if (-not $game.HasExited) {
        $game.PriorityClass = [System.Diagnostics.ProcessPriorityClass]::AboveNormal
        Write-Host "Priority set to AboveNormal." -ForegroundColor Green
    } else {
        Write-Host "The game closed before priority could be changed." -ForegroundColor Yellow
    }
} catch {
    Write-Host "Could not change priority. The game is still running normally." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Keep this window open while you play."
Write-Host "When GTA SA closes, this launcher will exit."
try {
    $game.WaitForExit()
} catch {
    Write-Host "The game process is no longer available."
}

Write-Host "GTA San Andreas closed. No system settings were changed."
Read-Host "Press Enter to close"

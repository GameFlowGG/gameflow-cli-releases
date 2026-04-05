# GameFlow CLI uninstaller for Windows
# Usage: irm https://raw.githubusercontent.com/GameFlowGG/gameflow-cli-dev-release/main/uninstall.ps1 | iex

$ErrorActionPreference = "Stop"

$InstallDir = if ($env:GAMEFLOW_INSTALL) { $env:GAMEFLOW_INSTALL } else { "$env:USERPROFILE\.gameflow" }
$BinDir = "$InstallDir\bin"

# --- Remove install directory (binary + all config/data) ---

if (-not (Test-Path $InstallDir)) {
  Write-Host "GameFlow CLI not found at $InstallDir"
  exit 0
}

Remove-Item -Recurse -Force $InstallDir
Write-Host "Removed $InstallDir"

# --- Remove PATH entry ---

$UserPath = [System.Environment]::GetEnvironmentVariable("PATH", "User")

if ($UserPath -like "*$BinDir*") {
  Write-Host "Cleaning PATH..."
  $NewPath = ($UserPath -split ";" | Where-Object { $_ -ne $BinDir }) -join ";"
  [System.Environment]::SetEnvironmentVariable("PATH", $NewPath, "User")
  Write-Host "  Removed $BinDir from user PATH"
}

# --- Done ---

Write-Host ""
Write-Host "GameFlow CLI uninstalled."
Write-Host "Restart your terminal to apply PATH changes."

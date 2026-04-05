# GameFlow CLI installer for Windows
# Usage: irm https://raw.githubusercontent.com/GameFlowGG/gameflow-cli-dev-release/main/install.ps1 | iex

$ErrorActionPreference = "Stop"

$Repo = "GameFlowGG/gameflow-cli-dev-release"
$InstallDir = if ($env:GAMEFLOW_INSTALL) { $env:GAMEFLOW_INSTALL } else { "$env:USERPROFILE\.gameflow" }
$BinDir = "$InstallDir\bin"
$Exe = "$BinDir\gameflow.exe"

# --- Detect architecture ---

$Arch = if ([System.Environment]::Is64BitOperatingSystem) {
  switch ($env:PROCESSOR_ARCHITECTURE) {
    "ARM64" { "arm64" }
    default  { "amd64" }
  }
} else {
  Write-Error "Error: 32-bit Windows is not supported."
  exit 1
}

# --- Resolve version ---

$Tag = if ($args.Count -gt 0) { "v$($args[0])" } else { "dev" }

$DownloadUrl = "https://github.com/$Repo/releases/download/$Tag/gameflow-windows-$Arch.exe"

# --- Download ---

Write-Host "Downloading GameFlow CLI $Tag (windows/$Arch)..."

New-Item -ItemType Directory -Force -Path $BinDir | Out-Null

try {
  Invoke-WebRequest -Uri $DownloadUrl -OutFile $Exe -UseBasicParsing
} catch {
  Write-Host ""
  Write-Host "Error: download failed for $DownloadUrl"
  Write-Host "The release '$Tag' may not exist yet. Check available releases at:"
  Write-Host "  https://github.com/$Repo/releases"
  Remove-Item -Force -ErrorAction SilentlyContinue $Exe
  exit 1
}

# --- Update PATH ---

$UserPath = [System.Environment]::GetEnvironmentVariable("PATH", "User")

if ($UserPath -notlike "*$BinDir*") {
  Write-Host "Updating PATH..."
  [System.Environment]::SetEnvironmentVariable("PATH", "$BinDir;$UserPath", "User")
  Write-Host "  Added $BinDir to user PATH"
  $PathUpdated = $true
} else {
  $PathUpdated = $false
}

# --- Done ---

Write-Host ""
Write-Host "GameFlow CLI installed to $Exe"

if ($PathUpdated) {
  Write-Host ""
  Write-Host "Restart your terminal to apply PATH changes."
}

Write-Host ""
Write-Host "Run 'gameflow --help' to get started."
Write-Host "Docs: https://docs.gameflow.gg/"

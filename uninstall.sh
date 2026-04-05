#!/bin/sh
set -e

# GameFlow CLI uninstaller
# Usage: curl -fsSL https://raw.githubusercontent.com/GameFlowGG/gameflow-cli-dev-release/main/uninstall.sh | sh

INSTALL_DIR="${GAMEFLOW_INSTALL:-$HOME/.gameflow}"
BIN_DIR="$INSTALL_DIR/bin"
EXE="$BIN_DIR/gameflow"

# --- Remove install directory (binary + all config/data) ---

if [ ! -d "$INSTALL_DIR" ] && [ ! -f "$EXE" ]; then
  echo "GameFlow CLI not found at $INSTALL_DIR"
  exit 0
fi

rm -rf "$INSTALL_DIR"
echo "Removed $INSTALL_DIR"

# --- Remove PATH entries ---

remove_from_path() {
  rc_file="$1"
  if [ ! -f "$rc_file" ]; then
    return
  fi
  if grep -qF '.gameflow/bin' "$rc_file" 2>/dev/null; then
    # Remove the GameFlow CLI block (comment + export line)
    grep -v '\.gameflow/bin' "$rc_file" | grep -v '# GameFlow CLI' > "$rc_file.tmp" && mv "$rc_file.tmp" "$rc_file"
    echo "  Cleaned $rc_file"
  fi
}

echo "Cleaning PATH entries..."
remove_from_path "$HOME/.zshrc"
remove_from_path "$HOME/.bashrc"
remove_from_path "$HOME/.bash_profile"

# --- Done ---

echo ""
echo "GameFlow CLI uninstalled."
echo "Restart your shell to apply PATH changes."

#!/bin/sh
set -e

# GameFlow CLI installer
# Usage: curl -fsSL https://raw.githubusercontent.com/GameFlowGG/gameflow-cli-dev-release/main/install.sh | sh

REPO="GameFlowGG/gameflow-cli-dev-release"
INSTALL_DIR="${GAMEFLOW_INSTALL:-$HOME/.gameflow}"
BIN_DIR="$INSTALL_DIR/bin"
EXE="$BIN_DIR/gameflow"

# --- Detect OS and architecture ---

case "$(uname -s)" in
  Darwin) os="darwin" ;;
  Linux)  os="linux"  ;;
  *)
    echo "Error: unsupported operating system: $(uname -s)"
    echo "Windows users: download the binary directly from https://github.com/$REPO/releases"
    exit 1
    ;;
esac

case "$(uname -m)" in
  x86_64 | amd64) arch="amd64" ;;
  arm64 | aarch64) arch="arm64" ;;
  *)
    echo "Error: unsupported architecture: $(uname -m)"
    exit 1
    ;;
esac

# --- Resolve version ---

if [ -n "$1" ]; then
  TAG="v$1"
else
  TAG="vdev"
fi

DOWNLOAD_URL="https://github.com/$REPO/releases/download/$TAG/gameflow-${os}-${arch}"

# --- Download ---

echo "Downloading GameFlow CLI $TAG (${os}/${arch})..."

mkdir -p "$BIN_DIR"

if command -v curl >/dev/null 2>&1; then
  if ! curl --fail --location --progress-bar --output "$EXE" "$DOWNLOAD_URL"; then
    echo ""
    echo "Error: download failed for $DOWNLOAD_URL"
    echo "The release '$TAG' may not exist yet. Check available releases at:"
    echo "  https://github.com/$REPO/releases"
    rm -f "$EXE"
    exit 1
  fi
elif command -v wget >/dev/null 2>&1; then
  if ! wget -q --show-progress -O "$EXE" "$DOWNLOAD_URL"; then
    echo ""
    echo "Error: download failed for $DOWNLOAD_URL"
    echo "The release '$TAG' may not exist yet. Check available releases at:"
    echo "  https://github.com/$REPO/releases"
    rm -f "$EXE"
    exit 1
  fi
else
  echo "Error: curl or wget is required"
  exit 1
fi

chmod +x "$EXE"

# --- Update PATH ---

add_to_path() {
  rc_file="$1"
  line='export PATH="$HOME/.gameflow/bin:$PATH"'

  if [ -f "$rc_file" ] && grep -qF '.gameflow/bin' "$rc_file" 2>/dev/null; then
    return
  fi

  printf '\n# GameFlow CLI\n%s\n' "$line" >> "$rc_file"
  echo "  Added to $rc_file"
}

case "$PATH" in
  *"$BIN_DIR"*) path_ok=true ;;
  *) path_ok=false ;;
esac

if [ "$path_ok" = false ]; then
  echo "Updating PATH..."
  if [ -f "$HOME/.zshrc" ];  then add_to_path "$HOME/.zshrc";  fi
  if [ -f "$HOME/.bashrc" ]; then add_to_path "$HOME/.bashrc"; fi
  if [ -f "$HOME/.bash_profile" ]; then add_to_path "$HOME/.bash_profile"; fi
fi

# --- Done ---

echo ""
echo "GameFlow CLI installed to $EXE"

if [ "$path_ok" = false ]; then
  echo ""
  echo "Restart your shell or run:"
  echo "  export PATH=\"\$HOME/.gameflow/bin:\$PATH\""
fi

echo ""
echo "Run 'gameflow --help' to get started."
echo "Docs: https://docs.gameflow.gg/"

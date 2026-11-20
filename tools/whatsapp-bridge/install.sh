#!/bin/bash
# Sets up the read only WhatsApp bridge on a Mac.
#
# Builds lharries/whatsapp-mcp at a pinned commit with readonly.patch from this
# folder, connects it to Claude Code, and installs a background service.
# Linking your WhatsApp is a separate step you do yourself: pair.sh.
# Safe to run again, it skips what's already done.
set -euo pipefail

KIT_DIR="$(cd "$(dirname "$0")" && pwd)"
INSTALL_DIR="${WA_BRIDGE_DIR:-$HOME/whatsapp-bridge}"
UPSTREAM="https://github.com/lharries/whatsapp-mcp.git"
PINNED="7d6a06dcdce1f01dfb24f60e1030d5efba9f3b88"
LABEL="com.whatsapp-bridge.readonly"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
DB="$INSTALL_DIR/whatsapp-bridge/store/whatsapp.db"

step() { printf '\n==> %s\n' "$1"; }
stop() { printf '\nStopped: %s\n' "$1" >&2; exit 1; }
linked() { [ -f "$DB" ] && [ "$(sqlite3 "$DB" 'SELECT COUNT(*) FROM whatsmeow_device;' 2>/dev/null || echo 0)" -gt 0 ]; }

[ "$(uname)" = "Darwin" ] || stop "this installer is for macOS."

step "Checking tools"
xcode-select -p >/dev/null 2>&1 || stop "Apple's command line tools are missing. Run: xcode-select --install   Then run this again."
command -v brew >/dev/null 2>&1 || stop "Homebrew is missing. Install it from https://brew.sh, then run this again."
command -v go >/dev/null 2>&1 || brew install go
command -v uv >/dev/null 2>&1 || brew install uv
UV="$(command -v uv)"

step "Getting the bridge source into $INSTALL_DIR"
[ -d "$INSTALL_DIR/.git" ] || git clone --quiet "$UPSTREAM" "$INSTALL_DIR"
cd "$INSTALL_DIR"
if git apply --reverse --check "$KIT_DIR/readonly.patch" >/dev/null 2>&1; then
  echo "Read only patch already in place."
else
  # --force only resets tracked source files. Your linked session and your
  # messages live in whatsapp-bridge/store, which git ignores, so they're safe.
  git fetch --quiet origin
  git checkout --quiet --force "$PINNED"
  git apply "$KIT_DIR/readonly.patch"
  echo "Read only patch applied."
fi

step "Building the bridge"
cd "$INSTALL_DIR/whatsapp-bridge"
CGO_ENABLED=1 go build -o whatsapp-bridge .

step "Installing the Claude side"
cd "$INSTALL_DIR/whatsapp-mcp-server"
"$UV" sync --frozen --quiet
"$UV" run --frozen python -c "import main" || stop "the Claude side didn't load. Ask Claude on this Mac to look at it."
echo "Claude side loads, read only."

step "Connecting it to Claude Code"
if command -v claude >/dev/null 2>&1; then
  claude mcp remove --scope user whatsapp >/dev/null 2>&1 || true
  claude mcp add --scope user whatsapp -- "$UV" --directory "$INSTALL_DIR/whatsapp-mcp-server" run main.py
else
  echo "The claude command isn't on this Mac's PATH. Ask Claude on this Mac to add an MCP server:"
  echo "  name: whatsapp   scope: user"
  echo "  command: $UV --directory $INSTALL_DIR/whatsapp-mcp-server run main.py"
fi

step "Installing the background service"
mkdir -p "$HOME/Library/LaunchAgents"
sed "s|__INSTALL_DIR__|$INSTALL_DIR|g" "$KIT_DIR/whatsapp-bridge.plist.template" > "$PLIST"
echo "Saved $PLIST"

if linked; then
  launchctl bootout "gui/$(id -u)/$LABEL" 2>/dev/null || true
  sleep 1
  launchctl bootstrap "gui/$(id -u)" "$PLIST"
  step "Done. Your WhatsApp is linked and the bridge is running in the background."
else
  step "Nearly done. Last step, link your WhatsApp. Run: bash \"$KIT_DIR/pair.sh\""
fi

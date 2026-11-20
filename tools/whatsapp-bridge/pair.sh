#!/bin/bash
# Links the bridge to your WhatsApp. You do this bit yourself, on your phone.
#
# 1. Run this in Terminal.
# 2. On your phone: WhatsApp, Settings, Linked devices, Link a device. Scan the code.
# 3. When it says "Connected to WhatsApp, read only", press Ctrl+C.
# The bridge then keeps running in the background and starts again when you log in.
set -uo pipefail

INSTALL_DIR="${WA_BRIDGE_DIR:-$HOME/whatsapp-bridge}"
LABEL="com.whatsapp-bridge.readonly"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
BRIDGE_DIR="$INSTALL_DIR/whatsapp-bridge"
DB="$BRIDGE_DIR/store/whatsapp.db"

linked() { [ -f "$DB" ] && [ "$(sqlite3 "$DB" 'SELECT COUNT(*) FROM whatsmeow_device;' 2>/dev/null || echo 0)" -gt 0 ]; }

if [ ! -x "$BRIDGE_DIR/whatsapp-bridge" ] || [ ! -f "$PLIST" ]; then
  echo "Run install.sh first."
  exit 1
fi

# Only one copy can run at a time, so stop the background one while linking.
launchctl bootout "gui/$(id -u)/$LABEL" 2>/dev/null || true

echo "On your phone: WhatsApp, Settings, Linked devices, Link a device. Scan the code below."
echo "When it says \"Connected to WhatsApp, read only\", press Ctrl+C."
cd "$BRIDGE_DIR"
trap ':' INT   # Ctrl+C stops the bridge, not this script
./whatsapp-bridge
trap - INT

if linked; then
  sleep 1
  launchctl bootstrap "gui/$(id -u)" "$PLIST"
  echo
  echo "Linked. The bridge is running in the background. You can close this window."
else
  echo
  echo "Not linked yet. Run this again and scan the code within 3 minutes."
fi

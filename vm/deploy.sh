#!/usr/bin/env bash
# nexus platform VM deploy script
# Sets up the webhook handler on a fresh VM
# Run as root: sudo bash deploy.sh

set -euo pipefail

DEA_USER="dea"
DEA_HOME="/home/$DEA_USER"
PLATFORM_DIR="$DEA_HOME/platform"
SERVICE_NAME="nexus-webhook-handler"
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"

echo "=== nexus VM deploy ==="
echo ""

# 1. Create dea user
if ! id "$DEA_USER" &>/dev/null; then
    useradd -m -s /bin/bash "$DEA_USER"
    echo "Created user: $DEA_USER"
else
    echo "User $DEA_USER exists"
fi

# 2. Install dependencies
echo ""
echo "Installing dependencies..."
apt-get update -qq
apt-get install -y python3 git

# 3. Clone platform repo
echo ""
echo "Cloning dea-exmachina/platform..."
if [[ ! -d "$PLATFORM_DIR" ]]; then
    sudo -u "$DEA_USER" git clone git@github.com:dea-exmachina/platform.git "$PLATFORM_DIR"
else
    echo "Already cloned — pulling latest..."
    sudo -u "$DEA_USER" git -C "$PLATFORM_DIR" pull origin master
fi

# 4. Verify .env
if [[ ! -f "$PLATFORM_DIR/.env" ]]; then
    echo ""
    echo "ERROR: $PLATFORM_DIR/.env not found."
    echo "Create it with:"
    echo "  SUPABASE_URL=https://hehldpjqlxhshdqqadng.supabase.co"
    echo "  SUPABASE_SERVICE_KEY=<admin service role key>"
    echo "  WEBHOOK_SECRET=<generate with: openssl rand -hex 32>"
    echo "  PORT=8080"
    exit 1
fi

# 5. Install systemd service
echo ""
echo "Installing systemd service..."
cp "$PLATFORM_DIR/vm/$SERVICE_NAME.service" "$SERVICE_FILE"
chmod 644 "$SERVICE_FILE"
systemctl daemon-reload
systemctl enable "$SERVICE_NAME"
systemctl restart "$SERVICE_NAME"

# 6. Status check
echo ""
systemctl status "$SERVICE_NAME" --no-pager

echo ""
echo "=== Deploy complete ==="
echo ""
echo "Health check:  curl http://localhost:8080/health"
echo "Logs:          journalctl -u $SERVICE_NAME -f"
echo "Restart:       systemctl restart $SERVICE_NAME"

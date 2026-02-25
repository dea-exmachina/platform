#!/usr/bin/env bash
# cc-healthcheck.sh — CC production health check (NEXUS-088)
# Pings the Control Center production URL every 5 min (via systemd timer).
# Sends Discord alert after FAILURE_THRESHOLD consecutive failures.
# Deduplicates alerts — one per incident, not per check.
# Sends green recovery embed when CC comes back online.

set -euo pipefail

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------
CC_URL="https://app.dea-exmachina.xyz"
STATE_FILE="/home/dea/platform/tools/healthcheck_state.json"
LOG_FILE="/home/dea/platform/tools/healthcheck.log"
FAILURE_THRESHOLD=3

# Load webhook URL from .env
ENV_FILE="/home/dea/platform/tools/.env"
if [[ -f "$ENV_FILE" ]]; then
    WEBHOOK_URL=$(grep -E '^DISCORD_WEBHOOK_DEA_GEORGE=' "$ENV_FILE" | cut -d'=' -f2- | tr -d '"' | tr -d "'")
else
    WEBHOOK_URL=""
fi

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
log() {
    echo "$(date -u '+%Y-%m-%dT%H:%M:%SZ') [cc-healthcheck] $*" | tee -a "$LOG_FILE"
}

send_alert() {
    local title="$1"
    local description="$2"
    local color="${3:-15158332}"  # default red

    if [[ -z "$WEBHOOK_URL" ]]; then
        log "WARN: No webhook URL — cannot send Discord alert"
        return
    fi

    local payload
    payload=$(cat <<ENDJSON
{
  "embeds": [{
    "title": "${title}",
    "color": ${color},
    "description": "${description}",
    "footer": {"text": "VM health check (every 5 min)"},
    "timestamp": "$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  }]
}
ENDJSON
    )

    curl -s -X POST "$WEBHOOK_URL" \
        -H "Content-Type: application/json" \
        -d "$payload" \
        --max-time 5 > /dev/null 2>&1 || log "WARN: Discord alert failed"
}

# ---------------------------------------------------------------------------
# State file initialization
# ---------------------------------------------------------------------------
if [[ ! -f "$STATE_FILE" ]]; then
    echo '{"consecutive_failures": 0, "alert_sent": false, "last_check": "", "last_status_code": 0}' > "$STATE_FILE"
fi

# ---------------------------------------------------------------------------
# HTTP check
# ---------------------------------------------------------------------------
TIMESTAMP=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" -L --max-time 10 "$CC_URL" 2>/dev/null || echo "000")

# ---------------------------------------------------------------------------
# Read current state
# ---------------------------------------------------------------------------
CONSECUTIVE_FAILURES=$(python3 -c "
import json
try:
    data = json.load(open('$STATE_FILE'))
    print(int(data.get('consecutive_failures', 0)))
except:
    print(0)
" 2>/dev/null || echo "0")

ALERT_SENT=$(python3 -c "
import json
try:
    data = json.load(open('$STATE_FILE'))
    print(str(data.get('alert_sent', False)).lower())
except:
    print('false')
" 2>/dev/null || echo "false")

# ---------------------------------------------------------------------------
# Handle result
# ---------------------------------------------------------------------------
if [[ "$HTTP_STATUS" == "200" ]]; then
    # Success path
    if [[ "$ALERT_SENT" == "true" ]]; then
        # Recovery — send green embed
        DOWNTIME_APPROX=$(( CONSECUTIVE_FAILURES * 5 ))
        send_alert \
            "✅ Control Center RECOVERED" \
            "Back online after **${CONSECUTIVE_FAILURES} failed checks** (~${DOWNTIME_APPROX} min downtime)\nURL: ${CC_URL}" \
            "3066993"
        log "RECOVERY: CC back online after ${CONSECUTIVE_FAILURES} consecutive failures"
    else
        log "OK: HTTP ${HTTP_STATUS}"
    fi

    # Reset state
    python3 -c "
import json
try:
    with open('$STATE_FILE', 'r') as f:
        data = json.load(f)
except:
    data = {}
data['consecutive_failures'] = 0
data['alert_sent'] = False
data['last_check'] = '$TIMESTAMP'
data['last_status_code'] = $HTTP_STATUS
with open('$STATE_FILE', 'w') as f:
    json.dump(data, f, indent=2)
" 2>/dev/null || log "WARN: Failed to write state file"

else
    # Failure path
    NEW_FAILURES=$(( CONSECUTIVE_FAILURES + 1 ))

    # Update state with incremented failure count
    python3 -c "
import json
try:
    with open('$STATE_FILE', 'r') as f:
        data = json.load(f)
except:
    data = {}
data['consecutive_failures'] = $NEW_FAILURES
data['last_check'] = '$TIMESTAMP'
data['last_status_code'] = int('$HTTP_STATUS') if '$HTTP_STATUS'.isdigit() else 0
with open('$STATE_FILE', 'w') as f:
    json.dump(data, f, indent=2)
" 2>/dev/null || log "WARN: Failed to write state file"

    log "FAIL: HTTP ${HTTP_STATUS} (${NEW_FAILURES} consecutive failures)"

    # Send alert if threshold reached and not already alerted
    if [[ "$NEW_FAILURES" -ge "$FAILURE_THRESHOLD" && "$ALERT_SENT" == "false" ]]; then
        send_alert \
            "⚠️ Control Center DOWN" \
            "**${NEW_FAILURES} consecutive failures** — HTTP ${HTTP_STATUS}\nURL: ${CC_URL}\nTime: ${TIMESTAMP}" \
            "15158332"
        log "ALERT: Sent Discord down notification (${NEW_FAILURES} failures)"

        # Mark alert as sent
        python3 -c "
import json
try:
    with open('$STATE_FILE', 'r') as f:
        data = json.load(f)
except:
    data = {}
data['alert_sent'] = True
with open('$STATE_FILE', 'w') as f:
    json.dump(data, f, indent=2)
" 2>/dev/null || log "WARN: Failed to update alert_sent flag"
    fi
fi

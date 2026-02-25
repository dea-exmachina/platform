#!/usr/bin/env python3
"""
nexus-webhook-handler — Product-level telemetry handler
Receives GitHub/Vercel webhook events and writes to dea-exmachina-admin Supabase.

Scope: product telemetry only (deployment events, build status).
NOT per-user data routing (post-PoC).

Environment variables (from .env):
  SUPABASE_URL          — dea-exmachina-admin Supabase URL
  SUPABASE_SERVICE_KEY  — service role key (admin write access)
  WEBHOOK_SECRET        — shared secret for GitHub webhook verification
  PORT                  — port to listen on (default: 8080)
"""

import os
import hmac
import hashlib
import json
import logging
from http.server import HTTPServer, BaseHTTPRequestHandler
from datetime import datetime, timezone

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(message)s'
)
log = logging.getLogger(__name__)

SUPABASE_URL = os.environ.get('SUPABASE_URL', '')
SUPABASE_SERVICE_KEY = os.environ.get('SUPABASE_SERVICE_KEY', '')
WEBHOOK_SECRET = os.environ.get('WEBHOOK_SECRET', '')
PORT = int(os.environ.get('PORT', 8080))


def verify_github_signature(payload: bytes, signature: str) -> bool:
    if not WEBHOOK_SECRET:
        return True  # No secret configured — accept all (dev mode)
    expected = 'sha256=' + hmac.new(
        WEBHOOK_SECRET.encode(), payload, hashlib.sha256
    ).hexdigest()
    return hmac.compare_digest(expected, signature)


def record_event(event_type: str, payload: dict) -> None:
    """Write a telemetry event to Supabase (nexus_events or a product_events table)."""
    try:
        import urllib.request
        import urllib.error

        body = json.dumps({
            'event_type': event_type,
            'payload': payload,
            'recorded_at': datetime.now(timezone.utc).isoformat(),
        }).encode()

        req = urllib.request.Request(
            f'{SUPABASE_URL}/rest/v1/product_events',
            data=body,
            headers={
                'apikey': SUPABASE_SERVICE_KEY,
                'Authorization': f'Bearer {SUPABASE_SERVICE_KEY}',
                'Content-Type': 'application/json',
                'Prefer': 'return=minimal',
            },
            method='POST'
        )
        with urllib.request.urlopen(req, timeout=5) as resp:
            log.info(f'Event recorded: {event_type} (status {resp.status})')
    except Exception as e:
        log.warning(f'Failed to record event {event_type}: {e}')


class WebhookHandler(BaseHTTPRequestHandler):
    def log_message(self, fmt, *args):
        log.info(fmt % args)

    def do_GET(self):
        if self.path == '/health':
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps({'status': 'ok'}).encode())
        else:
            self.send_response(404)
            self.end_headers()

    def do_POST(self):
        content_length = int(self.headers.get('Content-Length', 0))
        body = self.rfile.read(content_length)

        # GitHub webhook
        if self.path == '/webhooks/github':
            sig = self.headers.get('X-Hub-Signature-256', '')
            if not verify_github_signature(body, sig):
                log.warning('GitHub signature verification failed')
                self.send_response(401)
                self.end_headers()
                return

            event = self.headers.get('X-GitHub-Event', 'unknown')
            try:
                payload = json.loads(body)
                record_event(f'github.{event}', payload)
                log.info(f'GitHub event: {event} repo={payload.get("repository", {}).get("full_name", "?")}')
            except json.JSONDecodeError:
                log.warning('Invalid JSON in GitHub webhook')

            self.send_response(200)
            self.end_headers()
            return

        # Vercel webhook
        if self.path == '/webhooks/vercel':
            try:
                payload = json.loads(body)
                event_type = payload.get('type', 'unknown')
                record_event(f'vercel.{event_type}', payload)
                log.info(f'Vercel event: {event_type}')
            except json.JSONDecodeError:
                log.warning('Invalid JSON in Vercel webhook')

            self.send_response(200)
            self.end_headers()
            return

        self.send_response(404)
        self.end_headers()


if __name__ == '__main__':
    if not SUPABASE_URL or not SUPABASE_SERVICE_KEY:
        log.warning('SUPABASE_URL or SUPABASE_SERVICE_KEY not set — events will not be persisted')

    log.info(f'nexus-webhook-handler starting on port {PORT}')
    server = HTTPServer(('0.0.0.0', PORT), WebhookHandler)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        log.info('Shutting down')

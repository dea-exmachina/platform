---
type: workflow
trigger: manual
status: active
created: 2026-02-10
updated: 2026-02-18
category: infrastructure
playbook_phase: "1.5"
related_workflows:
  - system-bootstrap.md
  - monitoring-setup.md
  - data-layer-setup.md
project_scope: all
last_used: null
---

# Workflow: Integration Wiring

## Purpose

Connect external services to the workspace. Covers: email (Resend), Discord, Vercel, and any other third-party integrations required by active workflows.

## When to Use

- During initial system setup (Phase 1.5)
- When adding a new integration
- When an existing integration breaks and needs re-wiring

---

## Integration Catalog

### Resend (Email)

**Required for**: `email-send.md`, `release-notes.md`

Setup:
1. Create account at resend.com
2. Add and verify sender domain
3. Generate API key
4. Store in environment: `RESEND_API_KEY`
5. Set sender address: `COS_EMAIL={{cos.email}}`

Test:
```bash
curl -X POST https://api.resend.com/emails \
  -H "Authorization: Bearer {RESEND_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{"from": "{COS_EMAIL}", "to": ["{test-email}"], "subject": "Integration test", "text": "Wiring test."}'
```

---

### Discord (Async Messaging)

**Required for**: `discord-async-pickup.md`

Setup:
1. Create Discord application at discord.com/developers
2. Create a bot user
3. Generate bot token
4. Invite bot to server with read/send permissions
5. Get channel ID (right-click channel → Copy ID)
6. Store in environment:
   - `DISCORD_BOT_TOKEN`
   - `DISCORD_CHANNEL_ID`

Test:
```bash
curl -H "Authorization: Bot {DISCORD_BOT_TOKEN}" \
  https://discord.com/api/v10/channels/{DISCORD_CHANNEL_ID}/messages?limit=1
```

---

### Vercel (Deployment)

**Required for**: `card-promote.md`, `production-gate.md`

Setup:
1. Connect repo to Vercel project
2. Configure environment variables in Vercel dashboard
3. Set production branch (usually `main` or `master`)
4. Install Vercel CLI: `npm i -g vercel`
5. Authenticate: `vercel login`

Test:
```bash
vercel ls
```

---

### Supabase (Data Layer)

**Required for**: all data operations

Already covered in `data-layer-setup.md`. Verify:
- `SUPABASE_URL` and `SUPABASE_ANON_KEY` set
- `SUPABASE_DEV_URL` and `SUPABASE_DEV_ANON_KEY` set

---

## Environment Inventory

Maintain a complete list in `.env.example` (no real values — only variable names and descriptions):

```bash
# Supabase
SUPABASE_URL=                   # Production Supabase project URL
SUPABASE_ANON_KEY=              # Production anon/publishable key
SUPABASE_DEV_URL=               # Dev Supabase project URL
SUPABASE_DEV_ANON_KEY=          # Dev anon/publishable key

# Email
RESEND_API_KEY=                  # Resend API key
COS_EMAIL=                       # Sender email address

# Discord
DISCORD_BOT_TOKEN=              # Discord bot token
DISCORD_CHANNEL_ID=             # Primary channel for async messages

# Deployment
VERCEL_TOKEN=                   # Vercel personal access token (CLI use)
```

---

## Credential Storage Rules

- Never commit real credentials
- Use `.env` locally (gitignored)
- Use platform secrets for CI/CD (Vercel env vars, GitHub secrets)
- Document credential rotation schedule in `tools/credentials.md`

---

## Related

- **Data layer**: `workflows/public/data-layer-setup.md`
- **Monitoring**: `workflows/public/monitoring-setup.md`
- **System bootstrap**: `workflows/public/system-bootstrap.md`
- **Credentials doc**: `tools/credentials.md`

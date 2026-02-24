---
type: workflow
trigger: /{{cos.name}}-email
status: active
created: 2026-02-10
updated: 2026-02-18
category: communication
playbook_phase: null
related_workflows: []
project_scope: all
last_used: null
---

# Workflow: Email Send

## Purpose

Send email via the configured email provider (Resend). {{cos.name}} sends on behalf of {{user.name}} — always from the configured CoS address, with {{user.name}}'s name in the display name.

## Prerequisites

- [ ] Resend API key configured (`RESEND_API_KEY` in environment)
- [ ] Sender address verified in Resend
- [ ] Recipient address confirmed with {{user.name}} before sending

---

## Step 1: Confirm Send

Before sending any email, confirm with {{user.name}}:

```
To: {recipient}
Subject: {subject}
From: {{cos.name}} on behalf of {display name}

{body preview}

Confirm send? YES / edit first
```

Never send without confirmation. Email is irreversible.

---

## Step 2: Compose Email

Compose using {{user.name}}'s voice — not {{cos.name}}'s analytical style. Emails from this address represent {{user.name}}.

**Tone calibration**: Check `identity/{{user.name}}/voice.md` if it exists, or ask {{user.name}} to describe the register (formal, casual, professional-friendly, etc.).

---

## Step 3: Send via Resend

```bash
curl -X POST https://api.resend.com/emails \
  -H "Authorization: Bearer {RESEND_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "from": "{{cos.name}} <{{cos.email}}>",
    "to": ["{recipient}"],
    "subject": "{subject}",
    "text": "{body}"
  }'
```

Or via the Resend SDK if configured.

---

## Step 4: Log the Send

After a successful send:

```sql
INSERT INTO inbox_items (source, content, status, direction)
VALUES ('email', 'Sent to {recipient}: {subject}', 'done', 'outbound');
```

---

## Sender Configuration

| Variable | Value |
|----------|-------|
| `RESEND_API_KEY` | From Resend dashboard |
| `COS_EMAIL` | `{{cos.email}}` |
| `COS_DISPLAY_NAME` | `{{cos.name}}` |

Update `{{cos.email}}` and display name to match your provisioned workspace values.

---

## Anti-Patterns

- **Never send without confirmation** — even if the email looks obvious
- **Never CC external parties** unless explicitly requested
- **Never use BCC** without {{user.name}} awareness
- **Never send sensitive information** (credentials, private data) via email

---

## Related

- **Discord pickup**: `workflows/public/discord-async-pickup.md`
- **Release notes** (uses email): `workflows/public/release-notes.md`

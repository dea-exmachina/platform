---
type: workflow
trigger: manual
status: active
created: 2026-02-12
updated: 2026-02-18
category: communication
playbook_phase: null
related_workflows:
  - session-resume.md
project_scope: all
last_used: null
---

# Workflow: Discord Async Pickup

## Purpose

Process messages received via Discord while {{cos.name}} was offline. Check for actionable items, flag anything requiring {{user.name}} input, and queue any work.

## When to Use

- At session start if Discord integration is configured
- When {{user.name}} mentions pending Discord messages
- Triggered via `/{{cos.name}}-inbox` if Discord is a configured inbox source

---

## Prerequisites

- [ ] Discord integration configured (bot token, channel ID in `.env`)
- [ ] MCP Discord tool available, or Discord API accessible

---

## Step 1: Fetch Recent Messages

Retrieve messages from the configured channel since the last session:

```
GET /channels/{DISCORD_CHANNEL_ID}/messages?limit=50&after={last_message_id}
```

Store the last processed message ID to avoid re-processing.

---

## Step 2: Triage Messages

For each message:

| Type | Action |
|------|--------|
| Task request | Create NEXUS card, add to inbox |
| Question requiring {{user.name}} | Flag for {{user.name}} at session start |
| Question {{cos.name}} can answer | Draft response |
| FYI / no action needed | Log and dismiss |
| External notification | Route to relevant workflow |

---

## Step 3: Process Actionable Items

For task requests:
```sql
INSERT INTO inbox_items (source, content, status, priority)
VALUES ('discord', '{message content}', 'pending', 'medium');
```

For questions {{cos.name}} can answer: draft response and present to {{user.name}} for approval before sending.

---

## Step 4: Report to {{user.name}}

At session start, summarize:

```
Discord pickup: {N} messages since last session
- {N} tasks queued
- {N} items needing your input
- {N} dismissed (no action)
```

---

## Configuration

Store Discord credentials in `.env`:

```
DISCORD_BOT_TOKEN={token}
DISCORD_CHANNEL_ID={channel-id}
DISCORD_LAST_MESSAGE_ID={auto-updated by workflow}
```

Do not hardcode channel IDs or user IDs in workflow files.

---

## Related

- **Session resume**: `workflows/public/session-resume.md`
- **Inbox processing**: {{cos.name}} inbox workflow
- **Email send**: `workflows/public/email-send.md`

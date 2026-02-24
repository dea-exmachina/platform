---
type: workflow
trigger: /{{cos.name}}-goodmorning
status: active
created: 2026-02-06
updated: 2026-02-18
category: meta
playbook_phase: null
related_workflows:
  - session-handoff.md
  - discord-async-pickup.md
project_scope: meta
last_used: null
---

# Workflow: Session Resume

> Start every session from the handoff. No reconstruction from memory.

## Purpose

Restore full context at the start of a new session. The handoff document from the previous session is the authoritative state. This workflow ensures {{cos.name}} is oriented before taking any action.

## Trigger

Invoked via `/{{cos.name}}-goodmorning` or at any session start.

---

## Step 1: Read Last Session Handoff

```
Read: sessions/last-session.md
```

Extract:
- Active threads and their status
- Open bender tasks
- Pending questions for {{user.name}}
- Recommended next action

---

## Step 2: Check Kanban State

Query current lane distribution to understand what has changed since last session:

```sql
SELECT
  p.name as project,
  c.lane,
  count(*) as count
FROM nexus_cards c
JOIN nexus_projects p ON c.project_id = p.id
WHERE c.lane IN ('in_progress', 'review', 'ready')
GROUP BY p.name, c.lane
ORDER BY p.name;
```

Compare against the snapshot in the handoff. Note anything that moved.

---

## Step 3: Check Async Channels (optional)

If configured:
- Run `discord-async-pickup.md` to check Discord messages
- Scan inbox items: `SELECT * FROM inbox_items WHERE status = 'pending' ORDER BY created_at DESC LIMIT 10`

---

## Step 4: Synthesize and Brief {{user.name}}

Produce a session-start brief:

```
## Good morning, {{user.name}} — {date}

**Last session**: {1-sentence summary from handoff}

**Active threads**:
- {thread}: {status}

**Recommended start**: {what to do first}

**Pending your input**:
- {question or decision needing {{user.name}}}

**Board**: {N} cards in progress, {N} in review
```

---

## Step 5: Ready

After briefing, wait for {{user.name}}'s direction or proceed with the recommended next action if autonomy level permits.

---

## If No Handoff Exists

If `sessions/last-session.md` doesn't exist or is empty:
- Check git log for recent commits (gives recent activity context)
- Check NEXUS for in-progress cards
- Brief {{user.name}}: "No handoff found from last session. Here's what I can see on the board..."

---

## Related

- **Session handoff**: `workflows/public/session-handoff.md`
- **Discord pickup**: `workflows/public/discord-async-pickup.md`

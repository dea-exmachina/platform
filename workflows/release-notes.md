---
type: workflow
trigger: manual
status: active
created: 2026-02-10
updated: 2026-02-18
category: communication
playbook_phase: null
related_workflows:
  - release-batch.md
  - card-promote.md
  - email-send.md
project_scope: all
last_used: null
---

# Workflow: Release Notes

## Purpose

Generate and distribute release notes after a production release. Release notes are the paper trail for what shipped, when, and why.

## When to Use

- After any production release (batch or single)
- When {{user.name}} wants to inform stakeholders of what shipped

---

## Step 1: Gather Released Cards

Query cards moved to `done` in the current release:

```sql
SELECT c.card_id, c.title, c.description, p.name as project
FROM nexus_cards c
JOIN nexus_projects p ON c.project_id = p.id
JOIN nexus_comments nc ON nc.card_id = c.id
WHERE nc.comment_type = 'delivery'
  AND nc.created_at > '{release-start-timestamp}'
ORDER BY p.name, c.card_id;
```

Or: use the card list from the release batch.

---

## Step 2: Write Release Notes

```markdown
# Release Notes — {date}

## What Shipped

### {Project Name}
- **{CARD-ID}**: {title} — {one-line description of what changed and why it matters}
- **{CARD-ID}**: {title} — {one-line description}

### {Project Name}
- **{CARD-ID}**: {title} — {one-line description}

## Infrastructure
{List any database migrations, config changes, or dependency updates}

## Known Issues
{Any known issues with this release, if any}

## Next Up
{Brief preview of what's coming in the next release cycle}
```

---

## Step 3: Distribute

### Internal (always)
Write to `docs/releases/{date}.md` in the vault.

### External (if applicable)
Send via email using `email-send.md` workflow:
- To: configured stakeholder list
- From: `{{cos.email}}`
- Subject: `{Workspace name} — Release Notes {date}`

---

## Tone

Release notes are written in {{user.name}}'s voice, not {{cos.name}}'s analytical register. They should read as if {{user.name}} wrote them personally:
- Clear, direct, non-technical where possible
- Focus on user impact, not implementation detail
- "We shipped X" not "Merged PR that implements X"

---

## Related

- **Release batch**: `workflows/public/release-batch.md`
- **Card promote**: `workflows/public/card-promote.md`
- **Email send**: `workflows/public/email-send.md`

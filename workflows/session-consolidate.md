---
type: workflow
trigger: /{{cos.name}}-consolidate
status: active
created: 2026-02-10
updated: 2026-02-18
category: meta
playbook_phase: null
related_workflows:
  - session-handoff.md
  - session-resume.md
project_scope: meta
last_used: null
---

# Workflow: Session Consolidate

## Purpose

Capture significant learnings, decisions, and knowledge from the current session and write them to the appropriate persistent files. Distinct from handoff — consolidation is about knowledge, handoff is about state.

## When to Use

- Mid-session when significant knowledge has accumulated
- Before a session handoff, as a precursor step
- When a bender has delivered significant domain knowledge worth persisting
- Weekly knowledge review (`/{{cos.name}}-learn`)

---

## What Gets Consolidated

### Learnings
New understanding that should survive session boundaries:
- Patterns discovered
- Anti-patterns identified
- Domain knowledge from bender deliverables
- External information gathered by Overseer

### Decisions
Decisions made this session that belong in the decision log:
- Architecture choices
- Governance changes
- Strategic pivots

### Context updates
Changes to files that define how the system operates:
- Wisdom doc updates
- Bender context file updates
- Identity updates

---

## Step 1: Review Session Work

Scan the session for consolidation candidates:
- What did we learn that we didn't know before?
- Were any decisions made that should be logged?
- Did any bender reveal domain knowledge worth persisting?
- Did Overseer provide research findings worth saving?

---

## Step 2: Route to Target Files

| Learning Type | Target File |
|---------------|-------------|
| Domain patterns | `identity/{{cos.name}}/wisdom.md` or `wisdom/{topic}.md` |
| Bender-specific | `identity/{bender}/learnings.md` |
| Project-specific | `identity/{bender}/{team}/knowledge.md` |
| Architectural decisions | `identity/council/decision-log.md` + `docs/decisions/ADR-XXX.md` |
| Learning signals | Supabase `learning_signals` table (via signal-emit.md) |

---

## Step 3: Write Updates

For each consolidation target:
- Be precise — no filler
- Reference the source (card ID, session date)
- Follow the file's existing format

---

## Step 4: Confirm

Present a brief summary to {{user.name}}:

```
Session consolidate complete.

Updated:
- {file}: {what changed}
- {file}: {what changed}

Learning signals emitted: {N}
```

---

## Related

- **Session handoff**: `workflows/public/session-handoff.md`
- **Signal emission**: `workflows/public/signal-emit.md`
- **Decision log**: `workflows/public/decision-log.md`

---
type: workflow
trigger: /{{cos.name}}-handoff
status: active
created: 2026-02-06
updated: 2026-02-18
category: meta
playbook_phase: null
related_workflows:
  - session-resume.md
  - session-consolidate.md
  - signal-emit.md
project_scope: meta
last_used: null
---

# Workflow: Session Handoff

> End every session with a complete handoff. No invisible state.

## Purpose

Close a work session with full context capture. The next session starts from the handoff — not from memory. A complete handoff means zero reconstruction cost at resume.

## When to Use

- End of every work session
- When switching context for more than 30 minutes
- When handing off to a different Claude instance
- Triggered via `/{{cos.name}}-handoff`

---

## Step 0: Pre-Handoff Checklist

Before writing the handoff document:

- [ ] **0.1** All bender tasks have a status update (not left mid-flight)
- [ ] **0.2** Open PRs or branches are noted
- [ ] **0.3** Any decisions made are either logged or noted for logging
- [ ] **0.4** Kanban reflects actual state (not what it was at session start)
- [ ] **0.5** No credentials or sensitive data in open files
- [ ] **0.6** In-progress files are saved
- [ ] **0.7** Any blocking questions for {{user.name}} are noted
- [ ] **0.8** Outstanding tasks that were started but not completed are noted
- [ ] **0.9** Wisdom updates identified (will be written in Step 3)
- [ ] **0.10** Context update needed for any bender? (note for next session)
- [ ] **0.11** Learning signals emitted for significant work items this session

---

## Step 1: Write Handoff Document

Write to `sessions/last-session.md` (overwrite — this file always holds the latest):

```markdown
# Session Handoff — {YYYY-MM-DD HH:mm}

## Session Summary
{2-3 sentences — what was accomplished, what moved}

## Active Threads
{What is in-flight right now — do not let these get lost}

| Thread | Status | Next Action | Blocking? |
|--------|--------|-------------|-----------|
| {description} | in_progress | {what needs to happen} | YES/NO |

## Open Bender Tasks
| Bender | Card | Status | Notes |
|--------|------|--------|-------|
| {name} | {CARD-ID} | executing/delivered | {any notes} |

## Decisions Made
{Decisions made this session that need to be logged or reviewed}

## Pending for {{user.name}}
{Questions or decisions that need {{user.name}}'s input}

## Kanban Snapshot
{Brief state of the board — what's where}

## Next Session — Recommended Start
{What {{cos.name}} should do first in the next session}

## Files Modified This Session
{List of files touched — helps the next instance orient quickly}
```

---

## Step 2: Update Kanban Handoff Section

In the primary NEXUS project, find or create the Handoff card and update its content with the session summary.

---

## Step 3: Wisdom Updates

If any session learning warrants a wisdom update:
- Write to `identity/{{cos.name}}/wisdom.md`
- Keep it specific and actionable
- One entry per distinct insight

---

## Step 4: Session Score

Rate the session 1-5 on three dimensions:

| Dimension | Score | Notes |
|-----------|-------|-------|
| **Momentum** | /5 | Did we move things forward? |
| **Quality** | /5 | Was the work done well? |
| **Alignment** | /5 | Were we working on the right things? |

Overall: {average}/5 — {one-sentence assessment}

Write score to `sessions/session-log.md` (append, not overwrite).

---

## Step 5: Deliver Handoff to {{user.name}}

Present a paste-ready summary:

```
## Session Handoff — {date}

**Accomplished**: {1-3 bullet points}
**In-flight**: {what's running}
**Next session**: {recommended first action}
**Score**: {X}/5
```

---

## Files Used in This Workflow

- `sessions/last-session.md` — always overwritten with latest handoff
- `sessions/session-log.md` — append-only log of all sessions
- `identity/{{cos.name}}/wisdom.md` — updated when insights warrant

---

## Related

- **Session resume**: `workflows/public/session-resume.md`
- **Session consolidate**: `workflows/public/session-consolidate.md`
- **Signal emission**: `workflows/public/signal-emit.md`

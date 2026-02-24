---
type: workflow
workflow_type: reference
trigger: always
status: active
created: 2026-02-10
updated: 2026-02-18
category: meta
playbook_phase: null
related_workflows:
  - system-bootstrap.md
  - hive-construct.md
  - webapp-development.md
project_scope: meta
last_used: null
---

# System Playbook

> Master reference for workspace operation. Load at system setup and when something feels broken.

## What This System Is

A personal operating system for ambitious humans working with AI. The system has three layers:

1. **Nerve Center** — {{cos.name}} (chief of staff AI) + NEXUS kanban + Supabase data layer
2. **Execution Layer** — Bender swarm (specialized AI agents) executing tasks under {{cos.name}} direction
3. **Governance Layer** — Council constructs providing strategic direction and quality standards

---

## The Guiding Star

> *Enable humans and AI to work together to solve real problems and build great things.*

Every component of this system exists to serve this star. If it doesn't, it gets removed.

---

## Phases of Operation

### Phase 1: Bootstrap

Run once. Establishes the workspace from zero.

**Sequence**: identity-setup → data-layer-setup → kanban-setup → council-setup → delegation-policy-setup → integration-wiring → monitoring-setup

See `system-bootstrap.md` for the full sequence.

**Output**: Operational workspace. {{cos.name}} is calibrated. NEXUS is running. Data layer is live. Governance is initialized.

---

### Phase 2: Team Assembly (optional)

Run when a project requires coordinated bender execution.

**Workflow**: `hive-construct.md` → `team-onboard.md`

**Output**: Named bender team with identity files, team manifest, and project knowledge. Ready for Phase 3.

---

### Phase 3: Project Execution

Ongoing. The main operating loop.

```
Sprint Init
  → Assign cards ({{cos.name}} and benders)
    → Execute (benders on task branches)
      → Review ({{cos.name}} reviews bender work)
        → Promote ({{cos.name}} merges to production)
          → Sprint Review
            → Sprint Vision Review
              → Next Sprint Init
```

**Key workflows**:
- `sprint-init.md` — start sprint
- `bender-assign.md` — dispatch tasks
- `bender-review.md` — review deliverables
- `card-promote.md` — ship to production
- `sprint-review.md` — close sprint
- `sprint-vision-review.md` — directional health check

---

### Phase 4: Governance (ongoing)

Periodic checks to keep the system healthy.

**Quarterly**: `council-review.md` — governance diagnostic across all five domains
**At sprint close**: `sprint-vision-review.md` — directional health check
**On demand**: `council.md` — strategic decision sessions

---

## Governance Constructs

The council represents five governance domains:

| Domain | Responsibility |
|--------|---------------|
| Supreme Authority | Direction, trajectory, guiding star alignment |
| Team Construction | Bender architecture, context, dispatch quality |
| Quality Standards | Execution quality, learning pipeline, standards |
| Data Custodianship | Schema, RLS, data integrity, signal quality |
| External Orchestration | Integrations, external dependencies, pipelines |

Constructs are invoked during council sessions and plan reviews. They don't have names that appear in production context files — they represent governance functions, not characters.

---

## Bender Model

Benders are specialized AI agents that execute under {{cos.name}}'s direction.

| Layer | Who | Does What |
|-------|-----|----------|
| Orchestration | {{cos.name}} | Architecture, decomposition, review, merge |
| Execution | Benders | Implementation, research, writing, analysis |

**Rules**:
- Benders branch from `dev`, deliver to `dev`
- {{cos.name}} reviews before merging
- Only {{cos.name}} promotes to production
- Benders never touch META files or identity/

---

## Learning Pipeline

Every task completion emits a learning signal (once activated). Signals feed:
- **Cold path**: Pattern detection → wisdom doc generation
- **Hot path**: PRE-TASK INTELLIGENCE briefings for next agent in same domain

The learning pipeline requires setup. See `signal-emit.md` and `docs/setup/learning-pipeline.md`.

---

## File Structure

```
identity/
  {{cos.name}}/          — CoS identity, wisdom, delegation policy
  council/          — Direction doc, decision log, diagnostic outputs
  {bender}/         — Bender identity files
benders/
  context/          — Shared and role-specific bender context
  teams/            — Team manifests
workflows/
  public/           — All operational workflows
  INDEX.md          — Workflow index
sessions/
  last-session.md   — Latest session handoff
  session-log.md    — Historical session log
supabase/
  migrations/       — Database migration files
docs/
  decisions/        — Architecture Decision Records
  releases/         — Release notes history
```

---

## Emergency Contacts

If something is broken:
1. Check `sessions/last-session.md` — is there context about what was in-flight?
2. Check NEXUS kanban — what's in `in_progress`?
3. Run `council-review.md` — systematic diagnostic
4. Check Supabase and Vercel logs

---

## Related

- **Bootstrap**: `workflows/public/system-bootstrap.md`
- **Council**: `workflows/public/council.md`
- **Sprint cycle**: `workflows/public/sprint-init.md`, `sprint-review.md`
- **Bender dispatch**: `workflows/public/bender-assign.md`

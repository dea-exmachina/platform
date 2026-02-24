---
type: workflow
trigger: manual
status: active
created: 2026-02-10
updated: 2026-02-18
category: governance
playbook_phase: "1.4"
related_workflows:
  - council.md
  - council-review.md
  - system-bootstrap.md
project_scope: meta
last_used: null
---

# Workflow: Council Setup

## Purpose

Bootstrap the governance council — create the identity files, direction document, and NEXUS project that anchor the council construct. Run once during system initialization.

## Prerequisites

- [ ] System bootstrap complete (`workflows/public/system-bootstrap.md`)
- [ ] NEXUS kanban operational
- [ ] {{cos.name}} identity established

---

## Step 1: Create Council Identity Files

### Directory structure

```
identity/council/
  README.md               — what the council is and how it works
  direction.md            — 90-day arc, open tensions, directional bets
  diagnostics/            — periodic governance diagnostic outputs
```

### direction.md scaffold

```markdown
# Direction — {workspace name}

## Guiding Star
{The single north star for this system}

## 90-Day Arc
**Current focus**: {what are we building toward this quarter?}
**Key bets**: {what hypotheses are we testing?}

## Directional Bets
| Bet | Hypothesis | Signal |
|-----|-----------|--------|
| {name} | {what we believe} | {how we'll know if true} |

## Open Tensions
| Tension | Status | Last Addressed |
|---------|--------|---------------|
| {tension} | 🟡 active | {date} |

## Last Sprint's Vision Alignment
**Sprint**: —
**Verdict**: —
**Evidence**: —
```

---

## Step 2: Create Council NEXUS Project

Create a NEXUS project for council/governance work:

```sql
INSERT INTO nexus_projects (name, slug, description, status)
VALUES (
  'Council',
  'council',
  'Governance, direction, and meta-framework work',
  'active'
);
```

---

## Step 3: Create Governance Cards

Seed the council project with standing governance cards:

```sql
-- Quarterly review card
INSERT INTO nexus_cards (project_id, title, description, lane, priority)
VALUES (
  (SELECT id FROM nexus_projects WHERE slug = 'council'),
  'Quarterly Council Review',
  'Run the governance diagnostic across all five domains.',
  'backlog',
  'medium'
);
```

---

## Step 4: Verify

- [ ] `identity/council/` directory exists with required files
- [ ] `direction.md` has all sections (even if sparse)
- [ ] Council NEXUS project created
- [ ] {{cos.name}} can invoke `/{{cos.name}}-council` without errors

---

## Related

- **Council sessions**: `workflows/public/council.md`
- **Council diagnostics**: `workflows/public/council-review.md`
- **Sprint vision review**: `workflows/public/sprint-vision-review.md`
- **System bootstrap**: `workflows/public/system-bootstrap.md`

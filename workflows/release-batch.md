---
type: workflow
trigger: /{{cos.name}}-release
status: active
created: 2026-02-10
updated: 2026-02-18
category: git
playbook_phase: null
related_workflows:
  - card-promote.md
  - production-gate.md
  - release-notes.md
project_scope: all
last_used: null
---

# Workflow: Release Batch

> Batch promote all ready-for-production cards across all projects.

## Purpose

Discover all cards flagged as ready for production, group by deployment target, promote in dependency order, run production gate, and write release notes.

## When to Use

- End-of-sprint batch release
- When multiple cards have accumulated in "ready for production" state
- Triggered via `/{{cos.name}}-release`

---

## Step 1: Discover Release Candidates

Query for cards ready to ship:

```sql
SELECT
  c.card_id,
  c.title,
  p.name as project,
  p.slug as deployment_target
FROM nexus_cards c
JOIN nexus_projects p ON c.project_id = p.id
WHERE c.lane = 'review'
  AND c.tags @> '["release-ready"]'
ORDER BY p.slug, c.priority DESC;
```

Or: manually review the `review` lane across active projects.

---

## Step 2: Group by Deployment Target

Organize cards by where they deploy:

| Target | Cards | Notes |
|--------|-------|-------|
| Vault (dea-exmachina) | {list} | Merge to main |
| App (control-center) | {list} | Merge + Vercel deploy |
| Database | {list} | Migration promote |

---

## Step 3: Dependency Check

Before promoting, check for dependencies:
- Does Card A depend on Card B being promoted first?
- Are there migration dependencies?
- Are there integration dependencies (e.g., schema change before app deploy)?

Order: Database migrations → Vault → App

---

## Step 4: Promote in Order

For each card, in dependency order:
1. Run `card-promote.md` steps
2. Run `production-gate.md` checklist
3. Mark card `done` on NEXUS
4. Move to next card

Do not batch-promote without individual gate checks.

---

## Step 5: Write Release Notes

After all cards are promoted and gates passed, run `release-notes.md` to:
- Summarize what shipped
- Group by project/area
- Send to configured recipients

---

## Step 6: Announce (optional)

If this is a significant release, announce via Discord or email to relevant stakeholders.

---

## Rollback Procedure

If a promotion fails mid-batch:
1. Stop the batch immediately
2. Rollback the failed promotion
3. Assess whether prior promotions need rollback (if dependent)
4. Investigate and fix
5. Re-run from the failed step (not from the beginning)

---

## Related

- **Card promote**: `workflows/public/card-promote.md`
- **Production gate**: `workflows/public/production-gate.md`
- **Release notes**: `workflows/public/release-notes.md`
- **Migration promote**: `workflows/public/migration-promote.md`

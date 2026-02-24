---
type: workflow
trigger: manual
status: active
created: 2026-02-08
updated: 2026-02-18
category: infrastructure
playbook_phase: null
related_workflows:
  - data-layer-setup.md
  - dev-pipeline-sop.md
project_scope: all
last_used: null
---

# Workflow: Migration Promote

## Purpose

Promote a verified database migration from the dev Supabase instance to production. Always dev before production — never apply migrations directly to production without dev verification.

## Rule

**Dev instance = test bed. Production instance = verified state.**

Every migration is applied to dev first. Only after manual verification does it get promoted to production.

---

## Step 1: Verify on Dev

Confirm the migration is applied and working on dev:

```bash
curl -s "{SUPABASE_DEV_URL}/rest/v1/{table}?select=*&limit=1" \
  -H "apikey: {SUPABASE_DEV_ANON_KEY}" \
  -H "Authorization: Bearer {SUPABASE_DEV_ANON_KEY}"
```

Verify:
- [ ] Table/column exists as expected
- [ ] RLS policies are active
- [ ] No error responses
- [ ] Any dependent code works against dev

---

## Step 2: Review Migration SQL

Read the migration file before promoting:

```bash
cat supabase/migrations/{timestamp}_{name}.sql
```

Check:
- [ ] No irreversible destructive operations (DROP TABLE, DELETE FROM without WHERE)
- [ ] Correct schema (public vs other)
- [ ] Idempotent if possible (IF NOT EXISTS, IF EXISTS)
- [ ] No hardcoded values that are dev-specific

---

## Step 3: Apply to Production

Apply via Supabase MCP or direct API:

```bash
# Via Supabase CLI (if configured)
supabase db push --project-ref {PRODUCTION_PROJECT_ID}

# Or via direct SQL execution through Supabase MCP tool
```

---

## Step 4: Verify on Production

Immediately after applying:

```bash
curl -s "{SUPABASE_URL}/rest/v1/{table}?select=*&limit=1" \
  -H "apikey: {SUPABASE_ANON_KEY}" \
  -H "Authorization: Bearer {SUPABASE_ANON_KEY}"
```

Verify same checks as dev verification.

---

## Step 5: Record

Add to migration log in `supabase/migrations/APPLIED.md` (or equivalent tracking):

```markdown
| {timestamp} | {migration name} | dev | {date-dev} | prod | {date-prod} | {notes} |
```

---

## Rollback

If production migration causes issues:

1. Write a compensating migration (undo the change)
2. Apply compensating migration to dev first
3. Verify dev is correct
4. Promote compensating migration to production

Never run ad-hoc SQL against production to undo a migration.

---

## Environments

| Environment | URL Variable | Key Variable |
|-------------|-------------|-------------|
| Dev | `SUPABASE_DEV_URL` | `SUPABASE_DEV_ANON_KEY` |
| Production | `SUPABASE_URL` | `SUPABASE_ANON_KEY` |

---

## Related

- **Data layer setup**: `workflows/public/data-layer-setup.md`
- **Dev pipeline SOP**: `workflows/public/dev-pipeline-sop.md`
- **Production gate**: `workflows/public/production-gate.md`

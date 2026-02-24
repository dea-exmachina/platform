---
type: workflow
trigger: manual
status: active
created: 2026-02-10
updated: 2026-02-18
category: infrastructure
playbook_phase: "1.2"
related_workflows:
  - migration-promote.md
  - kanban-setup.md
  - monitoring-setup.md
  - system-bootstrap.md
project_scope: all
last_used: null
---

# Workflow: Data Layer Setup

## Purpose

Bootstrap the Supabase data layer for a new workspace. Establishes the NEXUS schema, RLS policies, and core tables required before any other workflow can run.

## Prerequisites

- [ ] Supabase project created (dev and production instances)
- [ ] Supabase credentials available
- [ ] Migration tool configured

---

## Step 1: Create Supabase Projects

### Dev instance
Create a Supabase project for development. Record the project ID and anon key.

### Production instance
Create a separate Supabase project for production. Record the project ID and anon key.

Store credentials securely — not in version control. Use environment variables or a secrets manager.

---

## Step 2: Apply Foundation Migrations

Apply migrations in order. Use dev instance first — always dev before production.

### Core schema migrations (apply in this order)

1. `001_nexus_core.sql` — projects, cards, lanes
2. `002_nexus_comments.sql` — card comments and history
3. `003_nexus_events.sql` — audit event log
4. `004_bender_tasks.sql` — bender task tracking
5. `005_learning_signals.sql` — learning pipeline signals
6. `006_rls_policies.sql` — row-level security

See `supabase/migrations/` for the full migration set.

---

## Step 3: Configure RLS

Every table must have RLS enabled. Verify:

```sql
SELECT tablename, rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;
```

All tables should show `rowsecurity = true`.

---

## Step 4: Seed Core Data

```sql
-- Create the meta project (for governance/council work)
INSERT INTO nexus_projects (name, slug, description, status)
VALUES ('Meta', 'meta', 'Governance and system work', 'active');
```

---

## Step 5: Verify Connection

Test that the anon key can read cards:

```bash
curl -s "{SUPABASE_URL}/rest/v1/nexus_cards?select=card_id,title&limit=5" \
  -H "apikey: {SUPABASE_ANON_KEY}" \
  -H "Authorization: Bearer {SUPABASE_ANON_KEY}"
```

Should return `[]` (empty array) — not an error.

---

## Step 6: Update Environment

Add to `.env` (or equivalent):

```
SUPABASE_URL=https://{project-id}.supabase.co
SUPABASE_ANON_KEY={anon-key}
SUPABASE_DEV_URL=https://{dev-project-id}.supabase.co
SUPABASE_DEV_ANON_KEY={dev-anon-key}
```

---

## Step 7: Promote to Production

Once dev migrations are verified, promote to production. Follow `workflows/public/migration-promote.md`.

---

## Checklist

- [ ] Dev Supabase project created and accessible
- [ ] Production Supabase project created and accessible
- [ ] All foundation migrations applied to dev
- [ ] RLS enabled on all tables
- [ ] Core seed data applied
- [ ] Connection verified via curl
- [ ] Credentials stored securely
- [ ] Migrations promoted to production

---

## Related

- **Migration promotion**: `workflows/public/migration-promote.md`
- **Kanban setup**: `workflows/public/kanban-setup.md`
- **Monitoring setup**: `workflows/public/monitoring-setup.md`
- **System bootstrap**: `workflows/public/system-bootstrap.md`

---
type: workflow
workflow_type: reference
trigger: always
status: active
created: 2026-02-08
updated: 2026-02-18
category: infrastructure
playbook_phase: null
related_workflows:
  - card-branch.md
  - card-promote.md
  - migration-promote.md
  - production-gate.md
project_scope: all
last_used: null
---

# Dev Pipeline SOP

> Reference document — load when working on any code or infrastructure change.

## The FLOW Frame

```
Plan → Card → Branch → Develop → Review → Promote → Verify → Done
```

Every code change follows this frame. No exceptions.

---

## Repository Structure

This workspace may have multiple repositories:

| Repo | Purpose | Branch model |
|------|---------|-------------|
| `{{workspace.name}}` (vault) | Identity, workflows, docs, config | `dev` → `main` |
| `control-center` (or equivalent) | Web application code | `dev` → `main` (or `master`) |

Adjust to your actual repo setup during provisioning.

---

## Branch Strategy

### Vault (dea-exmachina or equivalent)
```
main (production)
  └── dev (working branch)
        └── task/{CARD-ID}    ← bender and {{cos.name}} work here
```

### App (control-center or equivalent)
```
main / master (production — Vercel deploys from here)
  └── dev (staging)
        └── card/{CARD-ID}    ← implementation branches
```

**Rule**: Benders always branch from `dev`. Only {{cos.name}} merges to `dev`. Only {{cos.name}} promotes `dev` → `main`.

---

## Migration Pipeline

Always dev before production. Never touch production without a tested dev migration.

```
Write migration SQL
  → Apply to dev Supabase instance
    → Verify behavior in dev
      → Promote to production Supabase instance
        → Verify in production
```

See `workflows/public/migration-promote.md` for full steps.

---

## Deployment Pipeline

### App deployment
```
Merge to main/master → Vercel auto-deploys → Verify deployment → Production gate
```

### Vault deployment
```
Merge to main → Git push → No deployment needed (file-based)
```

---

## Environment Variables

Track all required environment variables in `.env.example`. Never commit real values.

| Variable | Used By | Notes |
|----------|---------|-------|
| `SUPABASE_URL` | All Supabase calls | Production instance URL |
| `SUPABASE_ANON_KEY` | Client-side Supabase | Publishable |
| `SUPABASE_DEV_URL` | Dev Supabase calls | Dev instance URL |
| `SUPABASE_DEV_ANON_KEY` | Dev client | Publishable (dev) |

Add project-specific variables as needed.

---

## Code Quality Gates

All code must pass before merge:

```bash
tsc --noEmit      # TypeScript check
npm run lint      # Lint
npm test          # Tests (if applicable)
```

Pre-commit hooks should enforce these automatically.

---

## Emergency Rollback

If production breaks after a deploy:

### App rollback
Revert the merge commit:
```bash
git revert HEAD --no-edit
git push origin main
```

### Migration rollback
Write a compensating migration — do not run raw SQL against production outside of the migration pipeline.

---

## Related

- **Card branch**: `workflows/public/card-branch.md`
- **Card promote**: `workflows/public/card-promote.md`
- **Migration promote**: `workflows/public/migration-promote.md`
- **Production gate**: `workflows/public/production-gate.md`

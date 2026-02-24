---
type: workflow
trigger: manual
status: active
created: 2026-02-06
updated: 2026-02-18
category: git
playbook_phase: null
related_workflows:
  - card-promote.md
  - git-review.md
project_scope: all
last_used: null
---

# Workflow: Card Branch

## Purpose

Create a git branch tied to a NEXUS card. Every card that produces code or file changes gets a branch. No invisible work.

## Branch Naming Convention

```
task/{CARD-ID}        # standard card work
card/{CARD-ID}        # alias — same meaning
feature/{slug}        # multi-card feature work
fix/{CARD-ID}         # bug fix
```

---

## Step 1: Confirm Card Exists

```sql
SELECT card_id, title, lane FROM nexus_cards WHERE card_id = '{CARD-ID}';
```

Card must exist before branching. If it doesn't, create it first.

---

## Step 2: Create Branch

```bash
git checkout dev
git pull origin dev
git checkout -b task/{CARD-ID}
```

For control-center (Next.js app) work:
```bash
cd /path/to/control-center
git checkout master
git pull origin master
git checkout -b card/{CARD-ID}
```

---

## Step 3: Update Card Lane

```sql
UPDATE nexus_cards SET lane = 'in_progress' WHERE card_id = '{CARD-ID}';
```

---

## Step 4: Work + Commit

Follow commit convention:

```
[CARD-ID] Short imperative description

Optional body — what changed and why.
```

Example:
```
[NEX-142] Add signal_domain enum to learning_signals schema

Introduces the controlled vocabulary for domain classification.
Required before the hot path query can filter by domain.
```

---

## Step 5: Deliver

On completion, push branch and transition card:

```bash
git push -u origin task/{CARD-ID}
```

Then update bender_lane if this was a bender task:
```sql
UPDATE nexus_cards SET bender_lane = 'delivered' WHERE card_id = '{CARD-ID}';
```

---

## Branch Lifecycle

```
dev (base)
  └── task/{CARD-ID}    ← work happens here
        └── reviewed by {{cos.name}}
              └── merged to dev
                    └── dev → production (via promote workflow)
```

Benders branch from `dev`. {{cos.name}} merges to `dev`. Only {{cos.name}} promotes `dev` → production.

---

## Related

- **Promote workflow**: `workflows/public/card-promote.md`
- **Commit convention**: `workflows/public/task-commit.md`
- **Git review**: `workflows/public/git-review.md`
- **Production gate**: `workflows/public/production-gate.md`

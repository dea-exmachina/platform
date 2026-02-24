---
type: workflow
trigger: manual
status: active
created: 2026-02-10
updated: 2026-02-18
category: git
playbook_phase: null
related_workflows:
  - card-branch.md
project_scope: all
last_used: null
---

# Workflow: Git Sync

## Purpose

Sync a working branch with the latest dev (or main). Use when a task branch has drifted behind and needs upstream changes before continuing.

## When to Use

- A task branch was created days ago and dev has moved forward
- Merge conflicts need to be resolved before review
- Multiple benders working in parallel and one needs the other's changes

---

## Step 1: Fetch Latest

```bash
git fetch origin
```

---

## Step 2: Rebase (preferred) or Merge

### Rebase (cleaner history — preferred for task branches)
```bash
git checkout task/{CARD-ID}
git rebase origin/dev
```

If conflicts:
```bash
# Resolve conflicts in editor
git add {resolved-files}
git rebase --continue
```

### Merge (if rebase is risky due to many commits)
```bash
git checkout task/{CARD-ID}
git merge origin/dev
```

---

## Step 3: Verify

After sync:
```bash
npm run build    # or tsc --noEmit
npm run lint
```

Confirm nothing broke from the merge/rebase.

---

## Step 4: Force Push (rebase only)

If rebased, the branch history changed — must force push:
```bash
git push origin task/{CARD-ID} --force-with-lease
```

Use `--force-with-lease` (not `--force`) to avoid overwriting concurrent pushes.

---

## Conflict Resolution Guidelines

- **Type conflicts**: Take the newer type definition (usually from dev)
- **Schema conflicts**: Do NOT resolve automatically — check which migration is correct
- **Config conflicts**: Take the dev version unless the task branch specifically changed config
- **Logic conflicts**: Read both versions, understand intent, write the correct merge manually

When uncertain, surface the conflict to {{cos.name}} rather than guessing.

---

## Related

- **Card branch**: `workflows/public/card-branch.md`
- **Git review**: `workflows/public/git-review.md`

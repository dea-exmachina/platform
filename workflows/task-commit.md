---
type: workflow
trigger: manual
status: active
created: 2026-02-06
updated: 2026-02-18
category: git
playbook_phase: null
related_workflows:
  - card-branch.md
project_scope: all
last_used: null
---

# Workflow: Task Commit Convention

## Purpose

Standardize commit messages across all work in this workspace. Consistent commits make the history readable, searchable, and auditable.

---

## Commit Format

```
[{CARD-ID}] {imperative description}

{optional body — what changed and why}
```

### Rules

1. **Card prefix is mandatory** — every commit is tied to a card
2. **Imperative mood** — "Add", "Fix", "Remove" — not "Added", "Fixes", "Removing"
3. **Max 72 characters** on the first line
4. **Body is optional** — use it when the "why" isn't obvious from the "what"
5. **No trailing period** on the first line

---

## Examples

### Simple commit
```
[NEX-142] Add signal_domain enum to learning_signals schema
```

### With body
```
[NEX-156] Remove legacy auth middleware

The auth check was duplicated between middleware and route handler.
Consolidated into route handler only — middleware now passes through.
Fixes double-validation on all authenticated routes.
```

### Migration commit
```
[NEX-143] Create learning_signals table with RLS policies
```

### Fix commit
```
[NEX-167] Fix null pointer in signal emission when card_id absent
```

---

## Author Identity

Commits should reflect who did the work:

**{{cos.name}} commits**:
```bash
git commit --author="{{cos.name}} <{{cos.email}}>" -m "[{CARD-ID}] {message}"
```

**Bender commits** (when bender writes directly):
```bash
git commit --author="{Bender Name} <bender+{slug}@{{workspace.name}}>" -m "[{CARD-ID}] {message}"
```

Configure the author identity in `.gitconfig` or pass `--author` explicitly.

---

## Anti-Patterns

| Bad | Good |
|-----|------|
| `fix bug` | `[NEX-123] Fix null check in session validation` |
| `WIP` | Don't commit WIP — use stash or a draft commit that gets squashed |
| `updated stuff` | `[NEX-124] Update RLS policy to allow service role inserts` |
| `[NEX-123][NEX-124] ....` | One card per commit — split if needed |
| No card ID | Every commit has a card. If there's no card, create one first. |

---

## Commit Hygiene

- Commit at logical completion points — not at file-save frequency
- Each commit should leave the codebase in a working state
- Squash "fixup" commits before pushing: `git rebase -i HEAD~N`
- Don't force-push shared branches (dev, main)

---

## Related

- **Card branch**: `workflows/public/card-branch.md`
- **Git review**: `workflows/public/git-review.md`

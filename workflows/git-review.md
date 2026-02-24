---
type: workflow
trigger: /{{cos.name}}-git-review
status: active
created: 2026-02-10
updated: 2026-02-18
category: git
playbook_phase: null
related_workflows:
  - card-branch.md
  - card-promote.md
  - bender-review.md
project_scope: all
last_used: null
---

# Workflow: Git Review

## Purpose

Review a branch or PR before merging. Used by {{cos.name}} to validate bender deliverables (code) before merging to dev, and to validate dev before promoting to production.

---

## Step 1: Checkout and Inspect

```bash
git fetch origin
git checkout {branch-name}
git diff dev...{branch-name}  # for bender branches
# or
git diff main...dev           # for promotion review
```

---

## Step 2: Code Review Checklist

### Correctness
- [ ] Does the code do what the task brief specified?
- [ ] Are all acceptance criteria addressed?
- [ ] No obvious logic errors

### TypeScript / Type Safety
- [ ] `tsc --noEmit` passes
- [ ] No `any` casts without justification
- [ ] Types are specific and accurate

### Standards Compliance
- [ ] Naming follows project conventions
- [ ] File placement follows architecture decisions
- [ ] No files touched outside the task scope

### Security
- [ ] No credentials or secrets in code
- [ ] User input is validated
- [ ] No SQL injection vectors (use parameterized queries)
- [ ] RLS not bypassed

### Quality
- [ ] No dead code
- [ ] No console.log left in (unless intentional)
- [ ] Error handling is appropriate
- [ ] No unnecessary complexity

---

## Step 3: Run Local Verification

```bash
npm run build       # or: tsc --noEmit
npm run lint
npm test            # if tests exist
```

All must pass before approval.

---

## Step 4: Check Deployment Preview

If the project has a CI/CD pipeline (e.g., Vercel preview deployments), verify:
- Preview URL is accessible
- Core flows work on the preview
- No visible regressions

---

## Step 5: Verdict

### Approved — merge

```bash
git checkout dev
git merge {branch-name} --no-ff -m "[{CARD-ID}] Merge: {title}"
git push origin dev
```

### Needs work — send back

Write review notes in the card:
```sql
INSERT INTO nexus_comments (card_id, author, comment_type, content)
VALUES (
  (SELECT id FROM nexus_cards WHERE card_id = '{CARD-ID}'),
  '{{cos.name}}',
  'review',
  'Needs work: {specific issues listed}'
);
```

---

## Severity Levels

| Level | Meaning | Blocks merge? |
|-------|---------|--------------|
| BLOCKER | Must fix before merge | Yes |
| MAJOR | Should fix; acceptable to note and plan | Only if high risk |
| MINOR | Nice to fix; not blocking | No |
| NIT | Style preference | No |

---

## Related

- **Card branch**: `workflows/public/card-branch.md`
- **Card promote**: `workflows/public/card-promote.md`
- **Bender review**: `workflows/public/bender-review.md`
- **Production gate**: `workflows/public/production-gate.md`

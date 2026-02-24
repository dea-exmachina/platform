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
  - production-gate.md
  - release-notes.md
project_scope: all
last_used: null
---

# Workflow: Card Promote

## Purpose

Promote a card's work from dev to production. Only {{cos.name}} runs this workflow. Benders deliver to dev — promotion is a separate, gated step.

## Prerequisites

- [ ] Card is in `review` or `done` lane on NEXUS
- [ ] All acceptance criteria verified
- [ ] No known blockers or unresolved review comments
- [ ] Production gate checklist ready (`workflows/public/production-gate.md`)

---

## Step 1: Final Review

Before promoting, verify:

```sql
SELECT card_id, title, lane, bender_lane
FROM nexus_cards
WHERE card_id = '{CARD-ID}';
```

Confirm:
- `lane` = `review` or `done`
- No open `nexus_comments` with `comment_type = 'question'` or `'rejection'`

---

## Step 2: Merge to Production Branch

### Vault work (dea-exmachina)
```bash
git checkout dev
git pull origin dev
git checkout main
git merge dev --no-ff -m "[{CARD-ID}] Promote: {title}"
git push origin main
```

### App work (control-center or equivalent)
```bash
git checkout master
git pull origin master
# Merge the card branch
git merge card/{CARD-ID} --no-ff -m "[{CARD-ID}] Promote: {title}"
git push origin master
```

---

## Step 3: Run Production Gate

See `workflows/public/production-gate.md` for the full checklist. Minimum:

- [ ] Deployment succeeded (check Vercel / hosting provider)
- [ ] No runtime errors in logs
- [ ] Core user flow works as expected
- [ ] No visible regressions

---

## Step 4: Update Card

```sql
-- Move to done
UPDATE nexus_cards SET lane = 'done' WHERE card_id = '{CARD-ID}';

-- Add delivery comment
INSERT INTO nexus_comments (card_id, author, comment_type, content)
VALUES (
  (SELECT id FROM nexus_cards WHERE card_id = '{CARD-ID}'),
  '{{cos.name}}',
  'delivery',
  'Promoted to production. {brief summary of what shipped.}'
);
```

---

## Step 5: Release Notes (if applicable)

For significant releases, run `workflows/public/release-notes.md` to generate and distribute release notes.

---

## Promotion Authority

| Who | Can Promote? |
|-----|-------------|
| {{cos.name}} | Yes |
| Benders | No — benders deliver to dev only |

This is a hard rule. Benders never touch the production branch.

---

## Related

- **Card branch**: `workflows/public/card-branch.md`
- **Production gate**: `workflows/public/production-gate.md`
- **Release notes**: `workflows/public/release-notes.md`
- **Release batch**: `workflows/public/release-batch.md`

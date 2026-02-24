---
type: workflow
trigger: manual
status: active
created: 2026-02-08
updated: 2026-02-18
category: git
playbook_phase: null
related_workflows:
  - card-promote.md
  - migration-promote.md
project_scope: all
last_used: null
---

# Workflow: Production Gate

## Purpose

Verify that a deployment to production is stable before marking the card `done`. The production gate is a checklist — not optional, not abbreviated under pressure.

## When to Run

After every production deploy. Run before updating the card to `done`.

---

## Step 1: Verify Deployment Succeeded

Check the deployment platform (Vercel or equivalent):

```bash
vercel ls --scope {team}
```

Confirm:
- Latest deployment shows `Ready` (not `Error` or `Building`)
- Deployment is on the production domain (not a preview URL)

---

## Step 2: Verify Core Functionality

Test the critical user path manually. At minimum:

- [ ] Home/landing page loads without errors
- [ ] Authentication flow works (login, logout)
- [ ] Primary feature works end-to-end
- [ ] No visible JavaScript errors in browser console
- [ ] No visible 4xx or 5xx errors in network tab

For database-heavy features:
- [ ] Read operations return data
- [ ] Write operations persist correctly
- [ ] No RLS errors (403 responses on valid operations)

---

## Step 3: Check Logs

Review production logs for errors immediately post-deploy:

```bash
vercel logs --scope {team} --follow
```

Or check Vercel dashboard → project → Functions tab for any error spikes.

Supabase logs:
- Dashboard → Logs → API logs
- Check for 5xx errors or unexpected query patterns

---

## Step 4: Smoke Test Integrations

For deployments touching integrations:
- [ ] Email sends successfully (if email integration used)
- [ ] Supabase connection returns data (not 401 or 500)
- [ ] Any third-party APIs called return expected responses

---

## Step 5: Pass or Rollback

### PASS
```sql
UPDATE nexus_cards SET lane = 'done' WHERE card_id = '{CARD-ID}';
```

Add delivery comment:
```sql
INSERT INTO nexus_comments (card_id, author, comment_type, content)
VALUES (
  (SELECT id FROM nexus_cards WHERE card_id = '{CARD-ID}'),
  '{{cos.name}}',
  'delivery',
  'Production gate passed. {brief summary of what was deployed and verified.}'
);
```

### ROLLBACK NEEDED
If any step fails:
1. Revert the merge commit immediately
2. Push revert to production branch
3. Verify rollback is deployed
4. Investigate root cause before re-attempting

---

## Anti-Patterns

- **Marking done before verifying**: The card is not done until production is verified.
- **Skipping on "small" changes**: Small changes can break big things.
- **Testing on preview, not production**: Preview and production can diverge in env vars, services, data.

---

## Related

- **Card promote**: `workflows/public/card-promote.md`
- **Migration promote**: `workflows/public/migration-promote.md`
- **Git review**: `workflows/public/git-review.md`

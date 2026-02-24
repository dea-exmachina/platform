---
type: workflow
trigger: manual
status: active
created: 2026-02-10
updated: 2026-02-18
category: infrastructure
playbook_phase: "1.6"
related_workflows:
  - data-layer-setup.md
  - integration-wiring.md
  - system-bootstrap.md
project_scope: all
last_used: null
---

# Workflow: Monitoring Setup

## Purpose

Establish basic monitoring and alerting for the workspace infrastructure. Ensures {{cos.name}} is aware of failures before {{user.name}} notices them.

## What to Monitor

| System | Signal | Alert Threshold |
|--------|--------|----------------|
| Supabase (prod) | API response / error rate | Any 5xx errors |
| Vercel deployment | Build status | Failed builds |
| Email (Resend) | Delivery failures | Any bounce or failure |
| Discord bot | Online status | Bot offline > 5 min |

---

## Step 1: Supabase Health Check

Set up a scheduled query that verifies the production database is responding:

```sql
-- Canary query — should always return 1 row
SELECT 1 as health_check;
```

Options for scheduling:
- Vercel cron job
- External cron (cron-job.org, EasyCron)
- Supabase Edge Function with pg_cron

Alert destination: email to `{{user.email}}` or Discord message to the configured channel.

---

## Step 2: Vercel Deployment Monitoring

Vercel sends deployment notifications natively. Configure:
1. Vercel Dashboard → Project → Settings → Notifications
2. Add email: `{{user.email}}`
3. Enable: Failed deployments, Deployment success (optional)

---

## Step 3: Error Logging

For the web application, configure error logging:

```typescript
// In Next.js error boundaries or API routes
if (process.env.NODE_ENV === 'production') {
  console.error('Error:', error);
  // Optionally: send to logging service
}
```

Review Vercel function logs weekly or when issues are reported.

---

## Step 4: Uptime Monitoring

For publicly accessible services, use a free uptime monitor:
- uptimerobot.com
- betteruptime.com
- freshping.io

Configure to alert `{{user.email}}` on downtime.

---

## Step 5: Health Dashboard

Create a simple status check in `tools/health-check.md` that {{cos.name}} reviews at session start:

```markdown
# System Health — Last Checked {date}

| System | Status | Last Verified |
|--------|--------|--------------|
| Supabase prod | ✓ | {date} |
| Supabase dev | ✓ | {date} |
| Vercel | ✓ | {date} |
| Email (Resend) | ✓ | {date} |
| Discord bot | ✓ | {date} |
```

---

## Alert Routing

| Alert Type | Goes To | Via |
|------------|---------|-----|
| Infrastructure down | {{user.name}} | Email |
| Build failure | {{cos.name}} (handles at session start) | Vercel email |
| Database error | {{cos.name}} | Supabase logs |

---

## Related

- **Data layer**: `workflows/public/data-layer-setup.md`
- **Integration wiring**: `workflows/public/integration-wiring.md`
- **System bootstrap**: `workflows/public/system-bootstrap.md`

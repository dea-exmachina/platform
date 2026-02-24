---
type: workflow
trigger: manual
status: active
created: 2026-02-10
updated: 2026-02-18
category: planning
playbook_phase: null
related_workflows:
  - sprint-init.md
  - sprint-vision-review.md
project_scope: meta
last_used: null
---

# Workflow: Sprint Review

## Purpose

Close a completed sprint. Measures velocity, captures retrospective, closes the sprint record, and triggers the vision review.

## When to Use

- At the end of a sprint period
- Before starting the next sprint

---

## Step 1: Gather Sprint Data

```sql
SELECT
  c.card_id,
  c.title,
  c.lane,
  c.priority,
  p.name as project
FROM nexus_cards c
JOIN nexus_projects p ON c.project_id = p.id
WHERE c.sprint_id = (SELECT id FROM nexus_sprints WHERE status = 'active' LIMIT 1)
ORDER BY c.lane, c.priority;
```

---

## Step 2: Calculate Velocity

Count:
- Cards planned (total in sprint at start)
- Cards completed (in `done` lane)
- Cards carried over (still in `in_progress` or `review`)

```
Velocity = completed / planned * 100%
```

---

## Step 3: Retrospective

Answer honestly:

**What went well?**
{List 2-3 things that worked}

**What didn't go well?**
{List 2-3 things that caused friction}

**What would we change?**
{1-2 concrete changes for next sprint}

---

## Step 4: Handle Carried-Over Cards

For each card not completed:
- Keep in current sprint and carry over, OR
- Return to `ready` for next sprint

```sql
-- Return to ready lane
UPDATE nexus_cards SET lane = 'ready', sprint_id = NULL
WHERE card_id = '{CARD-ID}';
```

---

## Step 5: Close Sprint

```sql
UPDATE nexus_sprints
SET status = 'completed',
    completed_at = NOW(),
    velocity = {percentage}
WHERE status = 'active';
```

---

## Step 6: Trigger Vision Review

Immediately after closing the sprint, run `sprint-vision-review.md`. This is not optional — it runs at every sprint close.

```
Next: → sprint-vision-review.md
```

---

## Step 7: Update Direction File

After the vision review completes, update `identity/council/direction.md` § Last Sprint's Vision Alignment with the verdict.

---

## Related

- **Sprint initialization**: `workflows/public/sprint-init.md`
- **Sprint vision review**: `workflows/public/sprint-vision-review.md`
- **Direction file**: `identity/council/direction.md`

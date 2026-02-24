---
type: workflow
trigger: manual
status: active
created: 2026-02-10
updated: 2026-02-18
category: planning
playbook_phase: null
related_workflows:
  - sprint-review.md
  - sprint-vision-review.md
project_scope: meta
last_used: null
---

# Workflow: Sprint Initialization

## Purpose

Start a new sprint. Creates the sprint record, selects cards from the backlog, sets the sprint goal, and configures capacity.

## When to Use

- After the previous sprint closes (triggered from `sprint-review.md`)
- When starting the very first sprint

---

## Step 1: Review Previous Sprint (if applicable)

If a sprint just closed:
- Review the retrospective from `sprint-review.md`
- Note velocity from last sprint (cards completed / planned)
- Check for any cards that carried over

---

## Step 2: Set Sprint Goal

The sprint goal is a single sentence describing what the sprint accomplishes. It should be:
- Directional, not just operational
- Meaningful — what does success look like?
- Achievable in one sprint

```sql
INSERT INTO nexus_sprints (name, goal, start_date, end_date, status)
VALUES (
  '{Sprint Name}',
  '{Sprint goal — one sentence}',
  '{start date}',
  '{end date}',
  'active'
);
```

---

## Step 3: Select Sprint Cards

Pull cards from `ready` lane that fit the sprint:

```sql
SELECT c.card_id, c.title, c.priority, p.name as project
FROM nexus_cards c
JOIN nexus_projects p ON c.project_id = p.id
WHERE c.lane = 'ready'
ORDER BY c.priority DESC, c.created_at ASC;
```

Select cards based on:
- Priority (high → medium → low)
- Dependencies (don't pull a card before its dependency)
- Capacity (don't overload — use last sprint's velocity as a guide)
- Alignment with sprint goal

---

## Step 4: Assign Cards to Sprint

```sql
UPDATE nexus_cards
SET sprint_id = (SELECT id FROM nexus_sprints WHERE status = 'active' LIMIT 1),
    lane = 'in_progress'
WHERE card_id IN ('{CARD-ID-1}', '{CARD-ID-2}', ...);
```

---

## Step 5: Assign Bender Tasks

For cards that will go to benders, create `bender_tasks` entries:

```sql
INSERT INTO bender_tasks (card_id, member, status, description)
VALUES (
  (SELECT id FROM nexus_cards WHERE card_id = '{CARD-ID}'),
  '{bender-name}',
  'queued',
  '{task brief}'
);
```

---

## Step 6: Confirm Sprint Plan

Present the sprint plan to {{user.name}}:

```
## Sprint: {name}

**Goal**: {goal}
**Start**: {date} — **End**: {date}

**Cards ({N} total)**:
| Card | Title | Priority | Owner |
|------|-------|----------|-------|
| {CARD-ID} | {title} | high | {{cos.name}} |
| {CARD-ID} | {title} | medium | {bender} |

Confirm sprint plan?
```

---

## Related

- **Sprint review**: `workflows/public/sprint-review.md`
- **Sprint vision review**: `workflows/public/sprint-vision-review.md`
- **Bender assign**: `workflows/public/bender-assign.md`

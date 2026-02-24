---
type: workflow
trigger: manual
status: active
created: 2026-02-10
updated: 2026-02-18
category: infrastructure
playbook_phase: "1.3"
related_workflows:
  - data-layer-setup.md
  - system-bootstrap.md
project_scope: all
last_used: null
---

# Workflow: Kanban Setup

## Purpose

Bootstrap the NEXUS kanban system. Creates the initial set of projects and seeds the kanban with a skeleton of active work areas. Runs after `data-layer-setup.md`.

## Prerequisites

- [ ] Data layer setup complete
- [ ] Supabase connection verified
- [ ] {{user.name}} has identified initial projects

---

## Step 1: Create Projects

For each active work area, create a NEXUS project:

```sql
INSERT INTO nexus_projects (name, slug, description, status)
VALUES
  ('{Project Name}', '{slug}', '{description}', 'active');
```

### Standard projects for a new workspace

| Project | Slug | Description |
|---------|------|-------------|
| Meta | `meta` | Governance, system work, infrastructure |
| Council | `council` | Strategic planning and governance sessions |
| {{{user.name}}'s primary project} | `{slug}` | {description} |

Add domain-specific projects based on {{user.name}}'s active areas.

---

## Step 2: Create Initial Cards

Seed each project with the first cards. At minimum, create cards for the remaining setup steps:

```sql
INSERT INTO nexus_cards (project_id, title, description, lane, priority)
VALUES (
  (SELECT id FROM nexus_projects WHERE slug = 'meta'),
  'Complete workspace setup',
  'Finish remaining setup steps per system-playbook.md',
  'in_progress',
  'high'
);
```

---

## Step 3: Configure Lane Vocabulary

The default lane vocabulary:

```
backlog → ready → in_progress → review → done
```

Optional lanes (for specific project types):
- `ideas` — unvetted backlog
- `drafts` — content in progress
- `published` — shipped/published content

Lanes are enforced by the `validate_lane_transition` DB trigger — no skipping.

---

## Step 4: Verify Board

Run a query to verify the board is populated:

```sql
SELECT
  p.name as project,
  c.lane,
  count(*) as card_count
FROM nexus_cards c
JOIN nexus_projects p ON c.project_id = p.id
GROUP BY p.name, c.lane
ORDER BY p.name, c.lane;
```

---

## Step 5: Set Up Project Prefixes

Each project gets a card ID prefix. The prefix is stored in `nexus_projects.card_prefix`:

```sql
UPDATE nexus_projects SET card_prefix = 'META' WHERE slug = 'meta';
UPDATE nexus_projects SET card_prefix = 'COUNCIL' WHERE slug = 'council';
-- Update for each project
```

Cards created after this will get IDs like `META-001`, `META-002`, etc.

---

## Related

- **Data layer**: `workflows/public/data-layer-setup.md`
- **System bootstrap**: `workflows/public/system-bootstrap.md`
- **Transition card**: `workflows/public/transition-card.md`

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
  - kanban-setup.md
project_scope: meta
last_used: null
---

# Workflow: Task Batch Load

## Purpose

Load a batch of cards into NEXUS at once — useful for sprint planning from a pre-prepared list, importing backlog from an external source, or seeding a new project with initial cards.

## When to Use

- Sprint planning with a pre-defined card list
- Importing work from an external planning tool
- Bulk backlog seeding for a new project

---

## Step 1: Prepare the Batch

Prepare the card data as a structured list. Required fields per card:

| Field | Required | Notes |
|-------|----------|-------|
| `title` | Yes | Concise, imperative |
| `description` | Recommended | PSU format (Problem → Solution → Unknowns) |
| `project_id` | Yes | Must reference existing project |
| `lane` | Yes | Usually `backlog` or `ready` |
| `priority` | Yes | `high` / `medium` / `low` |

---

## Step 2: Validate Project IDs

Before inserting, confirm target projects exist:

```sql
SELECT id, name, slug FROM nexus_projects WHERE status = 'active';
```

---

## Step 3: Insert Cards

Batch insert:

```sql
INSERT INTO nexus_cards (project_id, title, description, lane, priority)
VALUES
  ((SELECT id FROM nexus_projects WHERE slug = '{project-slug}'), '{title}', '{description}', 'backlog', 'medium'),
  ((SELECT id FROM nexus_projects WHERE slug = '{project-slug}'), '{title}', '{description}', 'ready', 'high'),
  -- ... repeat for each card
;
```

---

## Step 4: Verify

After insert, confirm cards appear with correct IDs:

```sql
SELECT card_id, title, lane, priority
FROM nexus_cards
WHERE created_at > NOW() - INTERVAL '5 minutes'
ORDER BY card_id;
```

---

## Step 5: Assign to Sprint (if applicable)

If cards are being loaded directly into a sprint:

```sql
UPDATE nexus_cards
SET sprint_id = (SELECT id FROM nexus_sprints WHERE status = 'active' LIMIT 1)
WHERE card_id IN ('{CARD-ID-1}', '{CARD-ID-2}', ...);
```

---

## Card Naming Conventions

- Use imperative mood: "Add X", "Fix Y", "Remove Z"
- Be specific: "Add email domain validation to signup form" not "Fix email"
- No abbreviations that require domain knowledge
- Max 80 characters

---

## Related

- **Sprint initialization**: `workflows/public/sprint-init.md`
- **Kanban setup**: `workflows/public/kanban-setup.md`
- **Transition card**: `workflows/public/transition-card.md`

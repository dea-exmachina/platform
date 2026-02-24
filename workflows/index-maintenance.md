---
type: workflow
trigger: manual
status: active
created: 2026-02-10
updated: 2026-02-18
category: meta
playbook_phase: null
related_workflows: []
project_scope: meta
last_used: null
---

# Workflow: Index Maintenance

## Purpose

Keep INDEX files current. Index files are navigational — they exist to help {{cos.name}} and benders find the right resource quickly. Stale indexes are worse than no index.

## When to Run

- After adding new workflows, templates, or frameworks
- After renaming or moving files
- Quarterly as part of governance review
- When a bender or {{cos.name}} can't find something that should be findable

---

## Index Files in This System

| File | What It Indexes | Update When |
|------|----------------|-------------|
| `workflows/INDEX.md` | All workflows | Any workflow added/moved/retired |
| `templates/INDEX.md` | All templates | Any template added/moved/retired |
| `frameworks/INDEX.md` | All frameworks | Any framework added/moved/retired |
| `INDEX.md` (root) | Top-level navigation | Any major structural change |

---

## Update Process

### Step 1: Scan for changes

```bash
# List all workflows
ls workflows/public/*.md

# List all templates
ls templates/public/*.md

# List all frameworks
ls frameworks/*.md
```

### Step 2: Compare against current index

Open the relevant INDEX.md and compare against the directory listing. Find:
- Files present on disk but missing from index
- Files in index that no longer exist on disk
- Files with outdated descriptions or statuses

### Step 3: Update the index

For each discrepancy:
- **New file**: Add entry with description and trigger/usage note
- **Removed file**: Remove entry or mark as `[retired]`
- **Renamed file**: Update the path and note the rename
- **Status change** (e.g., workflow now deprecated): Update status field

### Step 4: Verify links

Spot-check 3-5 links in each index to confirm they resolve.

---

## Index Entry Format

```markdown
| `{filename}.md` | {brief description} | {trigger or usage note} |
```

Descriptions should be:
- One line, max 80 characters
- Present tense ("Handles X", "Runs when Y")
- Specific enough to distinguish from similar entries

---

## Anti-Patterns

- **Mega-descriptions**: Index entries that try to document the workflow. The index is a pointer, not the doc.
- **Missing status**: Deprecated workflows left as if active.
- **Alphabetical chaos**: Entries not grouped by category, making scanning hard.
- **Stale trigger notes**: Trigger commands that have changed (e.g., skill renamed).

---

## Related

- `workflows/INDEX.md`
- `templates/INDEX.md`
- `frameworks/INDEX.md`

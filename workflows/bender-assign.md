---
type: workflow
trigger: /{{cos.name}}-bender-assign
status: active
created: 2026-02-05
updated: 2026-02-18
category: bender
playbook_phase: "2.2"
related_workflows:
  - bender-review.md
  - bender-context-update.md
related_templates:
  - bender-task.md
project_scope: all
last_used: null
---

# Workflow: Bender Task Assignment

> Explicit workflow — follow steps in order.

## Purpose

Assign a well-scoped, self-contained task to a named bender. This workflow ensures every task dispatched has full context, clear acceptance criteria, and a traceable card link.

## When to Use

- Anytime a unit of work can be delegated to a bender
- Triggered from sprint planning, card triage, or inline during work
- Invoked via `/{{cos.name}}-bender-assign` skill

---

## Pre-flight: Is This Task Bender-Ready?

Before assigning, confirm:

- [ ] Task is self-contained — one deliverable, clear scope
- [ ] Acceptance criteria are written (not implied)
- [ ] Required context files exist and are identified
- [ ] A NEXUS card exists for this work (or create one now)
- [ ] The right bender is identified for this task type

**Not bender-ready?** Either sharpen the spec or keep it for {{cos.name}}.

---

## Step 1: Write the Task Brief

The task brief is the single source of truth the bender executes against. It must be unambiguous.

```markdown
## Task Brief: {CARD-ID} — {title}

**Bender**: {name}
**Delivery mode**: git | file | inline
**Branch**: task/{CARD-ID} (if git delivery)

### Context
{What does the bender need to know to execute this faithfully?}

### Acceptance Criteria
- [ ] {Specific, testable criterion}
- [ ] {Specific, testable criterion}
- [ ] {Specific, testable criterion}

### File Scope
{Which files are in scope? What is off-limits?}

### Definition of Done
{How will {{cos.name}} know this is complete?}
```

---

## Step 2: Package Context

Every bender gets:

1. **Shared context** (always loaded):
   - `benders/context/shared/standards.md`
   - `benders/context/shared/policies.md`
   - `benders/context/shared/git-workflow.md`

2. **Role context** (task-type specific):
   - `benders/context/task-types/{type}.md`

3. **Task-specific context** (as needed):
   - Architecture docs, existing code, prior decisions
   - Any wisdom docs relevant to this domain

List all context in the dispatch message so the bender knows what's loaded.

---

## Step 3: Dispatch

### Native agent dispatch (preferred)

```
@{bender-name}: {task brief}

Context loaded:
- benders/context/shared/standards.md
- benders/context/shared/git-workflow.md
- benders/context/task-types/{type}.md
- {any additional files}
```

### Task tool dispatch (for parallel execution)

```python
Task(
    description="{task brief}",
    prompt=f"""
    {full task brief with context}
    """
)
```

---

## Step 4: Update Kanban

After dispatch:

```sql
UPDATE nexus_cards
SET bender_lane = 'executing'
WHERE card_id = '{CARD-ID}';
```

---

## Step 5: Wait for Delivery

Bender delivers via the agreed mode:
- **git**: Branch committed, PR or delivery note written
- **file**: File written to agreed location, delivery message sent
- **inline**: Output in the conversation

On delivery, run `/{{cos.name}}-bender-review`.

---

## Delivery Modes

| Mode | When to Use | Bender Action |
|------|-------------|---------------|
| `git` | Code, structured files, anything version-controlled | Branch, commit, mark delivered |
| `file` | Docs, configs, content that lives in the vault | Write file, message {{cos.name}} |
| `inline` | Research summaries, analysis, short text | Deliver in conversation |

---

## PRE-FLIGHT Gate (bender responsibility)

Before executing, benders must confirm:

```
PRE-FLIGHT:
- Task is clear and unambiguous: YES / NO
- Context is sufficient: YES / NO
- Acceptance criteria are testable: YES / NO
- File scope is understood: YES / NO
- Questions: {list or NONE}
```

If any item is NO, bender sends questions to {{cos.name}} before proceeding.

---

## LEARNING Gate (bender responsibility)

At delivery, bender emits a signal:

```
LEARNING:
- Signal UUID: {from learning_signals insert}
- Domain: {domain enum}
- Recommendation: {one thing for the next agent}
```

Signal emission is required before marking the task delivered.

---

## Related

- **Review workflow**: `workflows/public/bender-review.md`
- **Context update**: `workflows/public/bender-context-update.md`
- **Signal emission**: `workflows/public/signal-emit.md`
- **Transition card**: `workflows/public/transition-card.md`

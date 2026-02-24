---
type: workflow
trigger: manual
status: active
created: 2026-02-10
updated: 2026-02-18
category: bender
playbook_phase: null
related_workflows:
  - bender-assign.md
project_scope: all
last_used: null
---

# Workflow: Context Package Build

## Purpose

Assemble the context package for a bender task. The context package is everything the bender needs — no more, no less — to execute faithfully without asking clarifying questions.

## Principles

- **Lean over comprehensive**: A 3-file context that's all relevant beats a 15-file context with 5 distractors.
- **Explicit over assumed**: Don't assume the bender knows something. If it matters, include it.
- **Fresh over cached**: Always pull current file state, not what you remember it says.

---

## Layer 1: Shared Context (always included)

These load for every bender task:

```
benders/context/shared/standards.md
benders/context/shared/policies.md
benders/context/shared/git-workflow.md
benders/context/shared/decision-authority.md
```

---

## Layer 2: Role Context (task-type specific)

Match the task type to its context file:

| Task Type | Context File |
|-----------|-------------|
| Implementation | `benders/context/task-types/implementation.md` |
| Research | `benders/context/task-types/research.md` |
| Review | `benders/context/task-types/review.md` |
| Writing | `benders/context/task-types/writing.md` |
| Data/Analysis | `benders/context/task-types/analysis.md` |

---

## Layer 3: Task-Specific Context

Pull only what's needed for this task:

- Relevant architecture docs
- Existing code that will be modified
- Prior decisions (from decision-log or card comments)
- Wisdom docs for the specific domain
- PRE-TASK INTELLIGENCE briefing (from hot path, if available)

---

## Context Package Format

```markdown
## Context Package: {CARD-ID}

### Shared Context (loaded)
- standards.md
- policies.md
- git-workflow.md

### Role Context
- task-types/{type}.md

### Task-Specific Context
- {file}: {why it's relevant}
- {file}: {why it's relevant}

### PRE-TASK INTELLIGENCE
{Briefing from learning_signals hot path, if any}

### What is NOT in scope
{Files or systems the bender should NOT touch}
```

---

## Quality Check

Before finalizing the package:

- [ ] Does this context let the bender answer all acceptance criteria questions?
- [ ] Is anything included that isn't needed? (remove it)
- [ ] Is there a PRE-TASK INTELLIGENCE briefing available to include?
- [ ] Are file paths current (not from memory)?

---

## Related

- **Bender assign**: `workflows/public/bender-assign.md`
- **Signal emission** (hot path source): `workflows/public/signal-emit.md`

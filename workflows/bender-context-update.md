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
  - bender-review.md
project_scope: all
last_used: null
---

# Workflow: Bender Context Update

## Purpose

Update bender context files — shared standards, role-specific knowledge, and identity files — based on accumulated learnings, changing patterns, or explicit feedback from reviews.

## When to Use

- After a bender review surfaces a recurring issue
- When a pattern appears in multiple learning signals
- When shared standards evolve and must propagate to bender context
- When a new bender joins and context is being built

---

## Context File Map

| File | Scope | Owner |
|------|-------|-------|
| `benders/context/shared/standards.md` | All benders | {{cos.name}} |
| `benders/context/shared/policies.md` | All benders | {{cos.name}} |
| `benders/context/shared/git-workflow.md` | All benders | {{cos.name}} |
| `benders/context/shared/decision-authority.md` | All benders | {{cos.name}} |
| `benders/context/shared/patterns.md` | All benders | {{cos.name}} |
| `benders/context/task-types/{type}.md` | Role-specific | {{cos.name}} |
| `identity/{name}/learnings.md` | Bender-specific | {{cos.name}} |
| `identity/{name}/{team}/knowledge.md` | Project-specific | {{cos.name}} |

---

## Update Process

### 1. Identify the trigger

What prompted this update?
- Learning signal with `context_missing` filled
- Repeated friction across multiple signals
- Review finding that points to a context gap
- Explicit user directive

### 2. Locate the right file

Match the update to the scope:
- Applies to all benders → `shared/`
- Applies to a task type → `task-types/{type}.md`
- Applies to one bender → `identity/{name}/`
- Applies to one project → `identity/{name}/{team}/knowledge.md`

### 3. Write the update

Be precise. Don't append noise. The update should be:
- Specific to the observed pattern
- Actionable — something the bender can do differently
- Referenced to the source (learning signal, card ID)

### 4. Verify downstream

After updating shared context, check:
- Does any existing task brief conflict with the new context?
- Does any active bender need to be re-briefed?
- Should the change also update a wisdom doc?

---

## Shared Context Quality Bar

Shared context files must stay lean. Before adding:
- Is this used in 3+ task types?
- Is it stable enough to persist across tasks?
- Would its absence cause repeatable friction?

If NO to any: write it to a task-specific context file instead.

---

## Related

- **Signal emission**: `workflows/public/signal-emit.md`
- **Bender review**: `workflows/public/bender-review.md`
- **Bender assign**: `workflows/public/bender-assign.md`

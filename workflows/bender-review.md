---
type: workflow
trigger: /{{cos.name}}-bender-review
status: active
created: 2026-02-05
updated: 2026-02-18
category: bender
playbook_phase: null
related_workflows:
  - bender-assign.md
  - bender-context-update.md
project_scope: all
last_used: null
---

# Workflow: Bender Review

> Explicit workflow — follow steps in order.

## Purpose

Review bender deliverables before they reach the user. {{cos.name}} is the quality gate. Nothing ships to {{user.name}} without passing this review.

## When to Use

- Every time a bender marks a task delivered
- Invoked via `/{{cos.name}}-bender-review`

---

## Step 1: Load the Deliverable

- Read the delivered files, inline output, or diff
- Load the original task brief (acceptance criteria)
- Load the card for context

---

## Step 2: Acceptance Criteria Check

For each criterion in the task brief:

| Criterion | Met? | Notes |
|-----------|------|-------|
| {criterion 1} | YES / NO / PARTIAL | {evidence} |
| {criterion 2} | YES / NO / PARTIAL | {evidence} |

**All criteria must be met.** PARTIAL requires explanation.

---

## Step 3: Quality Check

Beyond acceptance criteria:

- [ ] **Correctness** — does it do what it says?
- [ ] **Scope discipline** — did the bender stay within file boundaries?
- [ ] **Standards compliance** — follows shared standards (naming, structure, style)
- [ ] **No regressions** — existing functionality not broken
- [ ] **Commit quality** — message follows convention, branch correct

For code deliverables:
- [ ] Compiles / type-checks
- [ ] Lint passes
- [ ] No console errors or obvious runtime issues
- [ ] Tests pass (if applicable)

---

## Step 4: Verdict

### APPROVED

Deliverable meets all criteria. No blocking issues.

```
Review: Approved

Assessment: {1-2 sentences — what was delivered and why it passes}
Next step: merge / mark done / present to {{user.name}}
```

Update kanban:
```sql
UPDATE nexus_cards SET bender_lane = 'delivered' WHERE card_id = '{CARD-ID}';
```

### NEEDS WORK

Deliverable has issues that must be fixed before approval.

```
Review: Needs work

Issues found:
- BLOCKER: {specific issue} — {what must change}
- MAJOR: {specific issue} — {what should change}
- MINOR: {specific issue} — {nice to fix}

Next step: Re-assign to bender with this feedback
```

### REJECTED

Deliverable fundamentally misses the spec. Not worth iterating — restart with a clearer brief.

```
Review: Rejected

Assessment: {why this doesn't work}
Root cause: {brief confusion / wrong approach / out of scope}
Next step: Rewrite task brief — send back as new assignment
```

---

## Step 5: Verify Learning Signal

Before closing the review, confirm the bender emitted a learning signal. If not, request it.

```
LEARNING gate: Signal UUID {present / missing}
If missing: Ask bender to emit before marking complete
```

---

## Scoring (optional, for tracking)

Rate the delivery 1-5 on:
- **Accuracy**: Did it match the brief?
- **Quality**: Code/content quality independent of spec compliance
- **Efficiency**: Was the scope respected? No unnecessary additions?

Record in `bender_tasks.review_score` if tracking bender performance.

---

## Related

- **Assign workflow**: `workflows/public/bender-assign.md`
- **Context update**: `workflows/public/bender-context-update.md`
- **Transition card**: `workflows/public/transition-card.md`
- **Signal emission**: `workflows/public/signal-emit.md`

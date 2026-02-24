---
type: workflow
trigger: /{{cos.name}}-interview
status: active
created: 2026-02-10
updated: 2026-02-18
category: planning
playbook_phase: null
related_workflows:
  - bender-assign.md
project_scope: all
last_used: null
---

# Workflow: Task Interview (Spec Writing)

> Deep-dive interview for a task before implementation begins.

## Purpose

Before a complex task is assigned to a bender (or executed by {{cos.name}}), run a structured interview to surface requirements, edge cases, constraints, and unknowns. The output is a spec that becomes the task brief.

## When to Use

- Before assigning a technically complex bender task
- When {{user.name}} says "I need X" but X has multiple valid interpretations
- When the acceptance criteria aren't yet clear
- Triggered via `/{{cos.name}}-interview`

---

## Phase 1: Problem Framing

Ask:
1. What problem does this solve? (user-facing, not technical)
2. Who experiences this problem? In what context?
3. What happens today without this feature/fix?
4. What does success look like — how will you know it worked?

---

## Phase 2: Scope Exploration

Ask:
1. What's the minimum viable version of this?
2. What would a full version include that the minimum doesn't?
3. What's explicitly out of scope for this task?
4. Are there dependencies — things that must exist before this can be built?

---

## Phase 3: Technical Constraints

Ask:
1. Does this touch the database? If so, which tables?
2. Does this require UI changes? API changes? Both?
3. Are there performance constraints (latency, throughput)?
4. Are there security constraints (auth, RLS, data visibility)?
5. What existing code will this touch or interact with?

---

## Phase 4: Edge Cases and Risks

Ask:
1. What can go wrong? List the top 3 failure modes.
2. What's the worst-case input? How should it be handled?
3. Is there any state or timing dependency that could cause issues?
4. What assumptions am I making that might be wrong?

---

## Phase 5: Unknowns

Ask:
1. What do you not know yet that you need to know before implementing?
2. Is there prior art — a similar feature already in the codebase?
3. Are there external constraints (API limits, third-party requirements) that apply?

---

## Output: Spec Document

After the interview, write the spec:

```markdown
# Spec: {title}

**Card**: {CARD-ID}
**Date**: {date}

## Problem
{What problem this solves — in user terms}

## Solution
{What will be built — at the level of detail needed for implementation}

## Acceptance Criteria
- [ ] {specific, testable criterion}
- [ ] {specific, testable criterion}

## Out of Scope
{What is explicitly not included in this implementation}

## Technical Notes
{DB tables affected, API contracts, dependencies, constraints}

## Edge Cases
{How specific edge cases should be handled}

## Unknowns
{Open questions to resolve before or during implementation}

## Definition of Done
{How {{cos.name}} will verify this is complete and correct}
```

---

## After the Spec

Review the spec with {{user.name}} if it involves significant scope or cost. Then use it as the task brief for bender assignment (`bender-assign.md`).

---

## Related

- **Bender assign**: `workflows/public/bender-assign.md`
- **Bender review**: `workflows/public/bender-review.md`

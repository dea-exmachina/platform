---
type: workflow
trigger: /{{cos.name}}-plan-review
status: active
created: 2026-02-10
updated: 2026-02-18
category: governance
playbook_phase: null
related_workflows:
  - council.md
  - council-review.md
project_scope: meta
last_used: null
---

# Workflow: Plan Review Gate

> Mandatory critical review before execution. Prevents self-certification.

## Purpose

Before any significant plan is executed, it passes through a multi-lens review. Each governance construct examines the plan from their domain. The result is a verdict: PASS, CONDITIONAL PASS, or FAIL.

## When to Use

- Before executing a multi-step plan (any plan with 3+ significant actions)
- Before committing to an architectural decision
- Before starting a new bender team or major sprint
- When {{user.name}} asks for a second opinion on a plan

---

## Review Lenses

### Supreme Authority
**Question**: Does this plan move toward the Guiding Star?
- Is the objective directionally sound?
- Does it address the right problem?
- Is the scope appropriate to the goal?

### Team Construction
**Question**: Is the team and capacity to execute this plan correct?
- Does the plan require benders? Are the right ones available?
- Are roles and responsibilities clear?
- Is the delivery chain defined?

### Quality Standards
**Question**: Will this plan produce work that meets quality standards?
- Are acceptance criteria defined and testable?
- Is there a review gate built in?
- Are there obvious quality risks?

### Data Custodianship
**Question**: Does this plan handle data correctly?
- Are schema changes needed? Are they planned?
- Are RLS implications understood?
- Is the data flow documented?

### External Orchestration
**Question**: Are external dependencies managed?
- Are external services involved? Are they stable?
- Are credentials available and current?
- Are there integration risks?

---

## Verdict Format

```markdown
## Plan Review — {plan name} — {date}

### Supreme Authority
**Finding**: {finding}
**Verdict**: PASS | FLAG | BLOCK

### Team Construction
**Finding**: {finding}
**Verdict**: PASS | FLAG | BLOCK

### Quality Standards
**Finding**: {finding}
**Verdict**: PASS | FLAG | BLOCK

### Data Custodianship
**Finding**: {finding}
**Verdict**: PASS | FLAG | BLOCK

### External Orchestration
**Finding**: {finding}
**Verdict**: PASS | FLAG | BLOCK

---

## Overall Verdict

**PASS** — No BLOCKs, no unresolved FLAGs. Execute as planned.

**CONDITIONAL PASS** — One or more FLAGs. Execute with the following modifications:
- {flag + resolution}

**FAIL** — One or more BLOCKs. Do not execute until resolved:
- {block + what must change}
```

---

## Verdict Definitions

| Verdict | Meaning | Action |
|---------|---------|--------|
| **PASS** | No issues in this domain | Proceed |
| **FLAG** | Issue noted but not blocking | Note + resolve in execution |
| **BLOCK** | Issue is blocking — plan cannot proceed as written | Revise plan first |

---

## After Review

- **PASS**: Execute the plan
- **CONDITIONAL PASS**: Execute with modifications documented in the review
- **FAIL**: Revise the plan, re-run the review before proceeding

Do not execute a FAIL verdict without revision, even under time pressure.

---

## Related

- **Council sessions**: `workflows/public/council.md`
- **Council diagnostics**: `workflows/public/council-review.md`

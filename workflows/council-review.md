---
type: workflow
trigger: /{{cos.name}}-council
status: active
created: 2026-02-10
updated: 2026-02-18
category: governance
playbook_phase: null
related_workflows:
  - council.md
  - plan-review.md
project_scope: meta
last_used: null
---

# Workflow: Council Review (Governance Diagnostic)

> Periodic governance diagnostic — each construct examines their domain for entropy. Distinct from the strategic planning session (`council.md`).

## Purpose

Identify where the system has accumulated technical debt, process drift, or governance gaps. Run quarterly or when the system feels like it's fighting itself.

## Council Constructs

The council represents five governance domains. Each examines their domain independently, then the Supreme Authority synthesizes.

| Role | Domain | Examines |
|------|--------|----------|
| **Supreme Authority** | Direction & synthesis | Is the system aimed at the right things? |
| **Team Construction** | Bender architecture | Are benders correctly structured, scoped, and utilized? |
| **Quality Standards** | Execution quality | Are standards being met? Where is quality drifting? |
| **Data Custodianship** | Data integrity | Is the data layer clean, governed, and trustworthy? |
| **External Orchestration** | External dependencies | Are external systems, integrations, and pipelines healthy? |

---

## Diagnostic Questions by Domain

### Supreme Authority
- Is the current work moving toward the Guiding Star?
- Are open tensions being addressed or accumulating?
- Is the governance structure itself working, or creating friction?

### Team Construction
- Are benders correctly specialized for current task types?
- Is there duplication or gap in bender role coverage?
- Are context files current and accurate?
- Is the dispatch process creating friction?

### Quality Standards
- Are learning signals being emitted consistently?
- Are bender reviews catching issues before they reach {{user.name}}?
- Is the PRE-FLIGHT gate being respected?
- Are acceptance criteria being written clearly?

### Data Custodianship
- Are schema migrations documented and applied cleanly?
- Are RLS policies current and correctly scoped?
- Is the learning_signals table accumulating quality data?
- Are any tables missing indexes or constraints?

### External Orchestration
- Are external integrations (email, Discord, APIs) functioning?
- Are monitoring and alerting setups current?
- Are credentials up to date and securely stored?
- Are any pipelines broken or stale?

---

## Review Format

Each construct produces a domain report:

```markdown
## {Domain} Review — {Date}

**Status**: GREEN | YELLOW | RED

### Findings
- {finding}: {severity} — {evidence}
- {finding}: {severity} — {evidence}

### Recommended Actions
- [ ] {action} — {priority: now / next sprint / backlog}
```

---

## Synthesis (Supreme Authority)

After all domain reports:

```markdown
## Council Synthesis — {Date}

**System health**: GREEN | YELLOW | RED

### Priority Actions
1. {highest priority finding + action}
2. {second priority}
3. {third priority}

### Verdict
{One paragraph — honest assessment of system health and what needs to happen}
```

---

## Output

- Domain reports written to `identity/council/diagnostics/{date}.md`
- Priority actions converted to NEXUS cards
- Synthesis shared with {{user.name}} for awareness (not necessarily for action — {{cos.name}} handles most items)

---

## Frequency

| Trigger | Frequency |
|---------|-----------|
| Routine | Quarterly |
| After major system changes | Within 1 week |
| When something feels broken | Immediately |
| After sprint close | Optional (lighter version) |

---

## Related

- **Strategic planning**: `workflows/public/council.md`
- **Plan review gate**: `workflows/public/plan-review.md`
- **Signal emission**: `workflows/public/signal-emit.md`

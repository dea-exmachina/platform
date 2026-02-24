---
type: workflow
trigger: manual
status: active
created: 2026-02-12
updated: 2026-02-18
category: governance
playbook_phase: null
related_workflows:
  - council.md
  - plan-review.md
project_scope: meta
last_used: null
---

# Workflow: Decision Log

## Purpose

Record significant decisions in a persistent, queryable log. Decisions that are hard to reverse, affect multiple systems, or represent strategic pivots belong here. The log prevents "why did we do this?" archaeology later.

## When to Log

**Always log**:
- Architecture decisions (schema, stack, patterns)
- Strategic pivots (changing direction on a project or bet)
- Governance decisions (new policies, workflow changes)
- Rejected alternatives (especially when they seem obvious)

**Skip logging**:
- Routine implementation choices (which variable name, which loop)
- Decisions reversed within the same session
- Anything already captured in a card comment with full context

---

## Decision Record Format

```markdown
## Decision: {short title}

**Date**: {YYYY-MM-DD}
**Author**: {{cos.name}} | council | {{user.name}}
**Card**: {CARD-ID or null}
**Status**: active | superseded | reversed

### Context
{What situation prompted this decision? What constraints existed?}

### Options Considered
1. {option A} — {why considered, why not chosen}
2. {option B} — {why considered, why not chosen}
3. **{chosen option}** — {why chosen}

### Decision
{The decision, stated clearly and directly.}

### Rationale
{Why this option over the alternatives? What evidence or reasoning?}

### Consequences
{What does this decision enable? What does it foreclose? What must change?}

### Review Trigger
{Under what conditions should this decision be revisited?}
```

---

## Storage Location

Decisions live in `identity/council/decision-log.md` (append-only, newest first).

For major architectural decisions, also create a dedicated ADR (Architecture Decision Record) in `docs/decisions/`:

```
docs/decisions/
  ADR-001-database-choice.md
  ADR-002-auth-strategy.md
  ADR-003-bender-delivery-modes.md
```

---

## Updating Existing Decisions

Decision records are append-only. To update:

1. Change `status` to `superseded`
2. Add `superseded_by: ADR-XXX` or reference
3. Write a new decision record explaining the change

Never edit the body of an existing decision record.

---

## Querying the Log

Before making a decision in a domain, search the log:

```bash
grep -i "{topic}" identity/council/decision-log.md
```

If a prior decision exists on the topic, either:
- Reuse it (confirm it's still valid)
- Supersede it (write a new record referencing the old one)

---

## Related

- **Council sessions**: `workflows/public/council.md`
- **Plan review gate**: `workflows/public/plan-review.md`
- **Decision log location**: `identity/council/decision-log.md`

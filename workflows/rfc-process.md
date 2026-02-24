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
  - decision-log.md
  - plan-review.md
project_scope: meta
last_used: null
---

# Workflow: RFC Process (Request for Comments)

## Purpose

Formal process for proposing significant changes to the system — architecture, governance, meta-framework, or any decision with long-lived consequences. RFCs create a structured record of the proposal, the discussion, and the final decision.

## When to Use

- Proposing a new architectural pattern
- Proposing a governance change (new policy, workflow modification)
- Proposing a meta-framework change (CLAUDE.md, identity structure)
- Any decision that will be hard to reverse and affects multiple systems

---

## RFC Lifecycle

```
Draft → Review → Decision → Implemented | Rejected
```

---

## Step 1: Write the RFC

Create `docs/rfcs/{CARD-ID}-{slug}.md`:

```markdown
---
rfc_id: RFC-{sequence}
card: {CARD-ID}
status: draft | review | decided
decision: accepted | rejected | superseded
created: {date}
decided: {date or null}
---

# RFC-{sequence}: {Title}

## Summary
{One paragraph — what this RFC proposes and why.}

## Motivation
{Why is this needed? What problem does it solve? What happens if we don't do this?}

## Proposal
{Detailed description of what is proposed. Be specific.}

## Alternatives Considered
{What other approaches were considered? Why were they rejected?}

## Consequences
{What changes if this is accepted? What becomes harder? What becomes possible?}

## Open Questions
{Questions that need answering before this can be decided.}

## Decision
{Filled in after council/{{user.name}} decides.}

**Outcome**: accepted | rejected
**Rationale**: {why this decision was made}
**Decided by**: {{cos.name}} | council | {{user.name}}
```

---

## Step 2: Review

For meta-framework or architectural RFCs, run through plan-review.md lenses. For simpler changes, {{cos.name}} reviews independently.

Present to {{user.name}} if the RFC has significant impact on their experience or workflow.

---

## Step 3: Decide

After review, record the decision in the RFC and in `identity/council/decision-log.md`.

Update card to `done` if accepted. If rejected, document why for future reference.

---

## Step 4: Implement (if accepted)

Create implementation cards for the accepted RFC. Link them to the RFC card.

---

## RFC Numbering

RFCs are numbered sequentially: RFC-001, RFC-002, etc. Track the sequence in `docs/rfcs/INDEX.md`.

---

## Related

- **Decision log**: `workflows/public/decision-log.md`
- **Plan review**: `workflows/public/plan-review.md`
- **Council sessions**: `workflows/public/council.md`

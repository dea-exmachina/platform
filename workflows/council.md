---
type: workflow
trigger: /council
status: active
created: 2026-02-10
updated: 2026-02-18
category: governance
playbook_phase: null
related_workflows:
  - council-review.md
  - plan-review.md
  - sprint-vision-review.md
project_scope: meta
last_used: null
---

# Workflow: Council Strategic Session

> Strategic planning construct — not a governance diagnostic. For diagnostics, use `council-review.md`.

## Purpose

Convene the council for strategic decision-making: new direction, major pivots, cross-system decisions, quarterly vision. Each construct speaks from their domain. The Supreme Authority synthesizes into a decision that becomes a plan for {{cos.name}}.

## When to Use

- Quarterly vision sessions
- Major directional decisions (new project, significant pivot)
- Meta-framework evolution
- When {{user.name}} raises a question that requires system-level thinking

---

## Council Composition

| Construct | Role | Brings |
|-----------|------|--------|
| **Supreme Authority** | Chair + synthesis | Direction, trajectory, guiding star alignment |
| **Team Construction** | Capability assessment | What can the bender swarm do? What's missing? |
| **Quality Standards** | Risk and quality | What could go wrong? What standards apply? |
| **Data Custodianship** | Data strategy | What data do we need? How does it flow? |
| **External Orchestration** | Dependencies | What external systems are involved? What are the risks? |
| **Overseer** (on demand) | External intel | Research on external landscape, tools, benchmarks |

---

## Session Types

### Quarterly Vision Session

**Frequency**: Once per quarter, at sprint close
**Trigger**: Two or more `drifting` sprint verdicts, or calendar trigger

**Agenda**:
1. Review last quarter's directional bets — confirmed, contradicted, or no signal?
2. Review sprint vision verdicts from the quarter
3. Update the 90-day arc
4. Set directional bets for next quarter
5. Identify open tensions to address

**Evidence base**: `identity/council/direction.md` + sprint vision verdicts from `/sprint-vision-review`

### Ad-hoc Decision Session

**Frequency**: As needed
**Trigger**: {{user.name}} or {{cos.name}} identifies a decision requiring system-level thinking

**Agenda**:
1. Frame the decision: what are the options?
2. Each construct gives their assessment (2-3 sentences max)
3. Supreme Authority synthesizes and proposes a decision
4. {{cos.name}} confirms or pushes back
5. Decision logged in `identity/council/decision-log.md`

---

## Session Format

### Opening (Supreme Authority)
- State the question or decision to be made
- Provide relevant context from `direction.md`
- Frame what a good outcome looks like

### Domain Assessments (each construct, in order)
- Team Construction: capability and capacity angle
- Quality Standards: quality and risk angle
- Data Custodianship: data and integrity angle
- External Orchestration: dependency and integration angle
- Overseer (if invoked): external research findings

### Synthesis (Supreme Authority)
```markdown
## Council Decision — {date}

**Question**: {what was being decided}

**Domain inputs**:
- Team Construction: {summary}
- Quality Standards: {summary}
- Data Custodianship: {summary}
- External Orchestration: {summary}

**Decision**: {the decision}
**Rationale**: {why this, not alternatives}
**Next actions**: {what {{cos.name}} does next}
```

---

## Output

1. Decision written to `identity/council/decision-log.md`
2. NEXUS cards created for action items
3. `direction.md` updated if the 90-day arc changed
4. {{user.name}} briefed if the decision is significant

---

## Related

- **Governance diagnostic**: `workflows/public/council-review.md`
- **Sprint vision review**: `workflows/public/sprint-vision-review.md`
- **Plan review gate**: `workflows/public/plan-review.md`
- **Direction file**: `identity/council/direction.md`

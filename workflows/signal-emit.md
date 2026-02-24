---
type: workflow
workflow_type: explicit
trigger: task_completion
status: inactive
category: learning-pipeline
related_workflows:
  - session-handoff.md
project_scope: meta
created: 2026-02-23
updated: 2026-02-23
---

> **ACTIVATION NOTE**: This workflow is inactive in new workspace provisioning. The learning pipeline (Supabase `learning_signals` table, hot path briefings, and quality standards pattern detection) must be set up and configured before this workflow is active. See `docs/setup/learning-pipeline.md` for activation steps. Once the data layer is in place and the `learning_signals` table exists, set `status: active` in this file's frontmatter.

---

# Workflow: Signal Emission

> **Type**: Explicit workflow — required at every task completion (once activated).

## Purpose

Every completed task emits a structured learning signal to the reservoir. Signals power both the **hot path** (PRE-TASK INTELLIGENCE briefings delivered to the next agent in the same domain) and the **cold path** (pattern detection → wisdom doc generation). This workflow ensures consistent, high-quality signal emission.

**Signal emission is a hard gate.** A task is not complete until its signal is written to `learning_signals`. Missing signals are flagged as incomplete delivery.

---

## When to Emit

| Who | When |
|-----|------|
| **Benders** | At task completion, before marking `status: delivered` in `bender_tasks` |
| **{{cos.name}}** | At session close, for each significant work item completed (Step 0.11 in `/{{cos.name}}-handoff`) |

---

## Signal Schema Reference

```yaml
# Required fields — ALL must be present
agent_id:       string    # bender slug (e.g. "orion") or "{{cos.name}}"
identity_slug:  string    # which identity file was active (e.g. "orion", "{{cos.name}}")
project:        string    # project name (e.g. "control-center", "nexus", "{{workspace.name}}")
domain:         enum      # see Domain Vocabulary below
expected:       string    # what you expected to happen
actual:         string    # what actually happened
recommendation: string    # the ONE thing you'd tell the next agent (required, non-null)
severity:       enum      # low | medium | high

# Optional but high-value (fill when applicable)
task_id:        string    # TASK-XXXXXX or card ID
card_id:        string    # nexus_cards.card_id
delta:          string    # meaningful gap between expected and actual (null if none)
friction:       string    # what slowed the work or caused rework
discovery:      string    # what worked better than expected

# Context quality — fill every time
context_loaded:      list  # which docs/triggers loaded into context
context_helpful:     list  # which ones actually helped
context_missing:     string  # what would have helped but wasn't available
context_irrelevant:  list  # what loaded but was noise

# Hot path feedback — fill if a briefing was received
briefing_received:  boolean
briefing_accurate:  boolean
briefing_feedback:  string  # what was wrong or missing
```

---

## Domain Vocabulary

Use the controlled enum. For tasks that don't cleanly fit, use `other` and add freeform `tags` to help future clustering.

| Domain | Use for |
|--------|---------|
| `supabase.migrations` | Schema changes, DDL, migration files |
| `supabase.rls` | Row-level security policies |
| `supabase.functions` | DB functions, triggers, stored procs |
| `supabase.realtime` | Realtime subscriptions, channels |
| `react.components` | UI components, pages, layouts |
| `react.auth` | Auth flows, session management, guards |
| `react.data-fetching` | Hooks, queries, API calls from UI |
| `api.design` | Route design, request/response contracts |
| `api.routing` | Next.js routes, middleware, handlers |
| `git.workflow` | Branch, commit, merge, PR operations |
| `bender.dispatch` | Task creation, context assembly, dispatch |
| `context.triggers` | Trigger rules, context loading, wisdom docs |
| `system.governance` | Meta-framework, CLAUDE.md, workflows, policies |
| `system.infrastructure` | Scripts, tooling, CI/CD, VM, cron jobs |
| `other` | Anything not covered above (add tags) |

---

## Quality Bar

### High-value signal (what to aim for)

```
expected: "Migration would apply cleanly — only adding a new table, no dependencies"
actual: "Failed because signal_domain type didn't exist yet — had to reorder the migration"
delta: "Type must be created before the column that references it"
friction: "No documented convention for type-before-table ordering in migrations"
discovery: null
recommendation: "Always CREATE TYPE before CREATE TABLE that uses it. Add this check to the pre-flight for any migration that introduces a new enum column."
severity: medium
context_missing: "A migration ordering guide — types before tables, constraints after both"
```

### Low-value signal (acceptable for confirmation tasks)

```
expected: "Index creation would be fast on an empty table"
actual: "Confirmed — applied instantly"
delta: null
friction: null
discovery: null
recommendation: "N/A — confirmation signal, nothing unexpected"
severity: low
```

**Rule**: `recommendation` is always required. For low-severity confirmation signals (expected = actual, no delta), `"N/A — confirmation signal"` is acceptable. For anything with a delta, friction, or discovery, write a real recommendation.

---

## Emission Steps

### For benders (at task delivery)

1. Reflect on the task just completed:
   - What did you expect vs. what happened?
   - What slowed you down?
   - What worked better than expected?
   - What would you tell the next agent before they start this?
   - Which context docs helped? What was missing? What was noise?

2. Write the signal to Supabase:

```http
POST {SUPABASE_URL}/rest/v1/learning_signals

Headers:
  apikey: {SUPABASE_ANON_KEY}
  Authorization: Bearer {SUPABASE_ANON_KEY}
  Content-Type: application/json

Body:
{
  "agent_id": "{your_slug}",
  "identity_slug": "{your_slug}",
  "project": "{project_name}",
  "domain": "{domain_enum_value}",
  "task_id": "{TASK-ID or card_id}",
  "card_id": "{card_id if applicable}",
  "expected": "...",
  "actual": "...",
  "delta": "...",
  "friction": "...",
  "discovery": "...",
  "recommendation": "...",
  "severity": "low|medium|high",
  "context_loaded": ["doc1.md", "doc2.md"],
  "context_helpful": ["doc1.md"],
  "context_missing": "...",
  "context_irrelevant": ["doc2.md"],
  "briefing_received": true|false,
  "briefing_accurate": true|false,
  "briefing_feedback": "..."
}
```

3. Note the returned signal UUID in your LEARNING comment.

4. Then mark task `delivered`.

### For {{cos.name}} (at session handoff, Step 0.11)

For each significant work item completed this session:

1. Identify the domain (from the card prefix or work type)
2. Write 1 signal per work item — brief but honest
3. Batch insert is acceptable; {{cos.name}} can emit multiple signals in one session
4. Low-severity items (routine card moves, admin tasks) can be grouped into a single "session housekeeping" signal

---

## Context Quality: What to Fill

The `context_*` fields are the highest-leverage feedback loop in the system. Even when the task itself was routine, filling these accurately improves the next agent's experience.

| Field | Fill when |
|-------|-----------|
| `context_loaded` | Always — list every doc/trigger that loaded into context |
| `context_helpful` | Always — subset of loaded docs that actually helped |
| `context_missing` | When you needed something that didn't exist or wasn't triggered |
| `context_irrelevant` | When a doc loaded but added noise rather than signal |

**Why this matters**: These fields evolve the trigger system. Three signals saying the same doc is irrelevant → trigger gets narrowed. Three signals saying the same knowledge was missing → the doc gets created and the trigger gets added.

---

## Anti-Patterns

- **Padding**: Writing generic recommendations that don't reflect actual work. "Check the docs first" on every signal. This degrades the hot path.
- **Skipping on easy tasks**: Confirmation signals still get emitted. Use `"N/A — confirmation signal"` for recommendation if nothing was unexpected.
- **Wrong domain**: Using `other` when a specific domain fits. The domain enum drives clustering — wrong domain = wrong cluster.
- **Empty context fields**: Leaving `context_loaded` null when docs were clearly loaded. The trigger effectiveness loop depends on this data.
- **Emitting after marking delivered**: The signal is part of delivery, not an afterthought. Write it before changing task status.

---

## Signal Integrity Rules

- **Append-only**: Signals are immutable. If you need to correct a signal, insert a new one with `superseded_by` pointing to the original.
- **No updates**: The DB enforces this with `trg_block_signal_update`. UPDATE attempts will error.
- **Schema version**: All signals are `schema_version: v1` until a migration changes the schema.

# transition_card() — Kanban Transition Convention

---

## Purpose

Every lane change on a NEXUS card must be:
1. **Sequential** — validated by DB trigger (`validate_lane_transition`)
2. **Auditable** — captured in `nexus_events` by `nexus_emit_card_event`
3. **Commented** — scope/decision changes require a human-readable note in `nexus_comments`

---

## Future: transition_card() Stored Proc

Once shipped, use this instead of raw UPDATEs:

```sql
SELECT * FROM transition_card(
  p_card_uuid   => 'uuid-here',
  p_to_lane     => 'in_progress',
  p_comment     => 'Starting implementation — scope confirmed.',
  p_author      => '{{cos.name}}'
);
```

The proc handles: lane validation, nexus_events emission, nexus_comments insert, and returns the updated card row.

---

## Interim: Raw UPDATE Pattern

Until `transition_card()` exists, follow this two-step pattern:

### Step 1 — Sequential lane update
```sql
-- Always step one lane at a time
UPDATE nexus_cards SET lane = 'ready'       WHERE card_id = 'CARD-XXX';
UPDATE nexus_cards SET lane = 'in_progress' WHERE card_id = 'CARD-XXX';
```

Lane order (no skipping):
```
backlog → ready → in_progress → review → done
```

### Step 2 — Comment (when required)

**Required** when the lane change reflects a decision, scope change, or delivery:
```sql
INSERT INTO nexus_comments (card_id, author, comment_type, content)
VALUES (
  'card-uuid-here',
  '{{cos.name}}',    -- or bender slug
  'delivery',        -- see types below
  'Delivered: ...'
);
```

**Not required** for mechanical lane-stepping (e.g., backlog→ready as part of batch prep). System events are auto-captured in `nexus_events`.

---

## Comment Type Reference

| type | When to use |
|------|-------------|
| `note` | Observation, status update, stale audit flag |
| `delivery` | Bender or {{cos.name}} delivery — what was built/done |
| `review` | Review decision (approve/reject with reasoning) |
| `rejection` | Task rejected — reason + next steps |
| `pivot` | Scope change mid-execution — what changed and why |
| `question` | Blocking question needing answer before proceeding |
| `directive` | Instruction from {{cos.name}} to bender on in-flight task |
| `system` | Reserved for DB triggers — do not use manually |

---

## Comment Templates

### Delivery
```
Delivered: {what was built}

**Files**: {list key files changed}
**Commit**: {hash} [{CARD-ID}]

**What changed**:
- ...

**Acceptance criteria met**: Yes / Partial (explain)
```

### Scope Pivot
```
Scope pivot: {what changed}

**Original scope**: ...
**New scope**: ...
**Reason**: ...
**Impact**: {other cards affected, if any}
```

### Stale Audit
```
Stale audit: Card has been in {lane} since {date}.

**Current state**: {what actually exists/is done}
**Recommended action**: {close / define remaining scope / archive}
```

### Review Decision
```
Review: {Approved / Needs work / Rejected}

**Assessment**: ...
**Issues found** (if any): ...
**Next step**: {merge / fix and re-deliver / reassign}
```

---

## bender_lane Transitions

Bender tasks have a parallel lane in `nexus_cards.bender_lane`. Step sequentially:

```
proposed → queued → executing → delivered → integrated
```

```sql
UPDATE nexus_cards SET bender_lane = 'executing' WHERE card_id = 'CARD-ID';
UPDATE nexus_cards SET bender_lane = 'delivered'  WHERE card_id = 'CARD-ID';
```

No DB trigger validates bender_lane — manual discipline required.

---

## Enforcement

- **DB trigger**: `validate_lane_transition` rejects non-sequential main lane changes
- **Production gate**: `done` lane requires production verification (see `production-gate.md`)

---
type: workflow
workflow_type: explicit
trigger: event
trigger_event: sprint.closed
status: active
category: vision
related_workflows:
  - sprint-review.md
  - council.md
  - council-review.md
  - session-handoff.md
related_templates: []
project_scope: meta
created: 2026-02-24
updated: 2026-02-24
last_used: null
---

# Workflow: Sprint Close Vision Review (Explicit)

> **Type**: Explicit workflow — follow steps in sequence. Runs at every sprint close as a structural event, not an optional add-on.

## Purpose

Assess whether the sprint's work moved the system toward the Guiding Star.

This is **not** a governance diagnostic — that is `/{{cos.name}}-council`. It is a directional health check: did we spend the sprint building toward something that matters? The output is an honest verdict with evidence from actual sprint cards, fed into `identity/council/direction.md` as a standing data point.

**The Guiding Star**: *Enable humans and AI to work together to solve real problems and build great things.*

Execution quality is orthogonal. A sprint can pass all velocity checks, hit all acceptance criteria, and still be aimed at the wrong thing. This review catches that second failure mode.

---

## When to Invoke

**Trigger**: Sprint moves to `completed` (after `close_sprint()` returns success in `sprint-review.md` Step 5).

Run immediately after `sprint-review.md` completes — before initiating the next sprint. The full sprint's work is visible, temporal distance allows honest pattern recognition, and the review feeds directly into `identity/council/direction.md` before that file is updated at session close.

**Sequence in the sprint close pipeline**:

```
sprint-review.md (velocity, retrospective, close_sprint())
    ↓
sprint-vision-review.md  ← this workflow
    ↓
identity/council/direction.md updated (Last Sprint section)
    ↓
sprint-init.md (next sprint)
```

---

## Reference Files

Load before running the review:

| File | Role |
|------|------|
| `identity/council/direction.md` | Standing brief — 90-day arc, open tensions, directional bets. The review assesses sprint work against this arc. |
| NEXUS sprint cards (completed) | Pull all cards with `lane = 'done'` for the closing sprint — these are the evidence base |
| Sprint goal (from `nexus_sprints.goal`) | The sprint's stated objective — what were we trying to accomplish? |

---

## Structured Review Questions

Answer each question with specific evidence. Assertions without card references are inadmissible.

### Q1. Sprint Goal — Directional or Operational?

Was the sprint goal aimed at the Guiding Star, or was it purely operational?

- **Directional**: The goal advances capability, ships something meaningful, or moves a real problem toward resolution
- **Operational**: The goal is system maintenance, backlog hygiene, or governance cleanup — necessary but not directionally generative

Both are valid. The question surfaces whether the sprint was investing in trajectory or just keeping the system alive. Answer: `directional` / `operational` / `mixed`. Cite the sprint goal text.

---

### Q2. Guiding Star Proximity — Did Completed Work Reduce Distance?

For each card group in `done`, assess: does this work get closer to enabling humans and AI to work together to solve real problems and build great things?

Cluster completed cards into three buckets:

| Bucket | What it means | Card examples |
|--------|---------------|---------------|
| **Star work** | Directly advances the Guiding Star — ships capability, removes friction for humans + AI collaboration, produces real output | New bender capability, shipped content, integrated tool |
| **Infrastructure** | Necessary foundation — does not directly advance the Star but enables future Star work | DB migrations, schema fixes, governance tooling |
| **Maintenance** | Keeps existing capability alive — neither advancing nor enabling new Star work | Bug fixes, documentation corrections, hygiene |

Record the rough distribution. A sprint of 100% maintenance is not neutral — it is time not spent building. A sprint of 100% Star work without infrastructure investment accumulates technical debt.

---

### Q3. Directional Bets — Moved, Stalled, or Contradicted?

Load `identity/council/direction.md` § Directional Bets. For each active bet:

- Did this sprint produce work that **confirmed** the bet's hypothesis?
- Did this sprint produce work that **contradicted** the bet (evidence it's wrong)?
- Did this sprint produce **no signal** on the bet (neither confirmation nor contradiction)?

If a bet receives no sprint signal for two consecutive sprints, it is stalling — surface for review at the next quarterly Vision session. Cite specific card IDs for any confirmation or contradiction.

---

### Q4. Open Tensions — Addressed, Ignored, or Worsened?

Load `identity/council/direction.md` § Open Tensions. For each active tension (status 🟡 or 🔴):

- Was any work in this sprint directed at the tension?
- Did the tension status improve, hold, or worsen?
- Were any new tensions introduced by this sprint's work?

New tensions are not failures — they are the normal byproduct of progress. But they must be named. Cite card IDs for any work that touched a tension directly.

---

### Q5. What Would Not Have Been Possible Without This Sprint?

Identify the one or two concrete capabilities, outputs, or decisions that exist now because of this sprint's work — that did not exist at sprint start. These are the sprint's directional contribution.

If you cannot name one, that is the finding. State it plainly: "No new directional capability was created this sprint." Do not rationalize or reframe. An honest null answer is more valuable than a manufactured positive.

---

### Q6. The Next User — Did This Sprint Leave the System Better for Them?

The system holds trajectory not just for this instance but for every person who runs it in the future. {{user.name}} is the first user, not the only user.

For this sprint: did the work improve the system's legibility, replicability, or capability in ways that would serve a future user? Or did it optimize for the current instance in ways that would confuse or constrain a new one?

This is not a gate — it is a directional signal. Answer honestly. Cite any work that was explicitly designed with replicability in mind, and any work that hardened instance-specific assumptions.

---

## Verdict Format

Issue one of three verdicts. The verdict requires evidence — a list of specific card IDs supporting the assessment. A verdict without cited cards is inadmissible.

### `aligned`

The sprint's work was demonstrably aimed at the Guiding Star. At least one piece of Star work was completed. Directional bets received signal. Open tensions were addressed or acknowledged.

**Required evidence**: Name the Star work cards. Name the bet signal (card ID + outcome). Confirm no new unchecked tensions.

### `drifting`

The sprint completed work but it is unclear whether that work moved toward the Star. The sprint may have been 100% infrastructure or maintenance without a clear line to future Star work. Directional bets received no signal. Open tensions were not addressed.

**Required evidence**: Identify the category distribution (infrastructure %, maintenance %). Identify which bets received no signal. Confirm no Star work was completed or explain why infrastructure was the correct investment.

### `misaligned`

Work was completed that actively contradicts the Guiding Star, or the sprint goal itself was not directionally grounded. Evidence of effort spent optimizing the wrong thing.

**Required evidence**: Identify the specific cards that constitute the misalignment. Explain the contradiction with the Star. This is a serious verdict — do not issue it without clear evidence.

---

## Output

### 1. Update `identity/council/direction.md` — Last Sprint Vision Alignment

After completing the review, update the `## Last Sprint's Vision Alignment` section:

```markdown
## Last Sprint's Vision Alignment

**Sprint**: {sprint name, e.g., Sprint 2026-W09}
**Verdict**: `aligned` | `drifting` | `misaligned`
**Evidence**:
- Q1 (goal type): {directional / operational / mixed} — {sprint goal text}
- Q2 (Star work): {card IDs} — {brief description of Star work}
- Q3 (bets): {bet name} → {confirmed / contradicted / no signal} — {card IDs}
- Q4 (tensions): {tension name} → {improved / held / worsened} — {card IDs or "no work"}
- Q5 (new capability): {one sentence — what now exists that didn't}
- Q6 (next user): {one sentence — system better / worse / neutral for next user}
```

All six fields required. `NONE` is valid for fields with no signal. Omitting a field is not.

### 2. Feed Quarterly Vision Session

Sprint Vision verdicts accumulate as the evidence base for the quarterly Vision session. Two or more consecutive `drifting` verdicts are an escalation signal — surface at the quarterly session, do not wait.

---

## Anti-Patterns

**Producing `aligned` without citing specific card IDs is theater.** The verdict is meaningless without evidence. If you cannot name the Star work cards, the verdict is `drifting` at best.

**Using execution metrics as vision evidence.** "We completed 12 of 13 cards (92% velocity)" is not evidence of alignment. Velocity measures throughput, not direction.

**Conflating governance health with directional health.** A sprint that fixed 8 governance issues and produced zero directional output may be `drifting`. Governance work is often necessary infrastructure — but call it that.

**Averaging across the sprint to avoid a hard verdict.** If the sprint had 2 Star work cards and 10 maintenance cards, name that ratio.

**Issuing `misaligned` without evidence.** `misaligned` is a strong verdict that demands specific card-level evidence. Drift is the default when direction is unclear — not misalignment.

---

## Quality Gates

Before marking the review complete:

- [ ] All 6 review questions answered with evidence
- [ ] Verdict issued: `aligned` / `drifting` / `misaligned`
- [ ] Verdict supported by cited card IDs (no cards cited = verdict inadmissible)
- [ ] `identity/council/direction.md` § Last Sprint Vision Alignment updated
- [ ] Any new tensions identified in Q4 added to `identity/council/direction.md` § Open Tensions
- [ ] Two consecutive `drifting` verdicts flagged for quarterly Vision session (if applicable)

---

## Related

- **Triggers from**: [`sprint-review.md`](sprint-review.md) (Step 5 — sprint close)
- **Feeds into**: `identity/council/direction.md`
- **Quarterly synthesis**: [`council.md`](council.md) § Quarterly Vision Session
- **Governance diagnostic** (separate purpose): [`council-review.md`](council-review.md)
- **Session close**: [`session-handoff.md`](session-handoff.md)

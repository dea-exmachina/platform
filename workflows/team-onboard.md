---
type: workflow
trigger: post-HIVE (Phase 7), manual
status: active
created: 2026-02-09
updated: 2026-02-18
category: bender
playbook_phase: "2.3"
related_workflows:
  - hive-construct.md
  - bender-assign.md
related_templates:
  - team-manifest.md
  - bender-identity.md
project_scope: all
last_used: null
---

# Workflow: Team Onboard

> Post-HIVE onboarding — ensures benders internalize project context before their first task. {{cos.name}} acts as team lead, mediating all interaction between benders and {{user.name}}.

## Purpose

After HIVE provisions team artifacts, this workflow runs each bender through context loading, question collection, and a consolidated user interview. Surfaces misunderstandings and captures user goals/nuances before work begins.

## Team Lead Model

**{{cos.name}} is the team lead for every team.** Benders never interact directly with {{user.name}}. All communication flows through {{cos.name}}:

```
{{user.name}} ↔ {{cos.name}} (team lead) ↔ Benders
```

- Benders submit questions and reports TO {{cos.name}}
- {{cos.name}} organizes, filters, and presents consolidated questions TO {{user.name}}
- {{cos.name}} distributes {{user.name}}'s answers and nuance back to bender knowledge files
- This applies to onboarding AND ongoing task execution

## When to Use

- Automatically after HIVE Phase 6 (Name & Structure)
- Manually when onboarding a new member to an existing team
- When a bender is reassigned to a different team/project

## Prerequisites

- [ ] Team manifest exists with onboarding section (project context list + readiness tracker)
- [ ] Bender identity files created in `identity/{name}/`
- [ ] Shared context files exist (`benders/context/shared/standards.md`, policies, etc.)
- [ ] Project-specific context files exist (listed in team manifest onboarding section)

---

## Phase A: Context Loading + Question Collection (per-bender, parallel)

Each bender loads context and submits questions to {{cos.name}}. Run all benders in parallel — they don't interact with {{user.name}} at this stage.

### Steps (per bender)

1. **Shared context** — system-level standards and policies:
   - [ ] `benders/context/shared/standards.md`
   - [ ] `benders/context/shared/policies.md`
   - [ ] `benders/context/shared/decision-authority.md`
   - [ ] `benders/context/shared/git-workflow.md`
   - [ ] `benders/context/shared/patterns.md`

2. **Team manifest** — sequencing, coordination, file ownership:
   - [ ] Read team manifest from `benders/teams/{team-name}.md`
   - [ ] Understand delivery chain and coordination rules
   - [ ] Note file ownership boundaries

3. **Core identity** — who this bender is:
   - [ ] Read `identity/{name}/identity.md`
   - [ ] Understand responsibilities, expectations, quality standards

4. **Project-specific context** — defined in team manifest onboarding section:
   - [ ] Read each file listed in the manifest's "Additional Context" table for this member
   - [ ] These are the project-specific resources this bender needs before their first task

5. **Prior learnings** (if any):
   - [ ] Check `identity/{name}/learnings.md` for domain-general knowledge
   - [ ] Check `identity/{name}/{team}/knowledge.md` for project-specific knowledge

6. **Comprehension check** — bender answers these internally (to {{cos.name}}, not {{user.name}}):
   - "What is this project about?"
   - "What are YOUR specific deliverables?"
   - "Who do you depend on, and who depends on you?"
   - "What existing tools, workflows, and scripts should you know about?"

7. **Question collection** — bender submits questions for the user:
   - Questions about user goals, preferences, and priorities not covered in docs
   - Clarifications about scope, positioning, or strategy
   - Gaps in context that need user input to resolve
   - Domain-specific questions relevant to their role

### Output (per bender)

- Comprehension summary (4 answers for {{cos.name}} to evaluate)
- Question list (for {{user.name}}, organized by topic)

---

## Phase B: Consolidated User Interview ({{cos.name}}-led, single session)

{{cos.name}} collects all bender questions, organizes them by topic, and runs ONE consolidated interview with {{user.name}}. No per-bender sessions — {{user.name}} answers once, {{cos.name}} distributes.

### Steps

1. **Collect and organize** bender questions:
   - [ ] Review all bender question lists from Phase A
   - [ ] Deduplicate overlapping questions
   - [ ] Group by topic (not by bender) — {{user.name}} shouldn't need to know which bender asked what
   - [ ] Add {{cos.name}}'s own questions based on comprehension review (gaps, misalignments spotted)
   - [ ] Flag any comprehension failures that need {{user.name}}'s input to resolve

2. **Run interview with {{user.name}}**:
   - [ ] Present organized questions grouped by topic
   - [ ] Include context for why each question matters
   - [ ] Allow {{user.name}} to add nuance, goals, and preferences not in existing docs
   - [ ] Specifically ask about:
     - User's goals and direction for this project (what does success look like?)
     - Preferences that aren't documented (style, priorities, dealbreakers)
     - Corrections to any bender misunderstandings {{cos.name}} flagged

3. **Evaluate comprehension** ({{cos.name}} reviews bender answers):
   - [ ] Flag any misunderstandings or gaps in bender comprehension
   - [ ] Identify cross-bender misalignments (e.g., one expects something another doesn't produce)
   - [ ] Note coordination gaps

4. **Decision per bender**:
   - **Pass**: Clear understanding + questions answered → proceed to Phase C
   - **Re-load**: Significant misunderstanding → provide corrections, have bender re-read relevant context
   - **Escalate**: Fundamental misalignment → additional {{user.name}} input needed

### Output

- {{user.name}}'s answers and nuance captured
- Per-bender pass/fail assessment
- Context gaps identified and documented

---

## Phase C: Knowledge Distribution + Readiness ({{cos.name}}-led)

{{cos.name}} distributes {{user.name}}'s answers back to bender knowledge files and confirms team readiness.

### Steps

1. **Record learnings** — write {{user.name}}'s answers and nuances to bender knowledge files:
   - [ ] Per-bender project learnings → `identity/{name}/{team}/knowledge.md`
   - [ ] Cross-team learnings → each relevant bender's knowledge file
   - [ ] Domain-general insights → `identity/{name}/learnings.md` (if applicable)

2. **Distribute corrections** — if any bender had comprehension gaps:
   - [ ] Write specific corrections to their knowledge file
   - [ ] Re-verify understanding if the gap was significant

3. **Update team manifest readiness tracker**:
   - [ ] Mark each bender's checkboxes: Context Loaded, Calibration, Ready
   - [ ] Update team status to "Onboarded" when all members are ready

4. **Final confirmation**:
   ```markdown
   ## Team Onboarding Complete

   **Team**: {name}
   **Members onboarded**: {count}/{total}

   | Member | Context | Calibration | Ready |
   |--------|---------|-------------|-------|
   | {name} | [x] | [x] | [x] |

   **Team status**: Onboarded — ready for Phase 0
   **Notes**: {any caveats, context gaps to document, nuances from {{user.name}}}
   ```

---

## Design Principles

- **Team lead model**: {{cos.name}} mediates ALL bender↔{{user.name}} interaction. Benders never prompt {{user.name}} directly
- **Bidirectional calibration**: Not just "do benders understand the project" but "do benders know what {{user.name}} wants"
- **Single user touchpoint**: {{user.name}} answers once in a consolidated interview, not per-bender
- **Parallel loading**: All benders load context simultaneously — only the interview is serialized
- **Reusable**: Works for any team — reads team manifest to determine project context
- **Learning-aware**: Checks prior learnings; writes new learnings back to knowledge files

## Common Issues

**Issue**: Bender gives vague comprehension answers
- **Solution**: {{cos.name}} asks follow-up questions directly.

**Issue**: Bender misunderstands delivery chain
- **Solution**: {{cos.name}} corrects and writes the correction to their knowledge file.

**Issue**: Project context files don't exist yet
- **Solution**: Flag to {{user.name}} in the consolidated interview. Some context may need to be created before onboarding can complete.

**Issue**: Bender identifies missing context
- **Solution**: Include in the consolidated interview for {{user.name}}'s input. Document the gap, create the missing artifact if needed.

**Issue**: {{user.name}}'s goals aren't captured in existing docs
- **Solution**: The consolidated interview should always include a goals/direction question. Write answers to relevant knowledge files.

## Related

- **HIVE construct**: `workflows/public/hive-construct.md` (Phase 7 triggers this)
- **Team manifest template**: `templates/public/team-manifest.md`
- **Bender identity template**: `templates/public/bender-identity.md`

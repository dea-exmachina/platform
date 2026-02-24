---
type: workflow
trigger: /{{cos.name}}-hive
status: active
created: 2026-02-09
updated: 2026-02-18
category: bender
playbook_phase: "2.1"
related_workflows:
  - team-onboard.md
  - bender-assign.md
project_scope: all
last_used: null
---

# Workflow: HIVE Construct (Team Assembly)

> Assemble a coordinated bender swarm for a multi-agent objective.

## Purpose

Build a bender team scoped to a specific project or objective. HIVE produces: team manifest, individual bender identity files, role assignments, and delivery chain definition. The team is then onboarded via `team-onboard.md`.

## When to Use

- A project requires multiple coordinated benders
- A new capability area needs a dedicated team
- An existing team needs restructuring

---

## Phase 1: Objective Framing

Define what the team will build:

```markdown
## Team Objective

**Goal**: {What will this team accomplish?}
**Scope**: {What's in and out of scope?}
**Timeline**: {Sprint count or date target}
**Success criteria**: {How will we know it's done?}
```

Ask {{user.name}} if the objective isn't clear.

---

## Phase 2: Role Design

Decompose the objective into bender roles. Each role must be:
- **Bounded**: Clear file/domain ownership
- **Independent**: Minimal blocking dependencies
- **Testable**: Deliverables are verifiable

| Role | Responsibility | Depends On | Depended By |
|------|---------------|------------|-------------|
| {name} | {what they own} | {upstream} | {downstream} |

**Common role patterns**:
- Researcher → feeds findings to implementers
- Frontend ↔ Backend (parallel, interface-contracted)
- Implementer → Reviewer (sequential)
- Writer → Editor (sequential)

---

## Phase 3: Identity Files

Create an identity file for each bender:

```
identity/{bender-name}/
  identity.md        — role, responsibilities, quality bar
  learnings.md       — starts empty; filled during onboarding
  {team}/
    knowledge.md     — project-specific context (filled during onboarding)
```

### identity.md template

```markdown
# Identity: {Bender Name}

## Role
{One-line role description}

## Responsibilities
{What this bender owns and delivers}

## Quality Standards
{What "done" looks like for this role}

## Decision Authority
{What this bender can decide autonomously vs escalate}

## Delivery Mode
git | file | inline

## Context Files
- Shared: standards.md, policies.md, git-workflow.md
- Role: task-types/{type}.md
- Project: {team}/knowledge.md
```

---

## Phase 4: Team Manifest

Create the team manifest at `benders/teams/{team-name}.md`:

```markdown
# Team: {Team Name}

## Objective
{Team goal — from Phase 1}

## Members

| Bender | Role | Delivery Mode | Status |
|--------|------|--------------|--------|
| {name} | {role} | git/file/inline | proposed |

## Delivery Chain
{Describe how work flows between benders}

## Coordination Rules
- {Rule about file ownership}
- {Rule about handoffs}
- {Rule about conflicts}

## Onboarding Status
| Member | Context Loaded | Calibrated | Ready |
|--------|---------------|-----------|-------|
| {name} | [ ] | [ ] | [ ] |
```

---

## Phase 5: {{user.name}} Approval

Present the team design for approval:

```
## HIVE Proposal: {Team Name}

**Objective**: {goal}
**Members**: {N} benders — {list roles}
**Delivery chain**: {brief description}
**Estimated setup time**: {time to onboard}

Approve to proceed to onboarding?
```

Do not create bender identity files until approved.

---

## Phase 6: Create Artifacts

On approval:
1. Create identity files for each bender
2. Create team manifest
3. Create team-specific knowledge.md files (empty, to be filled during onboarding)

---

## Phase 7: Onboarding

Trigger `team-onboard.md` to run each bender through context loading and the consolidated user interview.

---

## Related

- **Team onboarding**: `workflows/public/team-onboard.md`
- **Bender assignment**: `workflows/public/bender-assign.md`
- **Team manifest template**: `templates/public/team-manifest.md`
- **Bender identity template**: `templates/public/bender-identity.md`

---
type: workflow
workflow_type: goal
trigger: /{{cos.name}}-webapp or manual
status: active
created: 2026-02-05
category: project
playbook_phase: "3.2"
related_workflows:
  - card-branch.md
  - bender-assign.md
  - bender-review.md
related_templates:
  - project-webapp.md
  - team-manifest.md
project_scope: all
updated: 2026-02-18
last_used: null
---

# Workflow: Webapp Development (Bender Swarm)

> **Type**: Goal workflow — Phase-based execution with bender orchestration

## Purpose

Build webapps using a bender swarm. {{cos.name}} leads (architecture, decomposition, review, merge). Benders implement. Default stack: **Next.js + TypeScript**.

## Prerequisites

- [ ] Project brief exists (`portfolio/{project}/brief.md`)
- [ ] Architecture decisions made ({{cos.name}}, Phase 1)
- [ ] Interface contracts defined (`src/types/`)
- [ ] Kanban board ready for task tracking

---

## Operating Model

```
{{cos.name}} decomposes feature into tasks
  -> assigns to bender (via /{{cos.name}}-bender-assign)
    -> bender implements on task branch (from dev)
      -> bender delivers
        -> {{cos.name}} reviews (via /{{cos.name}}-bender-review)
          -> approved: {{cos.name}} merges task branch to dev
          -> needs work: feedback -> bender iterates
```

**{{cos.name}} never writes implementation code.** {{cos.name}} orchestrates, decomposes, defines architecture, reviews, and merges. All implementation flows through benders.

---

## Phase Execution

### Phase 0: Research

**Who**: Researcher bender (cheapest model with browser access)
**Context**: `benders/context/task-types/research.md`

**Inputs**: Research brief from {{cos.name}} (libraries to evaluate, API docs to read, patterns to investigate)
**Outputs**: Research document with findings, recommendations, trade-offs

**Entry criteria**: {{cos.name}} has scoped the research questions
**Exit criteria**: Research deliverable reviewed and accepted by {{cos.name}}

---

### Phase 1: Architecture

**Who**: {{cos.name}} (no bender — this is lead work)

**Inputs**: Project brief, research findings
**Outputs**:
- Architecture doc (tech decisions, data models, API contracts)
- Interface contracts in `src/types/`
- File ownership boundary definitions
- Folder structure conventions

**Entry criteria**: Research complete (or not needed)
**Exit criteria**: Architecture doc written, types skeleton committed, file boundaries defined

**Key decisions to make**:
- Database (Postgres, SQLite, none?)
- ORM (Prisma, Drizzle, none?)
- Auth (NextAuth, Clerk, custom, none?)
- Styling (Tailwind, CSS Modules, shadcn?)
- Deployment target (Vercel, Docker, other?)

---

### Phase 2: Scaffold

**Who**: Single bender or {{cos.name}} (depending on complexity)
**Context**: `benders/context/task-types/implementation.md`

**Inputs**: Architecture doc, folder structure
**Outputs**: Working project skeleton — `npm run dev` boots successfully

**Tasks**:
- `create-next-app` with TypeScript
- Folder structure per architecture doc
- Config files (ESLint/Biome, Prettier, tsconfig strict)
- CI pipeline skeleton (type check + lint + test)
- Pre-commit hooks (tsc --noEmit + lint)
- `.env.example` with required variables
- README with setup instructions

**Entry criteria**: Architecture doc complete
**Exit criteria**: `npm run dev` works, `tsc --noEmit` passes, lint passes

**Quality gate**: {{cos.name}} verifies scaffold before proceeding

---

### Phase 3: Implement (PARALLEL)

**Who**: Frontend bender + Backend bender (running simultaneously)

| Bender | Context File | Branch | Owns |
|--------|-------------|--------|------|
| Frontend | `task-types/webapp-frontend.md` | `feature/frontend-{feature}` | Pages, components, hooks, client lib, styles |
| Backend | `task-types/webapp-backend.md` | `feature/backend-{feature}` | API routes, services, db, middleware |

**Inputs**: Architecture doc, interface contracts, file ownership boundaries
**Outputs**: Feature branches with working code

**Parallel execution rules**:
1. Frontend and Backend benders launch as parallel Task calls
2. Each bender receives only their role context + shared types
3. File ownership boundaries prevent conflicts
4. If a bender needs a shared file changed, they flag it — {{cos.name}} handles
5. Both benders code against `src/types/` (the contract), not each other

**Entry criteria**: Scaffold complete, types defined
**Exit criteria**: Both benders deliver, code compiles, basic functionality works

**Quality gate**: {{cos.name}} reviews each bender's deliverable independently before merging

---

### Phase 4: Integrate + Review

**Who**: {{cos.name}} (merge) + Reviewer bender (review)
**Context**: `task-types/webapp-review.md` (for reviewer)

**Step 1 — {{cos.name}} merges**:
- Merge frontend branch to dev
- Merge backend branch to dev
- Resolve conflicts (usually in shared areas)
- Verify `npm run dev` works with both integrated

**Step 2 — Reviewer bender**:
- Full codebase review against checklist
- Security, integration, frontend quality, backend quality, TypeScript, performance
- Reports findings with severity levels (BLOCKER / MAJOR / MINOR / NIT)

**Entry criteria**: Both feature branches delivered and individually reviewed
**Exit criteria**: Review complete, all BLOCKERs resolved, MAJORs addressed or accepted

---

### Phase 5: Test

**Who**: TestWriter bender
**Context**: `task-types/webapp-testing.md`

**Inputs**: Integrated codebase, review findings
**Outputs**: Test suite (unit + integration + key E2E)

**Coverage targets**:
- Services: 80%+
- API routes: 70%+
- Components: Key interactions
- E2E: Critical user paths

**Entry criteria**: Code reviewed and integrated on dev
**Exit criteria**: Tests pass, coverage targets met, no flaky tests

---

### Phase 6: Polish

**Who**: {{cos.name}} assigns targeted fix tasks to benders

**Inputs**: Test results, review findings, manual testing
**Outputs**: Bug fixes, performance improvements, edge case handling

**This is iterative** — small, focused tasks assigned individually.

**Entry criteria**: Tests written, issues identified
**Exit criteria**: Ship-ready — `dev` promoted for testing, then → `main` for production

---

## Branch Strategy

```
main (PROD) <-- dev (WORKING) <-- task/TASK-XXX
                               <-- feature/frontend-{feature}
                               <-- feature/backend-{feature}
```

- Benders work on task branches (or feature branches for multi-task work)
- {{cos.name}} merges task branches to dev after review
- dev → main for production release ({{cos.name}} only)

## Conflict Prevention

1. **File ownership boundaries** — Frontend and Backend benders never touch the same files
2. **Interface contracts** — Both code against `src/types/`, defined by {{cos.name}} before implementation
3. **Shared file protocol** — Benders flag needs, {{cos.name}} makes changes
4. **Automated guards** — `tsc --noEmit` on every commit catches type mismatches

## The Bender Loop (per task)

```
1. {{cos.name}} writes task brief (requirements, acceptance criteria, file boundaries)
2. {{cos.name}} assigns via native agent or Task tool
3. Bender runs pre-flight (can I execute this as written?)
   +-- CLEAR -> execute
   +-- UNCLEAR -> questions back to {{cos.name}}
4. Bender implements on feature branch
5. Bender delivers (commits, marks delivered)
6. {{cos.name}} reviews against acceptance criteria
   +-- APPROVED -> {{cos.name}} merges to dev
   +-- MINOR ISSUES -> {{cos.name}} fixes directly
   +-- MAJOR ISSUES -> feedback to bender, re-assign
7. {{cos.name}} updates kanban
```

## Related

- **Role contexts**: `benders/context/task-types/webapp-*.md`
- **Platform routing**: `benders/context/shared/platform-routing.md`
- **Model selection**: `benders/context/shared/model-selection.md`
- **Git workflow**: `benders/context/shared/git-workflow.md`
- **Task commit**: `workflows/public/task-commit.md`
- **Bender assign**: `/{{cos.name}}-bender-assign`
- **Bender review**: `/{{cos.name}}-bender-review`

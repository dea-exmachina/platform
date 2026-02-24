---
type: workflow
trigger: manual
status: active
created: 2026-02-10
updated: 2026-02-18
category: infrastructure
playbook_phase: "1.0"
related_workflows:
  - identity-setup.md
  - data-layer-setup.md
  - kanban-setup.md
  - council-setup.md
  - delegation-policy-setup.md
  - integration-wiring.md
  - monitoring-setup.md
project_scope: meta
last_used: null
---

# Workflow: System Bootstrap

> Phase 1 of the system playbook. Run once when provisioning a new workspace.

## Purpose

Bootstrap a fresh workspace from zero. After this workflow completes, the system is operational: identity established, data layer live, kanban running, and governance initialized.

## Sequence

Run phases in order. Each phase is a prerequisite for the next.

---

## Phase 1.1: Identity Setup

**Workflow**: `identity-setup.md`
**Who**: {{cos.name}} (runs interview, {{user.name}} answers)

Establishes:
- {{cos.name}}'s identity and relationship with {{user.name}}
- Active domains
- Voice calibration
- Wisdom file initialization

---

## Phase 1.2: Data Layer Setup

**Workflow**: `data-layer-setup.md`
**Who**: {{cos.name}}

Establishes:
- Dev Supabase instance
- Production Supabase instance
- Foundation migrations applied to both
- RLS policies active
- Connection verified

---

## Phase 1.3: Kanban Setup

**Workflow**: `kanban-setup.md`
**Who**: {{cos.name}}

Establishes:
- NEXUS projects for each active work area
- Seed cards for remaining setup steps
- Lane vocabulary configured
- Project card prefixes set

---

## Phase 1.4: Council Setup

**Workflow**: `council-setup.md`
**Who**: {{cos.name}}

Establishes:
- `identity/council/` directory with direction.md
- Council NEXUS project
- Governance diagnostic scheduled (quarterly)

---

## Phase 1.5: Delegation Policy

**Workflow**: `delegation-policy-setup.md`
**Who**: {{cos.name}} (with {{user.name}} review)

Establishes:
- Autonomous / notify / approve / council authority matrix
- Domain-specific policies for active projects
- Written to `identity/{{cos.name}}/delegation-policy.md`

---

## Phase 1.6: Integration Wiring

**Workflow**: `integration-wiring.md`
**Who**: {{cos.name}}

Establishes:
- Email (Resend) configured and tested
- Discord (if used) configured
- Vercel connected
- All environment variables documented in `.env.example`

---

## Phase 1.7: Monitoring Setup

**Workflow**: `monitoring-setup.md`
**Who**: {{cos.name}}

Establishes:
- Supabase health check configured
- Vercel deployment notifications active
- Uptime monitoring for public services (if any)
- Health check doc initialized

---

## Bootstrap Completion Checklist

After all phases:

- [ ] {{cos.name}} identity file exists and is calibrated
- [ ] Supabase dev + prod instances accessible
- [ ] Foundation migrations applied to both instances
- [ ] NEXUS kanban has at least one active project
- [ ] Council direction.md initialized
- [ ] Delegation policy documented
- [ ] At least one integration (email) configured and tested
- [ ] `.env.example` complete with all required variables
- [ ] System playbook card marked done

---

## What Comes After Bootstrap

Once bootstrap is complete, move to Phase 2: Team Assembly (if benders needed) or Phase 3: Project Execution.

See `system-playbook.md` for the full playbook.

---

## Related

- **System playbook**: `workflows/public/system-playbook.md`
- **Identity setup**: `workflows/public/identity-setup.md`
- **Data layer**: `workflows/public/data-layer-setup.md`

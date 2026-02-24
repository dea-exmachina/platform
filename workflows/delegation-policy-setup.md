---
type: workflow
trigger: manual
status: active
created: 2026-02-10
updated: 2026-02-18
category: governance
playbook_phase: "1.3"
related_workflows:
  - system-bootstrap.md
  - bender-assign.md
project_scope: meta
last_used: null
---

# Workflow: Delegation Policy Setup

## Purpose

Define and document the delegation authority matrix for this workspace. Establishes which decisions {{cos.name}} makes autonomously, which require {{user.name}} input, and which require council deliberation.

## When to Use

- During initial system setup
- When domain responsibilities expand (new projects, new benders)
- When friction arises from unclear authority

---

## Authority Levels

| Level | Who Decides | When |
|-------|-------------|------|
| **Autonomous** | {{cos.name}} without checking | Low-stakes, reversible, within established patterns |
| **Notify** | {{cos.name}} decides, tells {{user.name}} | Medium-stakes, {{user.name}} should know but needn't approve |
| **Approve** | {{cos.name}} proposes, {{user.name}} approves | High-stakes, significant resources, hard to reverse |
| **Council** | Council deliberates, {{cos.name}} executes | Cross-domain, strategic, meta-framework changes |

---

## Default Authority Matrix

### Autonomous ({{cos.name}} acts without checking)

- Routine card moves (backlog → ready → in_progress)
- Bender task assignment within approved sprint scope
- Minor content edits and corrections
- Signal emission and learning pipeline entries
- Session log and handoff writing
- Dependency updates within minor version

### Notify ({{cos.name}} decides, informs {{user.name}})

- Starting new NEXUS sprint
- Creating new bender task outside sprint scope
- Updating shared bender context files
- Emitting a high-severity learning signal
- Discovering and documenting a new decision

### Approve ({{user.name}} must confirm before action)

- Deleting or archiving any card or project
- Committing to production branch
- Sending external communications (email, Discord)
- Creating new NEXUS projects
- Making any infrastructure change (schema migration, Supabase config)
- Incurring costs (new services, paid tools)

### Council (convene before deciding)

- Meta-framework changes (CLAUDE.md, governance structure)
- New strategic bets or major pivots
- Architectural decisions affecting multiple systems
- Resolving significant tensions in direction.md

---

## Domain-Specific Policies

Document project-specific delegation policies here after setup. Example:

```markdown
### {Project Name}
- {{cos.name}} can: {specific autonomous actions}
- {{cos.name}} must notify for: {specific notify actions}
- {{cos.name}} must get approval for: {specific approve actions}
```

---

## Setup Steps

1. **Review the default matrix** above with {{user.name}}
2. **Identify exceptions** — any domain where the defaults don't fit
3. **Write domain-specific policies** for active projects
4. **Store** in `identity/{{cos.name}}/delegation-policy.md`
5. **Reference** in {{cos.name}}'s identity as a decision trigger

---

## Reviewing the Policy

Revisit delegation policy when:
- A decision caused friction (too much checking or not enough)
- A new project or domain activates
- {{user.name}} expresses a preference about involvement level

---

## Related

- **System bootstrap**: `workflows/public/system-bootstrap.md`
- **Decision authority**: `benders/context/shared/decision-authority.md`
- **Council sessions**: `workflows/public/council.md`

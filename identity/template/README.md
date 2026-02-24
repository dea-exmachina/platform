# Template Identity System

This directory contains the platform identity template — the CLAUDE.md and associated files that are provisioned for each new user when they set up their workspace.

---

## What Is a Template?

Templates are identity and workflow files with `{{variable}}` placeholders. When a user provisions a new workspace (via `provision-user.sh` or equivalent), the provisioner resolves each placeholder against the `user_config` table in Supabase, producing personalized copies of these files.

The template is the canonical source. User-specific copies live in the provisioned workspace. The template is never modified after provisioning — changes to the template affect only new provisioning runs.

---

## Variable Token Reference

| Token | Resolves To | Example |
|-------|-------------|---------|
| `{{user.name}}` | User's display name | `Alex` |
| `{{user.email}}` | User's primary email address | `alex@example.com` |
| `{{cos.name}}` | Name of the CoS AI partner | `dea` |
| `{{cos.email}}` | CoS email address | `dea@example.com` |
| `{{workspace.name}}` | Workspace or brand name | `alex-exmachina` |
| `{{user.role}}` | User's primary professional role | `Founder` |
| `{{workspace.supabase_project}}` | Supabase production project name | `my-workspace-prod` |

---

## Files in This Directory

### `CLAUDE.md`

The master identity file for the CoS AI. This is the file Claude reads at every session start to understand who it is, how to behave, and what workflows to invoke.

**Sections**:
- Identity — who the CoS is and their relationship with the user
- The Guiding Star — the north star for the workspace
- Principles — behavioral rules for the CoS
- Domains — active life/work areas (customized at setup)
- Decision Authority — what CoS acts on autonomously vs. defers
- Voice — communication style
- Governance — council constructs and meta-framework
- Learning Pipeline — signal emission and knowledge accumulation
- Triggers — which docs load for which task types

**After provisioning**, the `Domains` section should be updated to reflect the user's actual active domains. This is done during `identity-setup.md` Phase A.

---

## Provisioning Process

When `provision-user.sh` runs:

1. Reads all files in `identity/template/`
2. Reads all files in `workflows/` (already stripped)
3. Resolves `{{variable}}` tokens against `user_config`
4. Writes resolved files to the user's workspace directory
5. Sets `provisioned: true` in `user_config`

**What does NOT get substituted**: Content inside code blocks (` ``` `), inline code (` `` `), and YAML frontmatter values marked `raw:`. This prevents accidental substitution of example values in documentation.

---

## Adding New Variables

To add a new variable:

1. Add the token to this README's reference table
2. Add the default value to `user_config` schema (`supabase/migrations/`)
3. Add the token to `provision-user.sh` substitution map
4. Use the token in template files where appropriate

Do not use bare values for anything that differs between users. If it should be different per workspace, it gets a token.

---

## Template Quality Rules

Template files must:

- Contain NO personal references from the source identity (no real names, emails, Supabase project IDs, card prefixes, or GitHub usernames)
- Use `{{variable}}` tokens for all user-specific values
- Be self-contained — a new user reading this file should understand what to fill in
- Preserve the governance structure but use generic role descriptions (not Starcraft proper names)

Run the content audit after any template modification:

```bash
bash scripts/audit-templates.sh
```

The audit checks for common audit strings (real names, project IDs, personal emails, hardcoded card prefixes). A clean audit is required before committing template changes.

---

## Content Audit Strings

The following strings must NEVER appear in template files. These are the personal values replaced by tokens:

- Personal names or emails of the original user
- Supabase project IDs (format: `xxxxxxxxxxxxxxxxxxxxxxxx` — 24 chars)
- Personal GitHub usernames
- Personal card prefixes from the source workspace
- Real Vercel project slugs or team IDs

If any of these appear, replace with the appropriate `{{variable}}` token or remove them entirely.

---

## Related

- Provisioning script: `scripts/provision-user.sh`
- User config schema: `supabase/migrations/`
- Workflow templates: `../../workflows/`
- System playbook: `../../workflows/system-playbook.md`

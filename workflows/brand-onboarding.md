---
type: workflow
trigger: manual
status: active
created: 2026-02-10
updated: 2026-02-18
category: content
playbook_phase: null
related_workflows:
  - identity-setup.md
project_scope: all
last_used: null
---

# Workflow: Brand Onboarding

## Purpose

Establish a new brand identity in the system — voice, visual style, audience, and positioning. Brand profiles drive content generation, slide creation, and email tone.

## When to Use

- New project or venture launching with a distinct brand
- Existing brand being formalized for the first time
- Brand refresh requiring updated identity files

---

## Step 1: Brand Interview

Gather brand fundamentals. Ask {{user.name}} (or extract from provided materials):

### Identity
- Brand name
- One-line description (what it does, who it's for)
- Brand promise / value proposition

### Audience
- Primary audience (who they are, what they care about)
- Secondary audience (if any)
- Audience pain points this brand addresses

### Voice & Tone
- 3-5 adjectives describing brand personality
- Communication style (formal / conversational / technical / warm)
- Words to use / words to avoid
- Examples of on-brand vs off-brand copy

### Visual Identity
- Primary and secondary colors (hex codes)
- Typography (heading font, body font)
- Logo (path or description)
- Visual style (minimal / bold / editorial / playful)

### Positioning
- Category this brand competes in
- Key differentiator vs alternatives
- Positioning statement: "For [audience], [brand] is the [category] that [differentiator]"

---

## Step 2: Create Brand Files

### File structure

```
brands/{brand-slug}/
  brand.md          — identity, voice, positioning
  audience.md       — audience profile
  assets/           — logo, images
```

### brand.md template

```markdown
# Brand: {Brand Name}

## Identity
**Description**: {one-liner}
**Promise**: {brand promise}
**Positioning**: For {audience}, {brand} is the {category} that {differentiator}

## Voice & Tone
**Personality**: {adjectives}
**Style**: {formal/conversational/etc}
**Use**: {words/phrases to use}
**Avoid**: {words/phrases to avoid}

## Visual Identity
**Primary color**: #{hex}
**Secondary color**: #{hex}
**Heading font**: {font}
**Body font**: {font}

## Examples
**On-brand**: {example copy}
**Off-brand**: {example copy}
```

---

## Step 3: Register Brand

If the system has a brands registry (e.g., `brands/INDEX.md`), add an entry:

```markdown
| {brand-slug} | {Brand Name} | {one-liner} | {date added} |
```

---

## Step 4: Verify

- [ ] Brand files created in correct location
- [ ] Voice examples are clear and representative
- [ ] Colors verified (valid hex codes)
- [ ] Registry updated
- [ ] Brand available for use in content workflows

---

## Related

- **Identity setup**: `workflows/public/identity-setup.md`
- **PPTX brand setup**: `workflows/public/pptx-brand-setup.md`
- **Content creation**: relevant content workflow for this brand

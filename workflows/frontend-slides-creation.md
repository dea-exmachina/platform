---
type: workflow
workflow_type: goal
trigger: /frontend-slides
status: active
created: 2026-02-05
category: content
playbook_phase: null
related_workflows:
  - frontend-slides-conversion.md
related_templates: []
project_scope: all
updated: 2026-02-18
last_used: null
---

# Workflow: Frontend Slides Creation (HTML from Scratch)

> **Type**: Goal workflow — Phase-based execution

## Purpose

Create a polished, animation-rich HTML presentation from scratch — no source PPTX. Starts from content and design direction, outputs a single deployable HTML file.

## Prerequisites

- [ ] Content brief or outline available
- [ ] Design direction or aesthetic preference known
- [ ] Audience and purpose clear

---

## Phase 1: Content Scoping

Establish what the presentation covers:
- Title and purpose
- Target audience
- Number of slides (rough)
- Key messages (3-5 bullet points for the whole deck)
- Call to action or desired outcome

---

## Phase 2: Design Direction

Establish visual identity. Present options if user hasn't specified:

| Aesthetic | Feel | Best For |
|-----------|------|---------|
| Editorial | Bold typography, high contrast | Thought leadership, talks |
| Tech Modern | Dark, data-forward, accent colors | Technical, product demos |
| Clean Professional | White space, subtle | Business, investor decks |
| Expressive | Gradients, layered, dramatic | Creative, brand presentations |

Confirm: font choice, primary/accent colors, animation style (subtle/dramatic).

---

## Phase 3: Slide Structure

Plan the deck before building:

| # | Type | Title | Key Content |
|---|------|-------|-------------|
| 1 | Title | {title} | {subtitle, presenter} |
| 2 | Agenda | What we'll cover | {3-5 topics} |
| ... | ... | ... | ... |
| N | CTA | {closing message} | {next step} |

Typical structure:
- Opening (1-2 slides): hook, context
- Body (varies): one idea per slide
- Closing (1-2 slides): summary, CTA

---

## Phase 4: Build

Output: Single `presentation.html` with embedded CSS and JS.

Standards:
- Arrow key + click navigation
- Progress bar or slide counter
- Smooth transitions between slides
- Staggered content animations within slides
- No external dependencies (fully self-contained)
- Responsive to window size (scales proportionally)

---

## Phase 5: Review

Present slides to user (or describe each slide's layout and content). Incorporate feedback before finalizing.

---

## Phase 6: Output

Deliver `output/{name}-presentation.html`. If deploying for sharing, push to static host.

---

## Quality Bar

- [ ] Every slide has a clear visual hierarchy
- [ ] No slide is text-dense (3-5 items max per slide)
- [ ] Animations enhance rather than distract
- [ ] Design is consistent across all slides
- [ ] File is self-contained and deployable

---

## Related

- **Conversion workflow** (from PPTX): `workflows/public/frontend-slides-conversion.md`
- **Skill**: `/frontend-slides`

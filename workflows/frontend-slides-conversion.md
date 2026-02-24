---
type: workflow
workflow_type: goal
trigger: /frontend-slides
status: active
created: 2026-02-05
category: content
playbook_phase: null
related_workflows:
  - frontend-slides-creation.md
related_templates: []
project_scope: all
updated: 2026-02-18
last_used: null
---

# Workflow: Frontend Slides Conversion (PowerPoint → HTML)

> **Type**: Goal workflow — Phase-based execution

## Purpose

Convert an existing PowerPoint/PPTX file into a polished, animation-rich HTML presentation. Preserves content and structure from the source, applies visual design improvements, and outputs a single deployable HTML file.

## Prerequisites

- [ ] PPTX source file accessible
- [ ] python-pptx available for extraction
- [ ] Design direction confirmed with user

---

## Phase 1: Extract

Extract content from PPTX using python-pptx:

```python
from pptx import Presentation

prs = Presentation("source.pptx")
for i, slide in enumerate(prs.slides):
    print(f"--- Slide {i+1} ---")
    for shape in slide.shapes:
        if shape.has_text_frame:
            for para in shape.text_frame.paragraphs:
                print(para.text)
```

Capture:
- Slide order and count
- Text content per slide (titles, body, bullets)
- Speaker notes (if any)
- Any charts or data tables (extract values)

---

## Phase 2: Design Direction

Before building, establish visual direction. Options:
- Match source PPTX branding (colors, fonts)
- Apply a new design system (ask user to choose an aesthetic)
- Follow an existing brand from `brands/`

Aesthetic options to present if no direction given:
- **Editorial**: Bold typography, high contrast, newspaper-inspired
- **Tech Modern**: Dark backgrounds, accent colors, data-forward
- **Clean Professional**: White space, subtle accents, business-ready
- **Expressive**: Gradients, layered elements, visual drama

---

## Phase 3: Build HTML Structure

Output: Single `presentation.html` file with embedded CSS and JS.

Structure:
```html
<!DOCTYPE html>
<html>
<head>
  <!-- Embedded styles -->
</head>
<body>
  <div class="presentation">
    <div class="slide" id="slide-1">...</div>
    <div class="slide" id="slide-2">...</div>
    <!-- ... -->
  </div>
  <!-- Embedded navigation JS -->
</body>
</html>
```

Navigation: Arrow keys + click. Progress indicator. Slide counter.

---

## Phase 4: Apply Animations

For each slide type, apply appropriate entrance animations:
- Title slides: Dramatic fade + scale
- Content slides: Staggered content reveal
- Data slides: Count-up numbers, bar growth
- Transition slides: Sweep or wipe

Use CSS animations (no external libraries required).

---

## Phase 5: Validate

- [ ] All slides present (count matches source)
- [ ] Content accurate (no text lost in extraction)
- [ ] Navigation works (arrows, click)
- [ ] Animations don't obscure content
- [ ] Renders correctly in Chrome (primary) and Firefox
- [ ] File is self-contained (no external dependencies)

---

## Output

Single file: `output/{name}-presentation.html`

Optionally: Deploy to a static host for sharing via URL.

---

## Related

- **Creation workflow** (from scratch): `workflows/public/frontend-slides-creation.md`
- **Skill**: `/frontend-slides`

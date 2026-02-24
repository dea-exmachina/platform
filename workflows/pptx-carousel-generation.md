---
type: workflow
workflow_type: explicit
trigger: skill
skill: /pptx-generator
status: active
created: 2026-02-05
category: content
playbook_phase: null
related_workflows:
  - pptx-brand-setup.md
  - pptx-slide-generation.md
related_templates: []
project_scope: all
updated: 2026-02-18
last_used: null
---

# Workflow: PPTX Carousel Generation (Explicit)

> **Type**: Explicit workflow — Follow steps precisely

## Purpose

Create LinkedIn carousels — multi-page PDFs in square (1:1) format, exported from PPTX.

## Prerequisites

- [ ] Brand exists at `.claude/skills/pptx-generator/brands/{brand}/`
- [ ] LibreOffice installed (for PDF export)

---

## Carousel vs Presentation

| Aspect | Presentation | Carousel |
|--------|--------------|----------|
| Dimensions | 16:9 (13.333" x 7.5") | 1:1 (7.5" x 7.5") |
| Layouts | `cookbook/*.py` | `cookbook/carousels/*.py` |
| Output | PPTX | PDF (via PPTX) |
| Slides | 10-50+ | 5-10 optimal |
| Text size | Standard | Larger (mobile readable) |
| Content | Detailed | One idea per slide |

---

## Step 1: Brand Discovery

Same as slide generation — read brand.json, config.json, and tone-of-voice.md.

---

## Step 2: Carousel Layout Discovery

```
Glob: .claude/skills/pptx-generator/cookbook/carousels/*.py
```

| Layout | Purpose | Best For |
|--------|---------|----------|
| `hook-slide` | Opening attention-grabber | First slide only |
| `single-point-slide` | One key point | Body content |
| `numbered-point-slide` | Numbered list item | Listicles, steps |
| `quote-slide` | Quote with attribution | Social proof |
| `cta-slide` | Call to action | Last slide only |

Read frontmatters to understand limits and constraints.

---

## Step 3: Carousel Planning

**Typical structure (5-10 slides):**

| # | Layout | Content |
|---|--------|---------|
| 1 | hook-slide | Attention-grabbing hook |
| 2-8 | single-point or numbered-point | Body content |
| 9/10 | cta-slide | Call to action |

**Content rules:**
- One idea per slide
- Large text (mobile readable)
- Max 50 chars headlines, 150 body
- Strong hook first, clear CTA last

---

## Step 4: Generate Carousel

**Square dimensions:**
```python
prs.slide_width = Inches(7.5)
prs.slide_height = Inches(7.5)
```

Carousels are typically 5-10 slides — batching rarely needed.

```bash
uv run --with python-pptx==1.0.2 python << 'SCRIPT'
# Carousel generation with 7.5" x 7.5" dimensions
SCRIPT
```

---

## Step 5: Export to PDF

LinkedIn requires PDF for carousel posts.

**Option A: LibreOffice (recommended)**
```bash
libreoffice --headless --convert-to pdf --outdir output/{brand} output/{brand}/carousel.pptx
```

**Option B: soffice**
```bash
soffice --headless --convert-to pdf output/{brand}/carousel.pptx
```

---

## Step 6: Output

Save both files:
- `output/{brand}/{name}-carousel.pptx` — Editable source
- `output/{brand}/{name}-carousel.pdf` — LinkedIn-ready

---

## Checklist

- [ ] Read brand configuration
- [ ] Read carousel layout frontmatters
- [ ] Plan structure (hook → body → CTA)
- [ ] Text SHORT (check character limits)
- [ ] Use 7.5" x 7.5" dimensions
- [ ] Generate PPTX
- [ ] Validate output
- [ ] Export to PDF
- [ ] Test PDF in LinkedIn preview

---

## Related

- **Skill**: `/pptx-generator`
- **Slide generation**: `workflows/public/pptx-slide-generation.md`
- **Brand setup**: `workflows/public/pptx-brand-setup.md`

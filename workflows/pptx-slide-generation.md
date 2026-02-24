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
  - pptx-carousel-generation.md
  - pptx-layout-crud.md
related_templates: []
project_scope: all
updated: 2026-02-18
last_used: null
---

# Workflow: PPTX Slide Generation (Explicit)

> **Type**: Explicit workflow — Follow steps precisely

## Purpose

Full slide generation pipeline: brand discovery, layout selection, content adaptation, batch generation, validation, and output.

## Prerequisites

- [ ] Brand exists at `.claude/skills/pptx-generator/brands/{brand}/`
- [ ] python-pptx available (`uv run --with python-pptx==1.0.2`)

---

## Step 1: Brand Discovery

1. **List available brands:**
   ```
   Glob: .claude/skills/pptx-generator/brands/*/brand.json
   ```

2. **Read brand configuration:**
   ```
   Read: .claude/skills/pptx-generator/brands/{brand}/brand.json
   Read: .claude/skills/pptx-generator/brands/{brand}/config.json
   ```

3. **Read supporting markdown** for voice/tone:
   ```
   Glob: .claude/skills/pptx-generator/brands/{brand}/*.md
   ```

4. **Extract:** Colors (hex without #), fonts, asset paths, output directory, voice/tone/vocabulary

If brand not found, list available brands and ask user to choose.

---

## Step 2: Layout Discovery (READ ALL FRONTMATTERS)

**MANDATORY: Read ALL layout frontmatters before selecting any layout.**

### 2a: Discover all layouts
```
Glob: .claude/skills/pptx-generator/cookbook/*.py
```

### 2b: Read EVERY layout file
For each `.py` file, read the first 40 lines to extract the `# /// layout` frontmatter block. Build a map of:
- What each layout is for (`purpose`, `best_for`)
- What each layout should NOT be used for (`avoid_when`)
- Limits and constraints (`max_*`, `min_*`, `*_max_chars`)

### 2c: Select layouts (only AFTER reading all frontmatters)
1. User specifies layout → Verify it fits the content
2. User describes content → Match to best-fitting `best_for` criteria
3. Check `avoid_when` → Don't use a layout in warned situations
4. Respect limits → If content exceeds `max_*`, use a different layout
5. No good fit → Create a custom layout (see layout CRUD workflow)

**Apply the Visual-First Selection decision tree** from `REFERENCE.md` — default to visual layouts. Content-slide is LAST RESORT.

---

## Step 3: Slide Planning (ALWAYS DO THIS)

**Before generating ANY slides, create a written plan.**

Create a slide plan table:

```markdown
| # | Layout | Title | Key Content | Notes |
|---|--------|-------|-------------|-------|
| 1 | title-slide | [Title] | [Subtitle, author] | Opening |
| 2 | multi-card-slide | [Title] | [3-5 items] | Feature highlights |
| ... | ... | ... | ... | ... |
```

### Planning checklist
- [ ] No duplicate titles across slides
- [ ] Logical flow from slide to slide
- [ ] Appropriate layout for each content type
- [ ] Content fits the chosen layout's limits
- [ ] Batches grouped (max 5 slides each)
- [ ] **VARIETY: Content-slide <25% of total**
- [ ] **VARIETY: No 3+ consecutive same-layout slides**
- [ ] **VARIETY: Visual layouts 50%+ of presentation**
- [ ] **VARIETY: Each content-slide evaluated against decision tree**

**Present plan briefly before generating.**

---

## Step 4: Content Adaptation

For each slide:

1. **Map brand.json values to layout placeholders** (see `REFERENCE.md` for full mapping table)
2. **Write content in brand's voice** (from tone-of-voice.md)
3. **Preserve layout structure** (decorative elements, spacing, hierarchy)
4. **Follow text formatting rules**: No trailing periods on titles/bullets/labels

---

## Step 5: Batch Generation

**MAXIMUM 5 SLIDES PER BATCH. Hard limit.**

1. Generate 1-5 slides in a single PPTX
2. **STOP and review** before generating more
3. Only after validation, continue with next batch
4. Repeat until all slides generated

**CRITICAL: Every slide MUST have background explicitly set:**
```python
slide = prs.slides.add_slide(prs.slide_layouts[6])
slide.background.fill.solid()
slide.background.fill.fore_color.rgb = hex_to_rgb(BRAND_BG)
```

**Execution:**
```bash
uv run --with python-pptx==1.0.2 python << 'EOF'
# [Adapted code with brand values and content]
EOF
```

If heredoc fails (Windows): Use temp file in `.claude/skills/pptx-generator/.tmp/`, clean up immediately after.

---

## Step 6: Quality Validation (MANDATORY)

After EVERY batch, check for:

| Issue | What to Look For | Fix |
|-------|------------------|-----|
| White background | Default white instead of brand color | Add background.fill.solid() |
| Duplicate titles | Same title appearing twice | Remove duplicate text boxes |
| Spacing problems | Title too close to content | Increase Y position |
| Text overflow | Content beyond slide bounds | Reduce font size or split |
| Wrong colors | Not matching brand | Verify hex values |
| Bad punctuation | Trailing periods on titles | Remove |

If issues found: fix before continuing. If validation passes: next batch.

---

## Step 7: Output

Use output settings from config.json:

| Setting | Default | Description |
|---------|---------|-------------|
| `output.directory` | `output/{brand}` | Save location |
| `output.naming` | `{name}-{date}` | File naming pattern |
| `output.keep_parts` | `false` | Keep part files |

---

## Step 8: Combine Batches

**CRITICAL BUG: Background MUST be set when combining.**

`add_slide()` creates slides with DEFAULT WHITE BACKGROUNDS. Shape copying does NOT copy background. Must set explicitly after each slide creation.

```python
# For each slide copied from parts:
new_slide = combined.slides.add_slide(blank_layout)
new_slide.background.fill.solid()
new_slide.background.fill.fore_color.rgb = hex_to_rgb(BRAND_BG)
# Then copy shapes...
```

After combining: delete part files (user sees ONE final PPTX).

**Testing after combining:**
- [ ] Open combined PPTX
- [ ] Scroll through ALL slides
- [ ] Verify EVERY slide has correct background
- [ ] If white slides found → combination code missing background setting

---

## Related

- **Skill**: `/pptx-generator`
- **Reference**: `.claude/skills/pptx-generator/REFERENCE.md`
- **Brand setup**: `workflows/public/pptx-brand-setup.md`
- **Carousel generation**: `workflows/public/pptx-carousel-generation.md`
- **Layout management**: `workflows/public/pptx-layout-crud.md`

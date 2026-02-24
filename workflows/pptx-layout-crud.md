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

# Workflow: PPTX Layout CRUD (Explicit)

> **Type**: Explicit workflow — Follow steps precisely

## Purpose

Create, read, update, and delete cookbook layout templates for the PPTX generator.

---

## Creating New Layouts

### Step 1: Study Existing Patterns

```
Glob: .claude/skills/pptx-generator/cookbook/*.py
```

Read 2-3 layouts to understand:
- Code structure and imports
- How brand variables are used
- Decorative element patterns
- Positioning conventions

### Step 2: Design with Quality Standards

**MUST be production-ready:**
- Professional, polished appearance
- Visually engaging (not plain or generic)
- Distinctive decorative elements
- Strong visual hierarchy
- Proper use of whitespace

**Use appropriate elements:**
- Charts (pie, doughnut, bar, column)
- Images (placeholder shapes)
- Shapes (circles, rectangles, parallelograms)
- Cards (floating with shadows for depth)
- Geometric patterns (bold shapes at corners/edges)

**Avoid:**
- Plain text-only layouts
- Generic bullet points without styling
- Tiny decorative elements
- Centered-everything compositions

### Step 3: Write Layout File with Frontmatter

**CRITICAL: Frontmatter is documentation for future AI agents.**

```python
#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.11"
# dependencies = ["python-pptx==1.0.2"]
# ///
# /// layout
# name = "layout-name"
# purpose = "When to use - be specific"
# best_for = [
#     "Ideal use case 1",
#     "Ideal use case 2",
# ]
# avoid_when = [
#     "Situation 1 - and what to use instead",
#     "Situation 2 - and what to use instead",
# ]
# max_items = 5
# instructions = [
#     "Specific tip 1",
#     "Specific tip 2",
# ]
# ///
"""
LAYOUT: [Name]
PURPOSE: [When to use]

CUSTOMIZE:
- [Customizable elements]
"""
# ... implementation
```

**Required fields:** `name`, `purpose`, `best_for`, `avoid_when`, `instructions`
**Recommended:** `max_*`/`min_*` limits, `*_max_chars` character limits

**Good frontmatter** = specific and actionable
**Bad frontmatter** = vague ("use correctly", "wrong content")

### Step 4: Save to Cookbook

```
.claude/skills/pptx-generator/cookbook/{layout-name}-slide.py
```

### Step 5: Test

Generate a sample slide with the new layout.

---

## Editing Existing Layouts

1. **Find:** `Glob: .claude/skills/pptx-generator/cookbook/*{name}*.py`
2. **Read** current structure including frontmatter
3. **Modify** while preserving: script header, brand variable naming, docstring format
4. **Update frontmatter** if changes affect `best_for`, `avoid_when`, limits, or instructions
5. **Save** to same file
6. **Test** the modified layout

---

## Improving Layouts

1. **Analyze weaknesses:** Visual engagement, decorative elements, hierarchy, spacing
2. **Apply improvements:** Bold shapes, better color usage, depth (shadows/overlapping), typography sizing
3. **Preserve functionality** — don't break what works
4. **Update frontmatter** with lessons learned

---

## Deleting Layouts

```bash
rm .claude/skills/pptx-generator/cookbook/{layout-name}.py
```

---

## Previewing All Layouts

```bash
uv run .claude/skills/pptx-generator/generate-cookbook-preview.py
```

Generates `cookbook-preview.pptx` with every layout.

---

## Related

- **Skill**: `/pptx-generator`
- **Slide generation**: `workflows/public/pptx-slide-generation.md`
- **Cookbook location**: `.claude/skills/pptx-generator/cookbook/`

---
type: workflow
trigger: /{{cos.name}}-template-create
status: active
created: 2026-02-03
updated: 2026-02-18
category: meta
playbook_phase: null
related_workflows:
  - template-testing.md
project_scope: meta
last_used: null
---

# Workflow: Template Creation

## Purpose

Create a new Templater template for a repeating file structure. Templates reduce friction for recurring artifact types — session logs, task briefs, decision records, etc.

## When to Use

- A file structure has been created manually 3+ times
- A new artifact type is being standardized
- Triggered via `/{{cos.name}}-template-create`

---

## Step 1: Define the Template

Answer before writing code:
- What is this template for? (one sentence)
- What are the required fields? (must be present every time)
- What are the optional fields? (present sometimes, with defaults)
- What's the output filename pattern?
- Where does the file live?

---

## Step 2: Write Frontmatter

```yaml
---
# Template metadata (for documentation purposes)
template_type: {type}
version: 1.0
created: {date}
required_fields:
  - {field}
optional_fields:
  - {field}: {default}
filename_pattern: "{YYYY-MM-DD}-{slug}.md"
default_location: "{folder/path}"
---
```

---

## Step 3: Write the Template Body

Use Templater syntax for dynamic fields:

```
<%* const title = await tp.system.prompt("Title") %>
<%* const date = tp.date.now("YYYY-MM-DD") %>
---
title: <% title %>
date: <% date %>
---

# <% title %>
```

**Key rules**:
- Required fields always prompt (never silently default)
- Optional fields use `|| "default"` pattern
- Dates use `YYYY-MM-DD` format (ISO 8601)
- Times use `HH-mm` (hyphen, not colon — Windows filename safe)
- Async functions always use `await`

---

## Step 4: Add EXTENSION_POINT Markers

Mark where future additions belong:

```markdown
<!-- EXTENSION_POINT: additional-metadata -->

<!-- EXTENSION_POINT: new-sections -->
```

At minimum: one in the frontmatter block, one in the body.

---

## Step 5: Test

Run `template-testing.md` before declaring the template production-ready.

---

## Step 6: Register

Add to `templates/INDEX.md`:

```markdown
| `{filename}.md` | {brief description} | {trigger or usage} |
```

---

## Common Patterns

### Sequential IDs

```
<%* const id = await tp.user.nextTaskId(app) %>
```

(Requires user script in `dea-utils.js` or equivalent)

### Enum selection

```
<%* const priority = await tp.system.suggester(
  ["High", "Medium", "Low"],
  ["high", "medium", "low"],
  false,
  "Priority"
) %>
```

### Conditional section

```
<%* if (priority === "high") { %>
## Escalation
This is high priority — ensure {{user.name}} is aware.
<%* } %>
```

---

## Related

- **Template testing**: `workflows/public/template-testing.md`
- **Templates directory**: `templates/public/`
- **Template index**: `templates/INDEX.md`

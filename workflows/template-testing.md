---
type: workflow
trigger: manual
status: active
created: 2026-02-03
category: meta
playbook_phase: null
related_workflows:
  - template-creation.md
related_templates:
  - workflow-explicit.md
  - workflow-goal.md
project_scope: meta
updated: 2026-02-18
last_used: null
---

# Workflow: Template Testing

## Purpose

Quality assurance process for validating that templates work correctly before production use.

## Prerequisites

- [ ] Template file created
- [ ] Templater plugin enabled in Obsidian
- [ ] User scripts configured
- [ ] Test location available (or can create test files safely)

## Testing Checklist

Use this comprehensive checklist to validate every new or modified template.

---

### 1. Syntax Validation

Ensure Templater syntax is correct and error-free:

- [ ] **Template renders without errors**
  - Open template file in Obsidian
  - Trigger Templater (hotkey or command palette)
  - No error notifications appear
  - Template preview shows (if available)

- [ ] **All tags properly closed**
  - Every `<% %>` tag has opening and closing
  - Every `<%* %>` block has opening and closing
  - Nested tags/blocks are correctly paired
  - No orphaned `<` or `>` characters

- [ ] **No undefined variables**
  - All variables used in template are defined
  - Variables defined before use in template flow
  - No typos in variable names

- [ ] **No undefined functions**
  - All functions exist in the user scripts file
  - Functions are properly exported (check module.exports)
  - Correct function names (no typos)
  - Proper capitalization (JavaScript is case-sensitive)

- [ ] **Async functions use await**
  - `nextErrorNumber()` called with `await`
  - `nextSessionNumber()` called with `await`
  - `generateTaskId()` called with `await`
  - App parameter passed where needed

**If syntax validation fails**: Fix errors in template code, re-run checklist from beginning

---

### 2. Field Population

Verify all fields prompt correctly and populate as expected:

- [ ] **All required fields prompt for input**
  - Every required field has a prompt
  - Prompts appear when template is applied
  - Prompts are in correct order

- [ ] **Prompts have clear labels**
  - Label text is descriptive and unambiguous
  - User knows what to enter

- [ ] **Suggester options work correctly**
  - Dropdown/selection prompts appear as expected
  - All options are listed
  - Selecting option returns correct value

- [ ] **Optional fields use appropriate defaults**
  - Default values are sensible
  - Omitting optional field doesn't break template

- [ ] **Conditional sections render correctly**
  - Sections appear when condition is true
  - Sections hidden when condition is false
  - Logic operators work as expected

**Test with edge cases**:
- [ ] Empty input (if allowed)
- [ ] Very long input (100+ characters)
- [ ] Special characters in input (hyphens, apostrophes, numbers)

---

### 3. File Creation

Validate filename and location are correct:

- [ ] **Generated filename matches naming convention exactly**
- [ ] **File created in correct directory**
- [ ] **No invalid characters in filename**
  - No colons `:` (Windows doesn't allow in filenames)
  - No slashes `/` or backslashes `\`
  - Use hyphens `-` instead of spaces or underscores
- [ ] **Date/time formats are correct**
  - Dates: `YYYY-MM-DD`
  - Times: `HH-mm` (hyphen, not colon)
- [ ] **Sequential numbers are zero-padded correctly**

---

### 4. Metadata Validation

Check YAML frontmatter and metadata fields:

- [ ] **YAML frontmatter is valid** (if present)
  - Frontmatter starts with `---` on first line
  - Frontmatter ends with `---` on its own line
  - Proper indentation (2 spaces for nested items)

- [ ] **All metadata fields populated correctly**
  - No `<undefined>` or `null` values

- [ ] **Date fields use ISO 8601 format** (`YYYY-MM-DD`)

- [ ] **Enum fields match allowed values**

**Common YAML errors**:
- [ ] No tabs (use spaces only)
- [ ] Strings with colons wrapped in quotes
- [ ] Arrays use hyphen-space format (`- item`)

---

### 5. Content Quality

- [ ] **All sections present** (compare against template body)
- [ ] **Headers properly formatted**
- [ ] **No broken Markdown syntax**
- [ ] **Cross-links use correct relative paths**
- [ ] **Links to other files resolve correctly**

---

### 6. Extensibility

- [ ] **EXTENSION_POINT markers present**
- [ ] **New optional fields can be added without breaking template**
- [ ] **Existing files not affected by template updates**

---

### 7. Real-World Testing

- [ ] **Template used in actual workflow** (not just a test)
- [ ] **Generated file meets quality standards**
- [ ] **No friction points or confusion during use**

---

### 8. Integration Testing

- [ ] **Works with Obsidian plugins** (as applicable)
- [ ] **File appears in file explorer correctly**
- [ ] **Test search/queries find the file**
- [ ] **Git operations work** (if file is versioned)

---

## Pass Criteria

**Template is production-ready when:**
- [ ] ALL items in ALL sections above are checked and passing
- [ ] At least one real-world test completed successfully
- [ ] Documentation updated (`templates/INDEX.md`)

## Failed Test Response

**If ANY test fails:**

1. Document failure
2. Fix issue in template (address root cause, not symptoms)
3. Re-run FULL testing checklist from Section 1
4. Update template version history

**Never skip tests** — broken templates waste more time than the testing saves.

---

## Related

- Workflow: [template-creation.md](template-creation.md)
- Templates directory: `templates/public/`

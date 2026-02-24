---
type: workflow
trigger: automatic
status: active
created: 2026-02-04
category: job
playbook_phase: null
related_workflows:
  - job-search.md
  - job-quick-ops.md
related_templates:
  - job-profile.md
  - job-vocabulary.md
project_scope: job-search
updated: 2026-02-18
last_used: null
---

# Workflow: Job Onboarding

## Purpose

Build a comprehensive job search profile for new users through structured interview. Creates `profile.md` and `Vocabulary.md` — the foundation for all CV tailoring.

## Philosophy

**Rich source material enables surgical tailoring.** Without detailed profile data, CV crafting becomes guesswork. This interview extracts positioning, achievements, targets, and voice to power effective applications.

## Entry Trigger

The `/{{cos.name}}-job` skill routes here when `profile.md` doesn't exist. Context loading is handled by the skill — this workflow proceeds directly with the interview.

---

## Pre-Interview: CV Import (Optional)

**If user has existing CV/resume/LinkedIn export:**

1. Ask: "Do you have an existing CV or resume I can read first?"
2. If yes:
   - [ ] Read the document(s)
   - [ ] Extract: name, roles, companies, dates, education, skills
   - [ ] Create draft profile.md with extracted data
   - [ ] Note gaps to clarify in interview
3. If no:
   - [ ] Proceed to Phase 1 with blank slate

**CV Import accelerates the interview** — instead of asking for every detail, focus on clarifying and adding strategic sections.

---

## Phase 1: Foundation Interview (30-45 min)

**Goal:** Extract core positioning data.

### Domain 1: Executive Positioning

Ask via AskUserQuestion:

**Batch 1.1:**
- "In one sentence, what do you do professionally?"
- "Who do you do it for? (clients, employers, industries)"
- "What's your signature outcome or differentiator?"

→ Write: Executive Positioning + Core Differentiator sections

### Domain 2: Professional Background

For each role (most recent first, up to 5):

**Batch 1.2 (per role):**
- "Company name and your title?"
- "Dates (start - end)?"
- "What was your scope?" (Options: team size, budget, geography, P&L)
- "What did you accomplish?" (push for quantified outcomes: $, %, timeline)
- "Why did you leave?" (Optional - for framing)

→ Write: Professional Background section

### Domain 3: Education & Credentials

**Batch 1.3:**
- "Highest degree, institution, year?"
- "Other degrees or certifications relevant to your target roles?"
- "Languages and proficiency level?"

→ Write: Education + Languages sections

### Domain 4: Core Competencies

**Batch 1.4:**
- "What are your 4-5 functional strengths?"
- For each selected: "What specific skills fall under this?"

→ Write: Core Competencies section (clustered)

### Domain 5: Wins/Deals Summary

**Batch 1.5:**
- "What are your 3-5 biggest professional accomplishments?"
- For each: "Quantify the impact" ($$, %, timeline, scale, outcome)

→ Write: Deal Summary or Wins Summary section

**Phase 1 Output:** `profile.md` with Layer 1 (~3-4 pages)

---

## Phase 2: Depth Interview (30-45 min)

**Goal:** Add strategic targeting + objection handling.

### Domain 6: Target Profile

**Batch 2.1:**
- "What 3-5 job titles are you pursuing?"
- "What seniority level?"
- "What industries?"
- "Any industries you want to AVOID?"

**Batch 2.2:**
- "Primary target geography?"
- "Open to other regions?"
- "Work model preference?" (On-site, Hybrid, Remote, Flexible)

**Batch 2.3:**
- "Salary floor — what's the minimum you'd accept?"
- "Target range?"
- "What matters more: base, bonus, equity, or carry/co-invest?"

→ Write: Target Profile section (Roles, Seniority, Industries, Geographies, Salary)

### Domain 7: Career Goals

**Batch 2.4:**
- "Where do you want to be in 6-12 months?"
- "Where do you want to be in 2-5 years?"
- "What would make this job search a success?"

→ Write: Career Goals section (short-term + long-term)

### Domain 8: Red Flags & Mitigations

**Batch 2.5:**
- "What might disqualify you on paper?" (career gap, industry switch, location, etc.)
- For each: "What's your answer when asked about this?"
- "What interview questions do you dread?"

→ Write: Red Flags & Mitigations table

### Domain 9: Contextual Notes

**Batch 2.6:**
- "Visa/work authorization status?"
- "Notice period at current job?"
- "Relocation constraints?"
- "Anything else a recruiter should know?"

→ Write: Contextual Notes section

**Phase 2 Output:** `profile.md` with Layer 2 complete (~5-7 pages)

---

## Phase 3: Voice Calibration (15-20 min)

**Goal:** Build Vocabulary.md for consistent tone.

### Domain 10: Seniority Register

**Batch 3.1:**
- "What level are you targeting?" (confirms from Domain 6)
- "How do you want to come across?" (Commanding, Collaborative, Technical authority, Warm professional, etc.)

→ Write: Seniority Register section

### Domain 11: Tone Pillars

**Batch 3.2:**
- "Select 4-5 words that describe how you want your applications to sound."

→ Write: Tone Pillars section

### Domain 12: Action Verbs

**Batch 3.3:**
- "What verbs describe how you work?" (select per category relevant to candidate)

→ Write: Preferred Action Verbs section (clustered)

### Domain 13: Industry Terminology

**Batch 3.4:**
- "What jargon is expected in your target roles?"

→ Write: Industry Terminology section

### Domain 14: Avoid List

**Batch 3.5:**
- "What words or phrases should you NOT use?" (generic: "responsible for", "passionate", "proven track record", etc.)
- "Any industry-specific terms that are overused?"

→ Write: Avoid List table (word | why | use instead)

**Phase 3 Output:** `Vocabulary.md` complete (~2-3 pages)

---

## Post-Interview: Setup Completion

After all phases:

1. Create empty `tracker.md` from template
2. Create empty `applications/` folder
3. Confirm all files exist:
   - [ ] `profile.md`
   - [ ] `Vocabulary.md`
   - [ ] `tracker.md`
   - [ ] `applications/`

4. Summary to user:
   - Profile sections completed
   - Vocabulary calibrated
   - Ready for job search

5. Offer next steps:
   - "Start applying?" → Route to job-search.md
   - "Review/edit profile first?" → Open profile.md
   - "Done for now" → Exit

---

## Pause & Resume

User can exit at any phase boundary:
- Progress saves after each batch
- Resume continues from last completed domain
- Track progress in profile.md frontmatter:
  ```yaml
  onboarding_status: in_progress
  last_completed: domain_5
  ```

---

## Output

- `portfolio/job-search/profile.md` — comprehensive positioning document
- `portfolio/job-search/Vocabulary.md` — tone/register guide
- `portfolio/job-search/tracker.md` — empty, ready for use
- `portfolio/job-search/applications/` — empty folder

## Quality Gates

Before onboarding is complete:

- [ ] Executive positioning is specific (not generic)
- [ ] Professional background has quantified outcomes
- [ ] Target profile is explicit (roles, seniority, geography, salary)
- [ ] Red flags have mitigations prepared
- [ ] Vocabulary matches target seniority level
- [ ] Avoid list includes common weak phrases

## Related

- Main workflow: `workflows/public/job-search.md`
- Skill: `/{{cos.name}}-job`
- Profile template: `templates/public/job-profile.md`
- Vocabulary template: `templates/public/job-vocabulary.md`
- Tracker template: `templates/public/job-tracker.md`

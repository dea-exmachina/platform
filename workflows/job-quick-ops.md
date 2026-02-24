---
type: workflow
workflow_type: explicit
trigger: skill
skill: /{{cos.name}}-job
status: active
created: 2026-02-05
updated: 2026-02-18
category: job
playbook_phase: null
related_workflows:
  - job-search.md
  - job-onboarding.md
related_templates:
  - job-tracker.md
project_scope: job-search
last_used: null
---

# Workflow: Job Quick Ops (Explicit)

> **Type**: Explicit workflow — Follow steps precisely

## Purpose

Fast-access job operations: check-in on new recommendations, generate CVs for approved jobs, and manual batch processing.

**Context**: The `/{{cos.name}}-job` skill routes here for quick operations. For the full job search lifecycle, see `job-search.md`. For new user onboarding, see `job-onboarding.md`.

## Tracker Architecture

The job tracker (Google Sheet or equivalent) has two sections:
- **Main**: Only Maybe, Apply, and Pending jobs
- **Skipped**: All jobs scored below threshold

## Tracker Schema

| Col | Header | Content |
|-----|--------|---------|
| A | Job ID | `JOB-NNN` (auto-increment) |
| B | Date | `YYYY-MM-DD` |
| C | Score | Integer (0-100) — empty until scored |
| D | Rec | Pending / Apply / Maybe / Skip |
| E | Company | Company name |
| F | Title | Job title |
| G | Location | Location |
| H | Key Match | Strongest alignment points |
| I | Key Gap | Main concerns |
| J | Action | User fills (Apply Now, Hold, Skip, Ignore) |
| K | URL | Job posting URL |
| L | Folder | `applications/Company/Title/` |
| M | CV | CV generated (Yes / empty) |
| N | Flag | Source or notes |

**Lifecycle**: Script adds rows as `Pending` → {{cos.name}} scores and updates to `Apply`/`Maybe`/`Skip` → Skip rows move to Skipped section

---

## Mode: Check-In (Default)

Shows new recommended jobs from the tracker. Processes any pending batches first.

### Steps

#### Step 0: Process Pending Batches

Before showing jobs, check for and process any pending batches:

1. **Run batch processor**:
   ```bash
   python tools/scripts/job_tracker.py
   ```
   This script:
   - Fetches pending job batches
   - Extracts full job descriptions
   - Auto-assigns Job IDs
   - Writes unscored rows to tracker (Rec = "Pending")
   - Saves JD files to `portfolio/job-search/pending/` for scoring
   - Deduplicates against existing entries

2. **Report batch results** (if any processed):
   ```
   Processed X batches -> Y new jobs added, Z JDs saved to pending/
   ```

3. **If no pending batches**: Continue silently to Step 0.5

#### Step 0.5: Score Pending JDs

Run the automated scorer against the pending directory:

1. **Run scorer**:
   ```bash
   python tools/scripts/job_scorer.py \
     --dir portfolio/job-search/pending/ \
     --output portfolio/job-search/pending/scores.json
   ```

2. **Push scores to tracker**:
   ```bash
   python tools/scripts/job_score_update.py portfolio/job-search/pending/scores.json
   ```
   Updates Score, Rec, Key Match, Key Gap. Moves Skip rows to Skipped section.

3. **Move scored files to archive**:
   Move all `.md` files from `portfolio/job-search/pending/` to `portfolio/job-search/pending/scored/`.

4. **Report**:
   ```
   Scored X jobs: Y Apply, Z Maybe, W Skipped
   ```

5. **If no pending files**: Continue silently to Step 1.

**Fallback** (if automation fails): {{cos.name}} scores manually using `profile.md` + hard disqualifier checklist.

#### Step 1: Read Tracker

1. Read tracker (Google Sheet or local file)
2. Filter rows where Rec = "Apply" or "Maybe" AND Action = empty
3. Output summary table:
   ```
   **X new jobs worth reviewing:**

   | Job ID | Score | Company | Title | Location | Rec |
   |--------|-------|---------|-------|----------|-----|
   | JOB-NNN | 85 | {Company} | {Title} | {Location} | Apply |

   Mark "Apply Now" in the Action column, then run `/{{cos.name}}-job apply` to generate CVs.
   ```

4. **If no new jobs**: "No new recommended jobs."

---

## Mode: Apply

Generates CVs for jobs marked "Apply Now" in the tracker. Includes {{cos.name}} rescore gate to catch false positives from automated scoring.

### Steps

1. **Read tracker**, filter rows where:
   - Action = "Apply Now"
   - CV = empty (not yet generated)

2. **For each job**:
   a. **Get JD**: Check `portfolio/job-search/pending/scored/` for existing JD file. If not found, fetch via WebFetch.
   b. **Save JD**: Create application folder at `portfolio/job-search/{Folder}`, save JD as `jd.md`
   c. **{{cos.name}} Rescore Gate**:
      - Read full JD + `profile.md` + `Vocabulary.md`
      - Produce deep fit assessment (beyond keyword matching)
      - If rescore >= 60%: proceed to step d
      - If rescore < 60%: Flag the row and skip CV generation. Continue to next job.
   d. **JD Analysis** from `job-search.md` Section 1
   e. **Produce `tailoring-map.json`** based on JD analysis + profile + vocabulary
   f. **Run CV generation**: `python tools/scripts/cv_tailor.py <tailoring-map.json> <output-dir>`
   g. **Quality check**: Verify CV page count, no orphaned headings; verify cover letter if generated
   h. **Update tracker**: CV = "Yes"

3. **Output summary**:
   ```
   ## Apply Batch Complete

   **CVs generated:** X
   **Flagged for review:** Y

   ### Generated:
   | Job ID | Company | Title | Score |

   ### Flagged (rescore < 60%):
   | Job ID | Company | Title | Rescore | Reason |

   Flagged jobs: Clear the Flag column and re-mark "Apply Now" to force CV generation, or change Action to "Skip".
   ```

### Prerequisites
- `profile.md` and `Vocabulary.md` must exist (route to onboarding if not)
- Tracker accessible

---

## Mode: Batch (Force Processing)

Manually run batch processing. Normally runs automatically in Check-In mode.

```bash
python tools/scripts/job_tracker.py
```

The script handles:
- Batch fetching from configured sources
- JD extraction
- Job ID assignment
- Folder path generation
- Deduplication
- Tracker updates

---

## Related

- **Skill**: `/{{cos.name}}-job`
- **Full lifecycle**: `workflows/public/job-search.md`
- **Onboarding**: `workflows/public/job-onboarding.md`
- **Pending JDs**: `portfolio/job-search/pending/`
- **Profile**: `portfolio/job-search/profile.md`
- **Vocabulary**: `portfolio/job-search/Vocabulary.md`

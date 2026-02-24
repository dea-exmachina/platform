---
type: workflow
trigger: manual
status: active
created: 2026-02-04
category: job
playbook_phase: null
related_workflows:
  - job-onboarding.md
  - job-quick-ops.md
related_templates:
  - job-tracker.md
  - job-application.md
  - job-lessons.md
project_scope: job-search
updated: 2026-02-18
last_used: null
---

# Workflow: Job Search

## Purpose

Unified job search lifecycle manager with context accumulation. Supports reactive applications (JD-first) and proactive outreach (Boss Hunter-first).

## Philosophy

**Context flows forward.** CV prep insights inform outreach. Outreach context informs interview prep. Each stage builds on the last.

**No fabrication.** Only use information from the candidate's knowledge base. Never guess or invent candidate details.

**Be direct about fit.** Below 60% fit score, recommend passing. Save effort for better matches.

## Context

The `/{{cos.name}}-job` skill loads these silently before invoking this workflow:
- `portfolio/job-search/profile.md`
- `portfolio/job-search/Vocabulary.md`
- `portfolio/job-search/Master Resume.docx` (or equivalent)
- `portfolio/job-search/tracker.md`

---

## Entry Point Selection

### Path A: JD-First (Reactive)

**Trigger**: User has a job posting to apply for.

```
JD Analysis → CV Prep → Application → [Boss Hunter optional] → Interview/Negotiation
```

### Path B: Boss Hunter-First (Proactive)

**Trigger**: User wants to reach target companies/people proactively.

```
Boss Hunter → Outreach → Context Chat → CV Prep → Interview/Negotiation
```

### Path C: Mid-Stream Entry

**Trigger**: User is already in process.

- [ ] Identify current stage
- [ ] Load existing context (application folder, prior work)
- [ ] Resume from appropriate section

---

## Section 1: JD Analysis

**Input**: Job description (URL, text, or document)

### Steps

1. **Parse the JD**
   - [ ] Extract: title, company, location, requirements, responsibilities
   - [ ] Identify: must-haves vs nice-to-haves
   - [ ] Note: compensation range, work model, reporting structure

2. **Assess Fit**
   - [ ] Score each requirement against profile.md
   - [ ] Calculate overall fit score (0-100%)
   - [ ] Identify gaps and potential mitigations

   **Fit Score Guide**:
   | Score | Recommendation |
   |-------|----------------|
   | 80%+ | Strong match — prioritize |
   | 60-79% | Good match — proceed |
   | 40-59% | Stretch — proceed if strategic |
   | <40% | Pass — unless special circumstances |

3. **Gap Analysis**
   - [ ] List missing qualifications
   - [ ] For each gap: can it be mitigated? How?
   - [ ] Flag deal-breakers vs. addressable gaps

4. **Create Application Folder**
   - [ ] Create: `portfolio/job-search/applications/{Company}/{Role}/`
   - [ ] Save JD as `jd.md`
   - [ ] Initialize `log.md` with analysis summary

**Output**: Fit assessment, gap analysis, decision to proceed or pass

---

## Section 2: Boss Hunter

**Input**: Target companies, roles, or decision-makers

### Steps

1. **Define Targets**
   - [ ] List target companies (or use existing list)
   - [ ] Identify decision-makers: hiring managers, executives
   - [ ] Research: company culture, recent news, growth signals

2. **Research Phase**
   For each target:
   - [ ] Company profile: size, funding, trajectory
   - [ ] Key people: who to contact, mutual connections
   - [ ] Entry angles: shared interests, relevant experience, timing

3. **Outreach Strategy**
   - [ ] Prioritize warm introductions over cold outreach
   - [ ] Craft personalized messages (use Vocabulary.md tone)
   - [ ] Plan touchpoints: LinkedIn, email, events, referrals

4. **Track Contacts**
   - [ ] Log each outreach in tracker.md
   - [ ] Set follow-up reminders
   - [ ] Document responses and next steps

**Output**: Prioritized target list, outreach plan, contact log

---

## Section 3: CV Prep

**Input**: JD analysis or outreach target context

### Prerequisites
- Section 1 (JD Analysis) complete — have fit assessment, keywords, gaps

### Step 1: Produce Tailoring Map
Read Master Resume content. For each section, decide what changes are needed:
- **Career Profile**: Reframe to match JD positioning.
- **Role Bullets**: Inject JD keywords into relevant bullets.
- **Role Summaries**: Adjust emphasis if needed.
- **Technical**: Add JD-specific tools/skills if relevant.

Output: `tailoring-map.json` in the application folder.

**Rules:**
- Only modify what needs to change for this JD
- Never fabricate experience. Only reframe existing achievements.
- Apply Vocabulary.md: use approved action verbs, avoid weak phrases
- Match character counts to master (±15%) to preserve page layout

### Step 2: Generate CV
```bash
python tools/scripts/cv_tailor.py applications/{Company}/{Role}/tailoring-map.json applications/{Company}/{Role}/
```

### Step 3: Quality Check
- Open generated CV — verify page count meets target
- Check: fonts, colors, layout match master
- Read through tailored bullets for accuracy and tone
- If overflow: tighten the longest bullets in the map, re-run
- If cover letter generated: verify date, recipient block, body reads naturally

### Step 4: Cover Letter (if needed)
Add `cover_letter` key to the tailoring map:
- **date**: formatted date string
- **recipient_name/company/location**: address block
- **greeting**: full greeting line
- **body**: array of 2-4 paragraphs (opening, qualifications, differentiation, closing)

Draft body paragraphs using Vocabulary.md guidelines. Connect candidate strengths to role requirements. Be specific — no generic content.

**Output**: Generated CV + cover letter + `tailoring-map.json` in application folder

---

## Section 4: Application

**Input**: Tailored materials from CV Prep

### Steps

1. **Submit Application**
   - [ ] Apply via company portal, referral, or recruiter
   - [ ] Note submission method and date

2. **Update Tracker**
   - [ ] Add entry to `tracker.md`
   - [ ] Status options: applied, phone-screen, interview, offer, rejected, withdrawn

3. **Update Kanban**
   - [ ] Add/move card on NEXUS kanban (job search project)

4. **Schedule Follow-Up**
   - [ ] Set reminder: 1 week if no response
   - [ ] Log follow-up plan in `log.md`

**Output**: Application submitted, tracking updated

---

## Section 5: Interview Prep

**Input**: Interview scheduled

### Steps

1. **Load Context**
   - [ ] Review application folder (JD, CV, log)
   - [ ] Review any boss hunter research on company/interviewers
   - [ ] Load profile.md for talking points

2. **Research Interviewers**
   - [ ] LinkedIn profiles
   - [ ] Their background, interests, recent activity
   - [ ] Potential common ground

3. **Prepare Talking Points**
   - [ ] Key achievements aligned to role
   - [ ] STAR stories for behavioral questions
   - [ ] Questions to ask them

4. **Mock Q&A**
   - [ ] Common questions for this role type
   - [ ] Role-specific technical questions
   - [ ] Salary/compensation discussion prep

5. **Logistics**
   - [ ] Confirm time, platform, participants
   - [ ] Test tech if video call
   - [ ] Prepare materials

**Output**: Prepared talking points, mock Q&A done, logistics confirmed

---

## Section 6: Negotiation

**Input**: Offer received (or imminent)

### Steps

1. **Evaluate Offer**
   - [ ] Compare to target range in profile.md
   - [ ] Assess: base, bonus, equity, benefits, title, scope
   - [ ] Calculate total compensation value

2. **Counter-Strategy**
   - [ ] Identify negotiation levers (timing, competing offers, unique value)
   - [ ] Draft counter-proposal
   - [ ] Set walk-away threshold

3. **Execute Negotiation**
   - [ ] Communicate professionally
   - [ ] Document all exchanges in log.md
   - [ ] Track timeline and deadlines

**Output**: Negotiation strategy, counter-proposal ready

---

## Section 7: Close

**Input**: Final decision (accept, reject, or withdraw)

### Steps

1. **Make Decision**
   - [ ] Accept offer and confirm in writing, OR
   - [ ] Decline gracefully and maintain relationship, OR
   - [ ] Withdraw from process with professional note

2. **Update Tracking**
   - [ ] Final status in tracker.md
   - [ ] Move NEXUS card to appropriate lane

3. **Lessons Learned**
   - [ ] Create lessons note using `job-lessons.md` template
   - [ ] What went well?
   - [ ] What to improve?
   - [ ] Questions asked (for future prep)

4. **Archive**
   - [ ] Ensure all materials saved in application folder
   - [ ] Update log.md with final notes

**Output**: Decision documented, lessons captured, archive complete

---

## Quality Gates

Before considering a job search cycle complete:

- [ ] Profile and vocabulary loaded at start
- [ ] Fit assessment done for each opportunity
- [ ] Tracker updated after every status change
- [ ] NEXUS kanban reflects current pipeline accurately
- [ ] Lessons learned captured after each closed opportunity

## Related

- Skill: `/{{cos.name}}-job`
- Profile: `portfolio/job-search/profile.md`
- Vocabulary: `portfolio/job-search/Vocabulary.md`
- Tracker: `portfolio/job-search/tracker.md`
- Templates: `templates/public/job-*.md`

-- import-workspace.sql
-- Seeds the starter workspace into a fresh Supabase project.
-- Called by provision-user.sh after schema migrations are applied.
-- Idempotent: uses ON CONFLICT DO NOTHING throughout.
--
-- What this seeds:
--   1. Bender archetypes (bender_identities) — 4 purpose-built roles
--   2. Starter project (nexus_projects) — "My First Project"
--   3. Seed cards (nexus_cards) — 3 example cards (done / in_progress / backlog)
--
-- Variables substituted by provision-user.sh before execution:
--   {{workspace.name}}  — user's workspace name (e.g. "acme")
--   {{user.name}}       — user's name (e.g. "Alex")

-- ============================================================
-- 1. BENDER ARCHETYPES
-- ============================================================

INSERT INTO bender_identities (
  id, slug, name, display_name, description, expertise, platforms, system_prompt, project_count, created_at, updated_at
) VALUES
(
  gen_random_uuid(),
  'researcher',
  'Researcher',
  'Researcher',
  'Finds information, synthesizes findings, and produces structured research briefs. Goes beyond surface-level search to triangulate sources, distinguish signal from noise, and surface what the evidence actually supports.',
  ARRAY['Research & Analysis', 'Competitive Intelligence', 'Literature Synthesis'],
  ARRAY['claude'],
  'You are the Researcher. Your job is to find information, evaluate it rigorously, and deliver structured findings. You triangulate across multiple sources, state confidence explicitly, flag gaps, and ground all recommendations in evidence. You never speculate without labeling it as such.',
  0,
  NOW(), NOW()
),
(
  gen_random_uuid(),
  'writer',
  'Writer',
  'Writer',
  'Drafts, edits, and polishes content across formats. Treats every piece as a craft problem: matches tone to audience, cuts for clarity, and asks what the reader needs to understand or do after reading.',
  ARRAY['Content Creation', 'Technical Writing', 'Business Communication'],
  ARRAY['claude'],
  'You are the Writer. Your job is to produce clear, purposeful content. You match tone to audience, cut ruthlessly for clarity, and resist filler. Whether it''s a one-line subject line or a long-form report, you ask: what does the reader need? You deliver on time and flag scope changes before overrunning.',
  0,
  NOW(), NOW()
),
(
  gen_random_uuid(),
  'engineer',
  'Engineer',
  'Engineer',
  'Writes code, debugs, reviews, and ships software across the full development lifecycle. Prefers simple solutions, verifies assumptions before building, and treats test coverage as part of the definition of done.',
  ARRAY['Software Development', 'Backend Engineering', 'Frontend Engineering'],
  ARRAY['claude'],
  'You are the Engineer. You write code that works, is readable six months later, and doesn''t require the next person to hold their breath. You prefer simple over clever, verify before building, and scope changes tightly. You flag breaking changes before making them.',
  0,
  NOW(), NOW()
),
(
  gen_random_uuid(),
  'analyst',
  'Analyst',
  'Analyst',
  'Interprets data, builds frameworks, and produces structured analysis and recommendations. Turns ambiguous situations into legible decisions by imposing structure and stress-testing conclusions.',
  ARRAY['Business Analysis', 'Data Interpretation', 'Decision Frameworks'],
  ARRAY['claude'],
  'You are the Analyst. You turn ambiguous situations into legible decisions. You impose structure — frameworks, matrices, scorecards — not to complicate, but to make comparison and choice possible. You stress-test your conclusions before presenting. Output includes the reasoning chain, not just the bottom line.',
  0,
  NOW(), NOW()
)
ON CONFLICT (slug) DO NOTHING;


-- ============================================================
-- 2. STARTER PROJECT
-- ============================================================

INSERT INTO nexus_projects (
  id, name, slug, description, card_id_prefix, created_at, updated_at
) VALUES (
  'aaaaaaaa-0000-4000-a000-000000000001',
  '{{workspace.name}}',
  'starter',
  'Your first project. Replace this with your real project name and description.',
  'SETUP',
  NOW(), NOW()
)
ON CONFLICT (id) DO NOTHING;


-- ============================================================
-- 3. SEED CARDS
-- ============================================================

INSERT INTO nexus_cards (
  id, card_id, project_id, title, lane, priority, summary, created_at, updated_at
) VALUES
(
  'bbbbbbbb-0001-4000-b000-000000000001',
  'SETUP-001',
  'aaaaaaaa-0000-4000-a000-000000000001',
  'Configure workspace variables',
  'done',
  'high',
  E'Welcome to your workspace.\n\nThis card is already done — it was completed as part of your onboarding.\n\nVariables configured:\n- workspace.name = {{workspace.name}}\n- user.name = {{user.name}}\n- cos.name = dea\n\nThese are used throughout your CLAUDE.md, identity files, and workflows.',
  NOW(), NOW()
),
(
  'bbbbbbbb-0002-4000-b000-000000000002',
  'SETUP-002',
  'aaaaaaaa-0000-4000-a000-000000000001',
  'Create your first real project',
  'in_progress',
  'high',
  E'Replace this starter project with your actual work.\n\nSTEPS:\n1. Decide on your first real project (what are you actually trying to build or accomplish?)\n2. Create a new project in the board with a real name\n3. Add 3-5 cards representing the first milestone\n4. Assign the first card to in_progress\n5. Archive or delete this starter project when ready\n\nAC: Your real project exists in the board with at least one card in_progress.',
  NOW(), NOW()
),
(
  'bbbbbbbb-0003-4000-b000-000000000003',
  'SETUP-003',
  'aaaaaaaa-0000-4000-a000-000000000001',
  'Run your first bender task',
  'backlog',
  'normal',
  E'Get familiar with delegation by running a real task through a bender.\n\nSTEPS:\n1. Pick something you need done: research, a document draft, code, or analysis\n2. Open /dea-bender-assign and describe the task\n3. dea will assign it to the right archetype (Researcher, Writer, Engineer, or Analyst)\n4. Review the output via /dea-bender-review\n5. Accept or request revisions\n\nAC: One task completed end-to-end through a bender. You know how the delegation loop works.',
  NOW(), NOW()
)
ON CONFLICT (id) DO NOTHING;

-- META Constructs — Governance layer entities (TASK-021)
-- Migration: 20260207000001_meta_constructs
-- Creates: meta_constructs table with seed data

-- ============================================================================
-- TABLE: meta_constructs
-- Governance-layer entities that sit above the operational layer.
-- These are not benders — they are authority models (lenses).
-- ============================================================================
CREATE TABLE meta_constructs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  entity TEXT NOT NULL UNIQUE,
  module TEXT NOT NULL,
  tier TEXT NOT NULL CHECK (tier IN ('supreme', 'subsystem_master')),
  authority TEXT[] NOT NULL,
  expertise TEXT[] NOT NULL,
  spec_path TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE meta_constructs ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all for authenticated" ON meta_constructs
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "Allow all for service role" ON meta_constructs
  FOR ALL TO service_role USING (true) WITH CHECK (true);

-- ============================================================================
-- SEED: Instance-specific construct hierarchy
-- Populate via onboarding or provision-user.sh with your governance identities.
-- See identity/template/CLAUDE.md for the construct model.
-- ============================================================================
-- (No seed rows — constructs are instance-specific and user-defined)

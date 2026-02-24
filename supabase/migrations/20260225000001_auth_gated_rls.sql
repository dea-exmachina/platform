-- Auth-gated RLS: replace USING (true) with USING (auth.uid() IS NOT NULL)
-- Protects against direct unauthenticated API access
-- Note: service role key bypasses RLS entirely (intentional for app server operations)

DO $$
DECLARE
  pol RECORD;
BEGIN
  FOR pol IN
    SELECT schemaname, tablename, policyname
    FROM pg_policies
    WHERE schemaname = 'public'
      AND qual = 'true'
  LOOP
    EXECUTE format(
      'ALTER POLICY %I ON %I.%I USING (auth.uid() IS NOT NULL)',
      pol.policyname, pol.schemaname, pol.tablename
    );
  END LOOP;
END $$;

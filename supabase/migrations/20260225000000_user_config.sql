-- user_config: per-user key-value store for workspace variables
-- Variables: user.name, user.email, cos.name, cos.email, workspace.name, user.role
-- Resolution: provision-time (file substitution) + runtime (app UI)

CREATE TABLE IF NOT EXISTS user_config (
  user_id    UUID REFERENCES auth.users NOT NULL,
  key        TEXT NOT NULL,
  value      TEXT NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (user_id, key)
);

ALTER TABLE user_config ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'public'
      AND tablename = 'user_config'
      AND policyname = 'Users access own config'
  ) THEN
    CREATE POLICY "Users access own config"
      ON user_config
      FOR ALL
      USING (auth.uid() = user_id)
      WITH CHECK (auth.uid() = user_id);
  END IF;
END $$;

-- Default variable seeds (inserted during provision-user.sh, not here)
-- Keys: user.name, user.email, cos.name, cos.email, workspace.name, user.role

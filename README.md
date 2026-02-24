# dea-exmachina platform

Platform infrastructure for the dea-exmachina product.

## Contents

- `supabase/migrations/` — canonical product schema. Apply to every new user instance.
- `identity/template/` — generic CoS identity template. Variables resolved at provision time.
- `workflows/` — public workflow library.
- `templates/starter-workspace/` — starter workspace artifacts for new user onboarding.
- `scripts/provision-user.sh` — idempotent provisioning script (schema + workspace + variables).
- `scripts/generate-workspace.sh` — generative onboarding (5-question conversation → personalized workspace).
- `scripts/migrate-dev-workspace.sh` — one-time migration of project data between Supabase instances.
- `docs/onboarding.md` — step-by-step user onboarding guide.

## Quick start (BYO user)

See `docs/onboarding.md` for full instructions.

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https://github.com/dea-exmachina/app&env=SUPABASE_URL,SUPABASE_SERVICE_KEY,NEXT_PUBLIC_SUPABASE_URL,NEXT_PUBLIC_SUPABASE_ANON_KEY&envDescription=Your+Supabase+project+credentials)

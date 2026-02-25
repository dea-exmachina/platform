# Self-Hosted Guide

> Deep reference for BYO (bring-your-own) deployment. For the quick-start path, see `onboarding.md`.

---

## Architecture

When you self-host, you own every layer:

```
Your Supabase project  ←  Your data, your schema, your keys
Your Vercel deployment ←  Your app instance, your domain (optional)
Your local Claude Code ←  Your identity files, personalized to you
```

The platform codebase (`dea-exmachina/app`) is shared. Each user deploys their own instance pointing at their own Supabase project. There is no shared backend, no shared database, no multi-tenant routing at the application layer.

---

## Prerequisites

| Tool | Version | Install |
|------|---------|---------|
| Node.js | 18+ | [nodejs.org](https://nodejs.org) |
| psql | any | `brew install postgresql` / `apt install postgresql-client` |
| curl | any | pre-installed on most systems |
| jq | any | `brew install jq` / `apt install jq` |
| Claude Code | latest | `npm install -g @anthropic-ai/claude-code` |

**Accounts needed:**
- [Supabase](https://supabase.com) — free tier sufficient
- [Vercel](https://vercel.com) — free tier sufficient
- [Anthropic](https://console.anthropic.com) — required for generative onboarding; optional for static workspace

---

## Step 1: Create your Supabase project

1. Go to [supabase.com](https://supabase.com) → New project
2. Choose a region close to you
3. Save the database password — you'll need it for the DB URL
4. Wait for the project to provision (~2 minutes)

From **Project Settings → API**, collect:
- **Project URL** → `NEXT_PUBLIC_SUPABASE_URL`
- **anon / public key** → `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- **service_role key** → `SUPABASE_SERVICE_KEY` (keep this secret)

From **Project Settings → Database**, collect:
- **Connection string (URI)** → used for `provision-user.sh --db-url`

---

## Step 2: Provision your database

Clone the platform repo and run the provision script:

```bash
git clone https://github.com/dea-exmachina/platform.git
cd platform

./scripts/provision-user.sh \
  --db-url "postgres://postgres:[password]@db.[ref].supabase.co:5432/postgres" \
  --workspace-name "your-workspace-name" \
  --user-name "Your Name"
```

What this does:
1. Applies all schema migrations in `supabase/migrations/` (in order, idempotent)
2. Seeds the starter workspace: 4 bender archetypes, a starter project, 3 example cards
3. Runs generative onboarding if `ANTHROPIC_API_KEY` is set in your environment

**Skip generative onboarding** (use static workspace only):
```bash
./scripts/provision-user.sh \
  --db-url "..." \
  --workspace-name "your-workspace-name" \
  --user-name "Your Name" \
  --skip-onboard
```

**Idempotent**: running twice is safe — all migrations use `IF NOT EXISTS`, all inserts use `ON CONFLICT DO NOTHING`.

---

## Step 3: Deploy the app

**Option A — Vercel deploy button (recommended):**

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https://github.com/dea-exmachina/app&env=SUPABASE_URL,SUPABASE_SERVICE_KEY,NEXT_PUBLIC_SUPABASE_URL,NEXT_PUBLIC_SUPABASE_ANON_KEY&envDescription=Your+Supabase+project+credentials)

Set all 4 environment variables when prompted.

**Option B — Manual Vercel deploy:**
```bash
git clone https://github.com/dea-exmachina/app.git
cd app
cp .env.example .env.local
# Fill in .env.local with your Supabase keys
npx vercel --prod
```

**Option C — Local development:**
```bash
git clone https://github.com/dea-exmachina/app.git
cd app
cp .env.example .env.local
# Fill in .env.local
npm install
npm run dev
# → http://localhost:3000
```

---

## Step 4: Create your auth account

The app uses Supabase Auth (email + password). Create your account directly via the Supabase dashboard:

1. Go to your Supabase project → **Authentication → Users**
2. Click **Add user → Create new user**
3. Enter your email and a password
4. Click **Create user**

Then log in to your deployed app with those credentials.

---

## Step 5: Set up your user_config

Your workspace variables (name, CoS name, etc.) are stored in the `user_config` table. Seed them via the Supabase SQL Editor:

```sql
INSERT INTO user_config (user_id, key, value) VALUES
  (auth.uid(), 'user.name',      'Your Name'),
  (auth.uid(), 'user.email',     'you@example.com'),
  (auth.uid(), 'cos.name',       'dea'),
  (auth.uid(), 'cos.email',      'dea@your-domain.com'),
  (auth.uid(), 'workspace.name', 'your-workspace-name'),
  (auth.uid(), 'user.role',      'founder')
ON CONFLICT (user_id, key) DO UPDATE SET value = EXCLUDED.value;
```

Run this while authenticated in the SQL Editor (so `auth.uid()` resolves to your user ID). Alternatively, get your user ID from **Authentication → Users** and substitute it directly.

---

## Step 6: Install Claude Code

```bash
npm install -g @anthropic-ai/claude-code
```

Point it at your workspace directory. If you ran generative onboarding, your identity files are already in `./generated-workspace/`. Copy them to your workspace root or configure Claude Code's project directory accordingly.

Your `CLAUDE.md` is the CoS boot file. It defines who your AI partner is, how it operates, and what context it holds about you and your work.

---

## Generative Onboarding (Optional but Recommended)

The generative onboarding script takes 5 questions and generates a personalized workspace using the Claude API:

```bash
export ANTHROPIC_API_KEY=sk-ant-your-key-here

./scripts/generate-workspace.sh \
  --output-dir ./my-workspace
```

**The 5 questions:**
1. What's your primary role? (founder / engineer / creator / researcher / operator)
2. What's your primary project right now? (one sentence)
3. What's slowing you down most right now?
4. What do you want to accomplish in the next 90 days?
5. What should I call you, and what should you call me?

**Output** (written to `--output-dir`):
- `CLAUDE.md` — personalized CoS identity file
- `cos-identity.md` — CoS personality tuned to your domain
- `governance.json` — autonomy level and guardrail defaults
- `user_config.json` — workspace variable values
- `first_project.json` — 3–5 real actionable cards based on your stated goal

**Import the output** into your Supabase project:
```bash
# user_config
curl -X POST "${NEXT_PUBLIC_SUPABASE_URL}/rest/v1/user_config" \
  -H "apikey: ${SUPABASE_SERVICE_KEY}" \
  -H "Authorization: Bearer ${SUPABASE_SERVICE_KEY}" \
  -H "Content-Type: application/json" \
  -d @my-workspace/user_config.json

# first_project cards — use the in-app import or SQL Editor
```

**Fallback**: If you skip onboarding or have no API key, the static starter workspace (4 generic bender archetypes, 3 example cards) remains in place. The product works fully; it's just not personalized.

---

## Environment Variables Reference

| Variable | Required | Description |
|----------|----------|-------------|
| `NEXT_PUBLIC_SUPABASE_URL` | ✅ | Your Supabase project URL |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | ✅ | Supabase anon/public JWT — safe for browser |
| `SUPABASE_SERVICE_KEY` | ✅ | Supabase service_role key — server-side only, keep secret |
| `ANTHROPIC_API_KEY` | optional | Required for generative onboarding only |
| `GITHUB_TOKEN` | optional | For vault/repo integrations |
| `GITHUB_OWNER` | optional | GitHub username or org |
| `GITHUB_REPO` | optional | Vault repo name |

Copy `.env.example` to `.env.local` (for local dev) or set these in Vercel's Environment Variables dashboard (for deployed instances).

---

## Custom Domain (Optional)

1. In Vercel: **Project → Settings → Domains** → Add your domain
2. In your DNS provider: add the CNAME record Vercel gives you
3. Vercel handles TLS automatically

---

## Migrations: Keeping Up to Date

When the platform ships schema updates, apply them to your project:

```bash
# Pull latest platform repo
cd platform && git pull

# Apply new migrations only (idempotent — skips already-applied ones)
./scripts/provision-user.sh --db-url "..." --skip-onboard
```

All migrations are idempotent. Running the full sequence again is safe.

---

## Troubleshooting

**`psql: command not found`**
Install the PostgreSQL client: `brew install postgresql` (macOS) or `apt install postgresql-client` (Linux).

**`could not connect to server`**
Check that your Supabase project is not paused (free tier projects pause after inactivity). Also verify your IP is allowed: Supabase → Project Settings → Database → Network restrictions.

**Migration fails with "already exists"**
All migrations use `IF NOT EXISTS` — if one fails, it's likely a permissions issue or a partially applied migration. Check the SQL Editor in Supabase for the specific error.

**Login fails after deployment**
Ensure `NEXT_PUBLIC_SUPABASE_ANON_KEY` is set in Vercel (not just locally). Redeploy after adding env vars.

**Generative onboarding fails with 401**
`ANTHROPIC_API_KEY` is not in your current shell session. Export it: `export ANTHROPIC_API_KEY=sk-ant-...` then re-run.

**`jq: command not found`**
Install jq: `brew install jq` (macOS) or `apt install jq` (Linux).

# Self-Hosted Onboarding Guide

## What You'll Need

- A [Supabase](https://supabase.com) account (free tier works) with a new project
- Node.js 18+ and npm
- A [Vercel](https://vercel.com) account (free tier works)
- An [Anthropic API key](https://console.anthropic.com)

---

## Step 1: Clone the app

**Option A — Deploy with Vercel (recommended):**

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https://github.com/dea-exmachina/app&env=SUPABASE_URL,SUPABASE_SERVICE_KEY,NEXT_PUBLIC_SUPABASE_URL,NEXT_PUBLIC_SUPABASE_ANON_KEY,ANTHROPIC_API_KEY&envDescription=Your+Supabase+project+credentials+and+Anthropic+API+key)

**Option B — Clone manually:**

```bash
git clone https://github.com/dea-exmachina/app.git
cd app
npm install
```

---

## Step 2: Configure your environment

Copy `.env.example` to `.env.local` and fill in:

```bash
cp .env.example .env.local
```

Required variables:

| Variable | Where to find it |
|---|---|
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase dashboard → Project Settings → API → Project URL |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase dashboard → Project Settings → API → anon/public key |
| `SUPABASE_SERVICE_KEY` | Supabase dashboard → Project Settings → API → service_role key |
| `ANTHROPIC_API_KEY` | [console.anthropic.com](https://console.anthropic.com) → API Keys |

---

## Step 3: Apply the database schema

Apply the migrations in `supabase/migrations/` to your Supabase project.

**Option A — Supabase CLI (recommended):**

```bash
npx supabase db push --db-url postgresql://postgres:[your-password]@db.[your-ref].supabase.co:5432/postgres
```

**Option B — Supabase dashboard:**

Open each `.sql` file in `supabase/migrations/` in order and run them via the SQL Editor in your Supabase dashboard. Files are prefixed with timestamps — run them in ascending order.

---

## Step 4: Run the generative onboarding

This script asks 5 questions and generates your personalized workspace: a CoS identity file, workspace config, and first project with seed cards.

```bash
ANTHROPIC_API_KEY=your_key ./scripts/generate-workspace.sh --output-dir ./my-workspace
```

Or if already exported:

```bash
./scripts/generate-workspace.sh --output-dir ./my-workspace
```

Requires `jq` and `curl`. Install jq if needed:

```bash
# macOS
brew install jq

# Ubuntu/Debian
apt install jq
```

---

## Step 5: Seed your workspace

After the script completes, import the generated files:

**user_config.json** — insert rows into your `user_config` Supabase table:

```bash
# Via Supabase REST API
curl -X POST "${NEXT_PUBLIC_SUPABASE_URL}/rest/v1/user_config" \
  -H "apikey: ${SUPABASE_SERVICE_KEY}" \
  -H "Content-Type: application/json" \
  -d @my-workspace/user_config.json
```

**first_project.json** — use the in-app project import (Settings → Import Project) or insert manually via SQL Editor.

**claude_md.txt** — copy the contents into `CLAUDE.md` in your workspace root. This becomes your CoS's identity file.

---

## Step 6: Deploy and log in

If you used the Vercel deploy button, your app is already live. Otherwise:

```bash
npx vercel --prod
```

Open the app, sign in via Supabase Auth (email/password or magic link), and your personalized workspace will be ready.

---

## Troubleshooting

**Script says `jq: command not found`** — install jq (see Step 4).

**API call fails with 401** — double-check `ANTHROPIC_API_KEY` is exported in your current shell session.

**Supabase migration fails** — run migrations in order (ascending by filename timestamp). If a migration has already been applied, skip it.

**Vercel deploy fails** — ensure all 4 environment variables are set in your Vercel project settings (Settings → Environment Variables).

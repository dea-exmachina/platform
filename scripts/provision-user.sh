#!/usr/bin/env bash
# provision-user.sh — Apply schema and seed starter workspace for a new user
#
# Usage:
#   ./scripts/provision-user.sh --db-url "postgres://postgres:[password]@db.[ref].supabase.co:5432/postgres"
#
# Options:
#   --db-url        Supabase DB connection string (required)
#                   Find it: Supabase dashboard → Project Settings → Database → Connection string (URI)
#   --skip-onboard  Skip running generate-workspace.sh after migration (default: run it)
#   --output-dir    Output dir for generated workspace files (default: ./generated-workspace)
#
# Requires:
#   - psql installed (brew install postgresql / apt install postgresql-client)
#   - jq installed (for generate-workspace.sh)
#   - ANTHROPIC_API_KEY set in environment (for generate-workspace.sh)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MIGRATIONS_DIR="$REPO_ROOT/supabase/migrations"

DB_URL=""
SKIP_ONBOARD=false
OUTPUT_DIR="./generated-workspace"
WORKSPACE_NAME="My Workspace"
USER_NAME="User"

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------

while [[ $# -gt 0 ]]; do
  case $1 in
    --db-url)         DB_URL="$2"; shift 2 ;;
    --skip-onboard)   SKIP_ONBOARD=true; shift ;;
    --output-dir)     OUTPUT_DIR="$2"; shift 2 ;;
    --workspace-name) WORKSPACE_NAME="$2"; shift 2 ;;
    --user-name)      USER_NAME="$2"; shift 2 ;;
    *)
      echo "Unknown argument: $1"
      echo "Usage: $0 --db-url <postgres-connection-string> [--workspace-name <name>] [--user-name <name>] [--skip-onboard] [--output-dir <path>]"
      exit 1
      ;;
  esac
done

# ---------------------------------------------------------------------------
# Preflight checks
# ---------------------------------------------------------------------------

if [[ -z "$DB_URL" ]]; then
  echo "Error: --db-url is required."
  echo ""
  echo "Find it in: Supabase dashboard → Project Settings → Database → Connection string (URI)"
  echo "Example:    postgres://postgres:[password]@db.[ref].supabase.co:5432/postgres"
  exit 1
fi

if ! command -v psql &>/dev/null; then
  echo "Error: psql is required but not installed."
  echo "Install: brew install postgresql (macOS) or apt install postgresql-client (Linux)"
  exit 1
fi

if [[ ! -d "$MIGRATIONS_DIR" ]]; then
  echo "Error: Migrations directory not found at: $MIGRATIONS_DIR"
  exit 1
fi

# ---------------------------------------------------------------------------
# Test DB connection
# ---------------------------------------------------------------------------

echo "Testing database connection..."
if ! psql "$DB_URL" -c "SELECT 1;" &>/dev/null; then
  echo "Error: Could not connect to database."
  echo "Check your --db-url and ensure your IP is in the Supabase allowed list."
  exit 1
fi
echo "Connection OK."
echo ""

# ---------------------------------------------------------------------------
# Apply migrations
# ---------------------------------------------------------------------------

MIGRATION_FILES=$(find "$MIGRATIONS_DIR" -name "*.sql" | sort)
MIGRATION_COUNT=$(echo "$MIGRATION_FILES" | wc -l | tr -d ' ')

echo "Applying $MIGRATION_COUNT migrations..."
echo ""

APPLIED=0
FAILED=0

while IFS= read -r migration_file; do
  filename=$(basename "$migration_file")
  printf "  %-60s" "$filename"

  if psql "$DB_URL" -f "$migration_file" &>/dev/null; then
    echo "OK"
    APPLIED=$((APPLIED + 1))
  else
    echo "FAILED"
    FAILED=$((FAILED + 1))
    echo ""
    echo "Migration failed: $filename"
    echo "Re-running with verbose output:"
    psql "$DB_URL" -f "$migration_file" || true
    echo ""
    echo "Provisioning halted. Fix the failing migration and re-run."
    exit 1
  fi
done <<< "$MIGRATION_FILES"

echo ""
echo "Migrations: $APPLIED applied, $FAILED failed."
echo ""

# ---------------------------------------------------------------------------
# Seed starter workspace (benders, project, seed cards)
# ---------------------------------------------------------------------------

IMPORT_SQL="$REPO_ROOT/templates/starter-workspace/import-workspace.sql"

if [[ -f "$IMPORT_SQL" ]]; then
  echo "Seeding starter workspace (benders, project, seed cards)..."

  # Substitute {{variables}} into a temp copy of the SQL
  IMPORT_TMP=$(mktemp /tmp/import-workspace-XXXXXX.sql)
  sed \
    -e "s/{{workspace.name}}/$WORKSPACE_NAME/g" \
    -e "s/{{user.name}}/$USER_NAME/g" \
    "$IMPORT_SQL" > "$IMPORT_TMP"

  if psql "$DB_URL" -f "$IMPORT_TMP" &>/dev/null; then
    echo "Starter workspace seeded OK."
  else
    echo "Warning: starter workspace seed had errors — re-running with verbose output:"
    psql "$DB_URL" -f "$IMPORT_TMP" || true
  fi

  rm -f "$IMPORT_TMP"
  echo ""
else
  echo "Warning: import-workspace.sql not found — skipping starter workspace seed."
  echo ""
fi

# ---------------------------------------------------------------------------
# Run generative onboarding (optional)
# ---------------------------------------------------------------------------

ONBOARD_SCRIPT="$SCRIPT_DIR/generate-workspace.sh"

if [[ "$SKIP_ONBOARD" == true ]]; then
  echo "Skipping onboarding (--skip-onboard flag set)."
  echo "Run manually: ./scripts/generate-workspace.sh --output-dir $OUTPUT_DIR"
else
  if [[ ! -f "$ONBOARD_SCRIPT" ]]; then
    echo "Warning: generate-workspace.sh not found at $ONBOARD_SCRIPT"
    echo "Skipping onboarding step."
  elif [[ -z "${ANTHROPIC_API_KEY:-}" ]]; then
    echo "Note: ANTHROPIC_API_KEY not set — skipping generative onboarding."
    echo "Run manually once key is available: ./scripts/generate-workspace.sh --output-dir $OUTPUT_DIR"
  else
    echo "Running generative onboarding..."
    echo ""
    bash "$ONBOARD_SCRIPT" --output-dir "$OUTPUT_DIR"
  fi
fi

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

echo ""
echo "============================================================"
echo "Provisioning complete."
echo ""
echo "Schema:     $APPLIED migrations applied"
echo "Database:   $(echo "$DB_URL" | sed 's/:[^:@]*@/@/g')"
echo ""
echo "Next steps:"
echo "  1. Copy .env.example → .env.local and fill in your Supabase keys"
echo "  2. If you ran onboarding: import user_config.json and first_project.json"
echo "     See docs/onboarding.md for import instructions"
echo "  3. Deploy the app to Vercel (see README.md for the deploy button)"
echo "  4. Sign in with Supabase Auth — your workspace is ready"
echo "============================================================"

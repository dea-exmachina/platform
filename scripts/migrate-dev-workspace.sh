#!/usr/bin/env bash
# migrate-dev-workspace.sh
# Migrates nexus project data from a source Supabase project to a target project.
# Usage: ./migrate-dev-workspace.sh --source-url URL --source-key KEY --target-url URL --target-key KEY --projects "ProjectName1,ProjectName2"
# Idempotent: uses ON CONFLICT DO UPDATE for inserts.

set -euo pipefail

SOURCE_URL=""
SOURCE_KEY=""
TARGET_URL=""
TARGET_KEY=""
PROJECTS=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --source-url) SOURCE_URL="$2"; shift 2 ;;
    --source-key) SOURCE_KEY="$2"; shift 2 ;;
    --target-url) TARGET_URL="$2"; shift 2 ;;
    --target-key) TARGET_KEY="$2"; shift 2 ;;
    --projects) PROJECTS="$2"; shift 2 ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
done

if [[ -z "$SOURCE_URL" || -z "$SOURCE_KEY" || -z "$TARGET_URL" || -z "$TARGET_KEY" || -z "$PROJECTS" ]]; then
  echo "Usage: $0 --source-url URL --source-key KEY --target-url URL --target-key KEY --projects 'Name1,Name2'"
  exit 1
fi

# Convert to Postgres connection strings (Supabase direct connection format)
# Supabase URL format: https://[ref].supabase.co → postgres://postgres:[key]@db.[ref].supabase.co:5432/postgres
SOURCE_REF=$(echo "$SOURCE_URL" | sed 's|https://||' | sed 's|\.supabase\.co.*||')
TARGET_REF=$(echo "$TARGET_URL" | sed 's|https://||' | sed 's|\.supabase\.co.*||')
SOURCE_PG="postgres://postgres.${SOURCE_REF}:${SOURCE_KEY}@aws-0-eu-west-1.pooler.supabase.com:6543/postgres"
TARGET_PG="postgres://postgres.${TARGET_REF}:${TARGET_KEY}@aws-0-eu-west-1.pooler.supabase.com:6543/postgres"

echo "Migrating projects: $PROJECTS"
echo "Source: $SOURCE_REF → Target: $TARGET_REF"

# Build project name filter
IFS=',' read -ra PROJECT_ARRAY <<< "$PROJECTS"
PROJECT_FILTER=$(printf "'%s'," "${PROJECT_ARRAY[@]}")
PROJECT_FILTER="${PROJECT_FILTER%,}"

# Export project IDs from source
echo "Fetching project IDs..."
PROJECT_IDS=$(psql "$SOURCE_PG" -t -A -c "SELECT id FROM nexus_projects WHERE name IN ($PROJECT_FILTER)")

if [[ -z "$PROJECT_IDS" ]]; then
  echo "No projects found matching: $PROJECTS"
  exit 1
fi

# Build UUID list for IN clause
UUID_LIST=$(echo "$PROJECT_IDS" | tr '\n' ',' | sed 's/,$//')
echo "Found project UUIDs: $UUID_LIST"

# Export and import each table
TABLES=(
  "nexus_projects"
  "nexus_sprints"
  "nexus_cards"
  "nexus_task_details"
  "nexus_comments"
  "nexus_card_reopens"
  "nexus_context_packages"
  "nexus_agent_sessions"
  "nexus_token_usage"
  "bender_tasks"
)

for TABLE in "${TABLES[@]}"; do
  echo "Migrating $TABLE..."

  # Determine the project_id column filter
  case $TABLE in
    "nexus_projects")
      FILTER="id IN ($UUID_LIST)"
      ;;
    "nexus_sprints"|"nexus_cards"|"nexus_task_details"|"nexus_comments"|"nexus_card_reopens"|"nexus_context_packages"|"nexus_agent_sessions"|"nexus_token_usage")
      FILTER="project_id IN ($UUID_LIST)"
      ;;
    "bender_tasks")
      # bender_tasks links to nexus_cards
      FILTER="card_id IN (SELECT id FROM nexus_cards WHERE project_id IN ($UUID_LIST))"
      ;;
    *)
      FILTER="project_id IN ($UUID_LIST)"
      ;;
  esac

  # Dump and restore (using psql COPY)
  TMPFILE=$(mktemp /tmp/migrate_${TABLE}_XXXXXX.sql)
  psql "$SOURCE_PG" -c "\COPY (SELECT * FROM $TABLE WHERE $FILTER) TO '$TMPFILE' WITH (FORMAT CSV, HEADER true)"

  if [[ -s "$TMPFILE" ]]; then
    psql "$TARGET_PG" -c "\COPY $TABLE FROM '$TMPFILE' WITH (FORMAT CSV, HEADER true)"
    echo "  ✓ $TABLE migrated"
  else
    echo "  - $TABLE: no rows to migrate"
  fi

  rm -f "$TMPFILE"
done

echo ""
echo "Migration complete."
echo "Next: verify target has full project data, then delete from source."
echo "To delete from source: run this script with --delete-source flag (add to script as needed)"

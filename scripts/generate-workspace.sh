#!/usr/bin/env bash
# generate-workspace.sh — Generative onboarding for dea-exmachina
# Usage: ./scripts/generate-workspace.sh --output-dir /path/to/output
#
# Requires:
#   - ANTHROPIC_API_KEY environment variable set
#   - jq installed (brew install jq / apt install jq)
#   - curl installed

set -euo pipefail

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------

OUTPUT_DIR="./generated-workspace"

while [[ $# -gt 0 ]]; do
  case $1 in
    --output-dir) OUTPUT_DIR="$2"; shift 2 ;;
    *) echo "Unknown argument: $1"; echo "Usage: $0 --output-dir /path/to/output"; exit 1 ;;
  esac
done

# ---------------------------------------------------------------------------
# Preflight checks
# ---------------------------------------------------------------------------

if [[ -z "${ANTHROPIC_API_KEY:-}" ]]; then
  echo "Error: ANTHROPIC_API_KEY is not set."
  echo "Export it before running: export ANTHROPIC_API_KEY=your_key"
  exit 1
fi

if ! command -v jq &>/dev/null; then
  echo "Error: jq is required but not installed."
  echo "Install it: brew install jq (macOS) or apt install jq (Linux)"
  exit 1
fi

if ! command -v curl &>/dev/null; then
  echo "Error: curl is required but not installed."
  exit 1
fi

# ---------------------------------------------------------------------------
# Interactive questions
# ---------------------------------------------------------------------------

echo ""
echo "Welcome to dea-exmachina — personalized workspace setup."
echo "Answer 5 quick questions and we'll generate your workspace."
echo ""

read -r -p "> What's your name? (first name or whatever you prefer to go by): " USER_NAME
echo ""

read -r -p "> What do you do? Describe your work in a sentence or two: " WORK_DESCRIPTION
echo ""

read -r -p "> What's one big thing you want to accomplish in the next 90 days?: " GOAL
echo ""

read -r -p "> What should we call your AI Chief of Staff? (this is the name of your main AI partner): " COS_NAME
echo ""

read -r -p "> What's your workspace called? (e.g. your name, your company, your project): " WORKSPACE_NAME
echo ""

# ---------------------------------------------------------------------------
# Build API payload
# ---------------------------------------------------------------------------

SYSTEM_PROMPT="You are a workspace configuration generator for an AI operating system. Generate a personalized workspace package based on the user's answers. Output valid JSON only."

USER_PROMPT=$(jq -n \
  --arg name "$USER_NAME" \
  --arg work "$WORK_DESCRIPTION" \
  --arg goal "$GOAL" \
  --arg cos "$COS_NAME" \
  --arg workspace "$WORKSPACE_NAME" \
  '"Generate a workspace package for this user:\n- Name: \($name)\n- Work: \($work)\n- 90-day goal: \($goal)\n- CoS name: \($cos)\n- Workspace name: \($workspace)\n\nGenerate JSON with this exact structure:\n{\n  \"claude_md_content\": \"string — a 200-300 word CLAUDE.md identity file for their CoS. Write in second person addressed to the AI (\u0027You are \($cos)...\u0027). Include: who the user is, what they do, what their 90-day goal is, their working style defaults (assume: direct, no filler, structured output preferred, high autonomy default), and the CoS\u0027s operational star (a 1-line mission derived from their goal).\",\n  \"user_config\": [\n    {\"key\": \"user.name\", \"value\": \"\($name)\"},\n    {\"key\": \"cos.name\", \"value\": \"\($cos)\"},\n    {\"key\": \"workspace.name\", \"value\": \"\($workspace)\"},\n    {\"key\": \"user.role\", \"value\": \"derived from their work description — 2-3 words max\"}\n  ],\n  \"first_project\": {\n    \"name\": \"string — project name derived from their 90-day goal\",\n    \"description\": \"string — 1-2 sentence project description\",\n    \"seed_cards\": [\n      {\n        \"title\": \"string — first concrete action toward the goal\",\n        \"description\": \"string — what this card is about\",\n        \"lane\": \"backlog\",\n        \"priority\": \"high\"\n      },\n      {\n        \"title\": \"string — second concrete action\",\n        \"description\": \"string\",\n        \"lane\": \"backlog\",\n        \"priority\": \"normal\"\n      }\n    ]\n  }\n}"')

API_PAYLOAD=$(jq -n \
  --arg model "claude-sonnet-4-6" \
  --arg system "$SYSTEM_PROMPT" \
  --arg user_content "$USER_PROMPT" \
  '{
    model: $model,
    max_tokens: 2048,
    system: $system,
    messages: [
      {role: "user", content: $user_content}
    ]
  }')

# ---------------------------------------------------------------------------
# Call Anthropic API
# ---------------------------------------------------------------------------

echo "Generating your workspace..."
echo ""

HTTP_RESPONSE=$(curl -s -w "\n__HTTP_STATUS__%{http_code}" \
  https://api.anthropic.com/v1/messages \
  --header "x-api-key: ${ANTHROPIC_API_KEY}" \
  --header "anthropic-version: 2023-06-01" \
  --header "content-type: application/json" \
  --data "$API_PAYLOAD")

HTTP_BODY=$(echo "$HTTP_RESPONSE" | sed '$d')
HTTP_STATUS=$(echo "$HTTP_RESPONSE" | tail -n 1 | sed 's/__HTTP_STATUS__//')

if [[ "$HTTP_STATUS" != "200" ]]; then
  echo "Error: Anthropic API returned HTTP ${HTTP_STATUS}"
  echo "Response: $HTTP_BODY"
  exit 1
fi

# ---------------------------------------------------------------------------
# Parse API response
# ---------------------------------------------------------------------------

RAW_CONTENT=$(echo "$HTTP_BODY" | jq -r '.content[0].text // empty')

if [[ -z "$RAW_CONTENT" ]]; then
  echo "Error: Empty response from API."
  echo "Full response: $HTTP_BODY"
  exit 1
fi

# Strip markdown code fences if present (model sometimes wraps JSON in ```json)
WORKSPACE_JSON=$(echo "$RAW_CONTENT" | sed '/^```/d')

# Validate JSON
if ! echo "$WORKSPACE_JSON" | jq . &>/dev/null; then
  echo "Error: API response is not valid JSON."
  echo "Raw content: $RAW_CONTENT"
  exit 1
fi

# ---------------------------------------------------------------------------
# Write output files
# ---------------------------------------------------------------------------

mkdir -p "$OUTPUT_DIR"

# claude_md.txt
echo "$WORKSPACE_JSON" | jq -r '.claude_md_content' > "$OUTPUT_DIR/claude_md.txt"

# user_config.json
echo "$WORKSPACE_JSON" | jq '.user_config' > "$OUTPUT_DIR/user_config.json"

# first_project.json
echo "$WORKSPACE_JSON" | jq '.first_project' > "$OUTPUT_DIR/first_project.json"

# ---------------------------------------------------------------------------
# Success summary
# ---------------------------------------------------------------------------

PROJECT_NAME=$(echo "$WORKSPACE_JSON" | jq -r '.first_project.name')
SEED_CARD_COUNT=$(echo "$WORKSPACE_JSON" | jq '.first_project.seed_cards | length')
USER_ROLE=$(echo "$WORKSPACE_JSON" | jq -r '.user_config[] | select(.key == "user.role") | .value')

echo "Workspace generated for ${USER_NAME}."
echo ""
echo "Output directory: ${OUTPUT_DIR}"
echo ""
echo "Files created:"
echo "  claude_md.txt      — CoS identity file (your CLAUDE.md)"
echo "  user_config.json   — Workspace configuration keys"
echo "  first_project.json — First project: \"${PROJECT_NAME}\" (${SEED_CARD_COUNT} seed cards)"
echo ""
echo "Detected role: ${USER_ROLE}"
echo ""
echo "Next steps:"
echo "  1. Copy claude_md.txt content into your workspace CLAUDE.md"
echo "  2. Import user_config.json into your Supabase user_config table"
echo "  3. Import first_project.json to seed your first NEXUS project"
echo "  4. See docs/onboarding.md for full setup instructions"

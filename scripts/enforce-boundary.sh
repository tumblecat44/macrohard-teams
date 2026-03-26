#!/bin/bash
# PreToolUse hook: Context boundary enforcement
# Checks agent_type + file_path -> blocks boundary violations with exit 2

INPUT=$(cat)
AGENT_TYPE=$(echo "$INPUT" | jq -r '.agent_type // "leader"')
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# leader has full access
if [ "$AGENT_TYPE" = "leader" ] || [ -z "$AGENT_TYPE" ]; then
  exit 0
fi

# No file_path (e.g. Bash) -> pass
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

BLOCKED=false
REASON=""

case "$AGENT_TYPE" in
  product-pm)
    if [[ "$FILE_PATH" != *"docs/product"* && "$FILE_PATH" != *"docs/specs"* ]]; then
      BLOCKED=true
      REASON="product-pm can only write to docs/product/ and docs/specs/. Attempted: $FILE_PATH"
    fi
    ;;
  eng-lead)
    if [[ "$FILE_PATH" != *"src/"* && "$FILE_PATH" != *"package"* ]]; then
      BLOCKED=true
      REASON="eng-lead can only write to src/ and package*. Attempted: $FILE_PATH"
    fi
    ;;
  eng-frontend)
    if [[ "$FILE_PATH" != *"src/components"* && "$FILE_PATH" != *"src/pages"* && "$FILE_PATH" != *"public/"* ]]; then
      BLOCKED=true
      REASON="eng-frontend can only write to src/components/, src/pages/, public/. Attempted: $FILE_PATH"
    fi
    ;;
  eng-backend)
    if [[ "$FILE_PATH" != *"src/api"* && "$FILE_PATH" != *"database/"* && "$FILE_PATH" != *"prisma/"* ]]; then
      BLOCKED=true
      REASON="eng-backend can only write to src/api/, database/, prisma/. Attempted: $FILE_PATH"
    fi
    ;;
  qa-tester)
    if [[ "$FILE_PATH" != *"tests/"* && "$FILE_PATH" != *"e2e/"* ]]; then
      BLOCKED=true
      REASON="qa-tester can only write to tests/ and e2e/. Attempted: $FILE_PATH"
    fi
    ;;
esac

if [ "$BLOCKED" = true ]; then
  PROJ_DIR=$(echo "$INPUT" | jq -r '.cwd')
  ENTRY=$(jq -n \
    --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    --arg agent "$AGENT_TYPE" \
    --arg file "$FILE_PATH" \
    --arg reason "$REASON" \
    '{timestamp:$ts, phase:"BOUNDARY_VIOLATION", agent:$agent, file:$file, reason:$reason}')
  echo "$ENTRY" >> "$PROJ_DIR/decisions.jsonl" 2>/dev/null

  echo "BOUNDARY VIOLATION: $REASON" >&2
  exit 2
fi

exit 0

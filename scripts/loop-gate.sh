#!/bin/bash
# Stop hook: Enforce commit + decisions.jsonl + retro + experiments before stopping

INPUT=$(cat)
STOP_HOOK_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active')
PROJ_DIR=$(echo "$INPUT" | jq -r '.cwd')

# Prevent infinite loop
if [ "$STOP_HOOK_ACTIVE" = "true" ]; then
  exit 0
fi

# 1. decisions.jsonl must exist and be non-empty
if [ ! -s "$PROJ_DIR/decisions.jsonl" ]; then
  echo '{"decision":"block","reason":"decisions.jsonl is empty. Record your decisions before stopping."}'
  exit 0
fi

# 2. Block uncommitted changes
UNCOMMITTED=$(cd "$PROJ_DIR" && git status --porcelain 2>/dev/null | grep -v '^\?\?' | head -20)
if [ -n "$UNCOMMITTED" ]; then
  FILE_LIST=$(echo "$UNCOMMITTED" | awk '{print $2}' | head -5 | tr '\n' ', ' | sed 's/,$//')
  echo "{\"decision\":\"block\",\"reason\":\"Uncommitted changes detected: $FILE_LIST. Commit before stopping.\"}"
  exit 0
fi

# 3. Check uncompleted retro action items
RETRO_DIR="$PROJ_DIR/.macrohard-memory/retrospectives"
if [ -d "$RETRO_DIR" ]; then
  UNCHECKED=$(grep -r '\- \[ \]' "$RETRO_DIR"/RETRO-*.md 2>/dev/null | head -10)
  if [ -n "$UNCHECKED" ]; then
    COUNT=$(echo "$UNCHECKED" | wc -l | tr -d ' ')
    ITEMS=$(echo "$UNCHECKED" | sed 's/.*- \[ \] //' | head -3 | tr '\n' '; ' | sed 's/; $//')
    echo "{\"decision\":\"block\",\"reason\":\"${COUNT} unchecked retro action items: ${ITEMS}. Complete ([x]) or defer ([~] DEFERRED: why).\"}"
    exit 0
  fi
fi

# 4. Minimum 2 experiments
EXP_DIR="$PROJ_DIR/.macrohard-memory/experiments"
if [ -d "$EXP_DIR" ]; then
  EXP_COUNT=$(ls "$EXP_DIR"/EXP-*.md 2>/dev/null | wc -l | tr -d ' ')
  if [ "$EXP_COUNT" -lt 2 ]; then
    echo "{\"decision\":\"block\",\"reason\":\"Only ${EXP_COUNT} experiment(s). Minimum 2 required for convergence.\"}"
    exit 0
  fi
fi

exit 0

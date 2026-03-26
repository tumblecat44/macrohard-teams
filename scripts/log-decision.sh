#!/bin/bash
# PostToolUse hook: Log file changes to decisions.jsonl

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name')
AGENT_TYPE=$(echo "$INPUT" | jq -r '.agent_type // "leader"')
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
PROJ_DIR=$(echo "$INPUT" | jq -r '.cwd')

if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Prevent infinite loop on decisions.jsonl itself
if [[ "$FILE_PATH" == *"decisions.jsonl"* ]]; then
  exit 0
fi

ENTRY=$(jq -n \
  --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --arg agent "$AGENT_TYPE" \
  --arg tool "$TOOL_NAME" \
  --arg file "$FILE_PATH" \
  '{timestamp:$ts, phase:"FILE_CHANGE", agent:$agent, tool:$tool, file:$file}')

echo "$ENTRY" >> "$PROJ_DIR/decisions.jsonl" 2>/dev/null
exit 0

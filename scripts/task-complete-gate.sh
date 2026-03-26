#!/bin/bash
# TaskCompleted hook: Log task completion to decisions.jsonl

INPUT=$(cat)
TASK_SUBJECT=$(echo "$INPUT" | jq -r '.task_subject // empty')
TEAMMATE=$(echo "$INPUT" | jq -r '.teammate_name // "leader"')
PROJ_DIR=$(echo "$INPUT" | jq -r '.cwd')

ENTRY=$(jq -n \
  --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --arg task "$TASK_SUBJECT" \
  --arg agent "$TEAMMATE" \
  '{timestamp:$ts, phase:"TASK_COMPLETE", agent:$agent, task:$task}')

echo "$ENTRY" >> "$PROJ_DIR/decisions.jsonl" 2>/dev/null
exit 0

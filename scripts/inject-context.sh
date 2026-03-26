#!/bin/bash
# SubagentStart hook: Inject boundary rules into subagent context

INPUT=$(cat)
AGENT_TYPE=$(echo "$INPUT" | jq -r '.agent_type // empty')

if [ -z "$AGENT_TYPE" ]; then
  exit 0
fi

jq -n \
  --arg ctx "You are agent '$AGENT_TYPE'. MANDATORY: Respect Context Boundary Rules at all times. Check your allowed/forbidden paths before any Write or Edit operation. Violations are blocked by PreToolUse hooks." \
  '{hookSpecificOutput:{hookEventName:"SubagentStart",additionalContext:$ctx}}'

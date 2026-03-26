#!/bin/bash
# PreToolUse hook (Bash): Enforce Conventional Commits format on git commit commands

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# Not a git commit -> pass
if ! echo "$COMMAND" | grep -q 'git commit'; then
  exit 0
fi

# Allow merge, rebase, empty commits
if echo "$COMMAND" | grep -qE '\-\-allow-empty|merge|rebase'; then
  exit 0
fi

# Extract commit message
if echo "$COMMAND" | grep -q "cat <<"; then
  COMMIT_MSG=$(echo "$COMMAND" | sed -n "s/.*cat <<'EOF'//p" | sed '/^EOF/q' | head -1 | xargs)
else
  COMMIT_MSG=$(echo "$COMMAND" | grep -oP '(?<=-m\s")[^"]*|(?<=-m\s'"'"')[^'"'"']*' | head -1)
  if [ -z "$COMMIT_MSG" ]; then
    COMMIT_MSG=$(echo "$COMMAND" | grep -oP '(?<=-m ")[^"]*' | head -1)
  fi
fi

# Can't extract message (interactive commit etc) -> pass
if [ -z "$COMMIT_MSG" ]; then
  exit 0
fi

# 1. Conventional Commits format check
if ! echo "$COMMIT_MSG" | grep -qE '^(feat|fix|refactor|docs|test|style|perf|chore|revert)(\([a-z0-9_-]+\))?!?:'; then
  echo "COMMIT BLOCKED: Conventional Commits format required. Got: '$COMMIT_MSG'" >&2
  echo "Expected: <type>(<scope>): description" >&2
  echo "Types: feat, fix, refactor, docs, test, style, perf, chore, revert" >&2
  exit 2
fi

# 2. No Korean, emoji, or WIP in title
FIRST_LINE=$(echo "$COMMIT_MSG" | head -1)
if echo "$FIRST_LINE" | grep -qP '[\x{AC00}-\x{D7AF}]|[\x{1F000}-\x{1FFFF}]|WIP'; then
  echo "COMMIT BLOCKED: No Korean, emoji, or 'WIP' in commit title." >&2
  exit 2
fi

# 3. Block meaningless messages
if echo "$FIRST_LINE" | grep -qiE '^(feat|fix|refactor|docs|test|style|perf|chore|revert)(\([^)]*\))?!?:\s*(update|change|modify|edit)\s*(file|code|stuff)s?\s*$'; then
  echo "COMMIT BLOCKED: Meaningless commit message. Describe WHAT and WHY." >&2
  exit 2
fi

# 4. Meta files require chore or docs type
if echo "$COMMAND" | grep -qE 'decisions\.jsonl|CLAUDE\.md'; then
  if ! echo "$COMMIT_MSG" | grep -qE '^(chore|docs)'; then
    echo "COMMIT BLOCKED: Meta files (decisions.jsonl, CLAUDE.md) require chore or docs type." >&2
    exit 2
  fi
fi

exit 0

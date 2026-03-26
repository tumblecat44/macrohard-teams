---
name: status
description: Show current build progress — what the team has built, which agents produced what, test results, and any pending work. Use to check what was done.
allowed-tools: Read, Glob, Grep, Bash
---

# Build Status

Check what the team has produced so far.

## What to show

1. **PRDs written** — list files in docs/product/ and docs/specs/
2. **Code implemented** — list files in src/ with line counts
3. **Tests written** — list files in tests/ and e2e/ with pass/fail status
4. **Recent commits** — `git log --oneline -10`
5. **Uncommitted changes** — `git status --porcelain`
6. **Decision log** — last 5 entries from decisions.jsonl if it exists

## Output format

```
=== Build Status ===

PRDs: [count] documents in docs/product/
  - [filename] ([lines] lines)

Implementation: [count] files in src/
  - [filename] ([lines] lines)

Tests: [count] files in tests/ + e2e/
  - [filename] ([lines] lines)
  - Last run: [pass/fail]

Recent commits:
  [git log output]

Pending: [uncommitted files or "all committed"]
```

$ARGUMENTS

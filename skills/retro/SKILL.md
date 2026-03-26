---
name: retro
description: Run a retrospective on the current iteration or a specific topic. Analyzes decisions, identifies patterns, creates action items. Use after completing work or when something went wrong.
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Retrospective

Analyze recent work and create a structured retrospective.

## Steps

1. **Read context**:
   - `decisions.jsonl` — recent decisions and file changes
   - `.macrohard-memory/loop-state.json` — current iteration
   - `.macrohard-memory/retrospectives/` — previous retros for patterns
   - `git log --oneline -20` — recent commits

2. **Analyze patterns**:
   - What decisions were made and why?
   - Were there any boundary violations?
   - Did any experiments fail? Why?
   - Were there repeated mistakes?
   - What worked well?

3. **Write retrospective** to `.macrohard-memory/retrospectives/RETRO-NNN.md`:
   ```markdown
   # Retrospective RETRO-NNN: [Title]

   **Date:** YYYY-MM-DD
   **Iteration:** N
   **Scope:** [what this retro covers]

   ## What Went Well
   - [item]

   ## What Went Wrong
   - [item]

   ## Action Items
   - [ ] [specific, actionable item]
   - [ ] [specific, actionable item]

   ## Lessons Learned
   - [pattern or insight worth remembering]
   ```

4. **Check previous retro action items**:
   - `grep -r '\- \[ \]' .macrohard-memory/retrospectives/`
   - Mark completed items as `[x]`
   - Defer items with reason: `[~] DEFERRED: reason`

5. **Update decisions.jsonl** with retro completion record

$ARGUMENTS

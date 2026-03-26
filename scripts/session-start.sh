#!/bin/bash
# SessionStart hook: Load institutional memory and inject resume context

PROJ_DIR=$(echo "$(cat)" | jq -r '.cwd')
MEMORY_DIR="$PROJ_DIR/.macrohard-memory"
STATE_FILE="$MEMORY_DIR/loop-state.json"

# Count research sources
SOURCE_COUNT=0
if [ -f "$MEMORY_DIR/research/sources.jsonl" ]; then
  SOURCE_COUNT=$(wc -l < "$MEMORY_DIR/research/sources.jsonl" | tr -d ' ')
fi

# Count iterations
ITERATION_COUNT=0
if [ -f "$PROJ_DIR/decisions.jsonl" ]; then
  ITERATION_COUNT=$(grep -c '"phase":"RESEARCH"' "$PROJ_DIR/decisions.jsonl" 2>/dev/null || echo 0)
fi

if [ -f "$STATE_FILE" ]; then
  ITER=$(jq -r '.iteration' "$STATE_FILE")
  PHASE=$(jq -r '.phase' "$STATE_FILE")
  PHASE_NAME=$(jq -r '.phase_name' "$STATE_FILE")
  STATUS=$(jq -r '.status' "$STATE_FILE")
  CONV=$(jq -r '.convergence_counter' "$STATE_FILE")
  CONV_TARGET=$(jq -r '.convergence_target' "$STATE_FILE")
  EXP_REQ=$(jq -r '.experiments_required' "$STATE_FILE")
  PARALLEL_DONE=$(jq -r '.parallel_test_done' "$STATE_FILE")
  NOTES=$(jq -r '.notes // empty' "$STATE_FILE")

  ACTUAL_PENDING=0
  if [ -d "$MEMORY_DIR/retrospectives" ]; then
    ACTUAL_PENDING=$(grep -r '\- \[ \]' "$MEMORY_DIR/retrospectives"/RETRO-*.md 2>/dev/null | wc -l | tr -d ' ')
  fi

  ACTUAL_EXP=0
  if [ -d "$MEMORY_DIR/experiments" ]; then
    ACTUAL_EXP=$(ls "$MEMORY_DIR/experiments"/EXP-*.md 2>/dev/null | wc -l | tr -d ' ')
  fi

  CONTEXT="[MacroHard Institutional Memory Active - RESUMING]
- Current iteration: $ITER
- Current phase: $PHASE ($PHASE_NAME)
- Loop status: $STATUS
- Research sources: $SOURCE_COUNT
- Convergence: $CONV/$CONV_TARGET
- Retro action items pending: $ACTUAL_PENDING
- Experiments: $ACTUAL_EXP completed / $EXP_REQ required
- Parallel test done: $PARALLEL_DONE
- Memory location: .macrohard-memory/
${NOTES:+- Note: $NOTES}

MANDATORY RESUME ACTION:
1. Read .macrohard-memory/loop-state.json
2. Read .macrohard-memory/index.md
3. Check retrospectives for unchecked action items
4. RESUME from Phase $PHASE ($PHASE_NAME) of Iteration $ITER
5. After each phase, UPDATE loop-state.json
6. Convergence requires: 3 consecutive no-change + retro done + ${EXP_REQ}+ experiments + parallel test"

else
  CONTEXT="[MacroHard Institutional Memory Active - FRESH START]
- Research sources: $SOURCE_COUNT
- Iterations completed: $ITERATION_COUNT
- Memory location: .macrohard-memory/

FIRST ACTION:
1. Read .macrohard-memory/index.md
2. Read .macrohard-memory/research/synthesis.md
3. WebSearch 2-3 keywords (only content after 2026-02-05)
4. Save to research/sources.jsonl with reliability scores
5. Update synthesis.md
6. Create loop-state.json with iteration:1, phase:0
7. Proceed: SCAN -> DESIGN -> TEST -> LEARN -> EVOLVE"
fi

jq -n --arg ctx "$CONTEXT" \
  '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:$ctx}}'

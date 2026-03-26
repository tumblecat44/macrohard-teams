---
name: loop
description: Run one iteration of the ralph-loop — the self-propagation research and evolution cycle. Researches latest agent team practices, evaluates current team, records decisions, and checks convergence. Use when you want to evolve your agent team composition.
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Agent, WebSearch, WebFetch, TaskCreate, TaskUpdate
---

# Ralph Loop — Self-Propagation Iteration

Execute one full iteration of the ralph-loop (Phase 0-5). Read loop-state.json first to resume from the correct phase.

## Phase 0: RESEARCH
1. Read `.macrohard-memory/research/synthesis.md` for search keyword rotation
2. WebSearch 2-3 keywords (content after 2026-02-05 only)
3. For each result, create a source entry in `research/sources.jsonl`:
   ```jsonl
   {"id":"src-NNN","timestamp":"...","iteration":N,"search_keywords":"...","url":"...","title":"...","publish_date":"...","author":"...","reliability_score":1-5,"key_insights":[...],"agrees_with":[...],"contradicts":[...],"new_principle_candidate":"...or null","raw_notes":"..."}
   ```
4. Update synthesis.md with any new convergent principles
5. Record decision in decisions.jsonl

## Phase 1: SCAN
1. Scan current agent specs in `.claude/agents/` (or plugin agents)
2. Analyze team composition vs research recommendations
3. Note gaps or redundancies

## Phase 2: DESIGN
1. If research suggests changes, write/update agent specs
2. Record architectural decisions as ADRs
3. If no changes needed, record "no-change" decision

## Phase 3: TEST
1. If new agents were added, run a dry-run sample task
2. If team unchanged, verify existing tests still pass
3. Record test results

## Phase 4: LEARN
1. Analyze decisions.jsonl for mistake patterns
2. Write retrospective (`.macrohard-memory/retrospectives/RETRO-NNN.md`)
3. Resolve any unchecked retro action items from previous iterations
4. Update CLAUDE.md if new rules discovered

## Phase 5: EVOLVE
1. Update loop-state.json with new iteration number
2. Check convergence conditions:
   - 3+ consecutive no-change iterations?
   - All retro action items resolved?
   - 2+ experiments completed?
   - 1+ parallel execution test done?
3. Update index.md quick stats
4. If converged: write FINAL-REPORT.md

## After Each Phase
- Record decision in decisions.jsonl
- Update loop-state.json with current phase number
- Commit changes: `chore(iter-N): phase description`

$ARGUMENTS

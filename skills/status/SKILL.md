---
name: status
description: Show the current state of the self-propagating team — iteration count, convergence progress, research sources, first principles, and team composition. Use to check progress without running a loop iteration.
allowed-tools: Read, Glob, Grep, Bash
---

# MacroHard Team Status

Read and display the current state of the self-propagating team.

## What to show

1. **Read `.macrohard-memory/loop-state.json`** and display:
   - Current iteration and phase
   - Convergence counter (N/3)
   - Experiments completed
   - Parallel test status

2. **Read `.macrohard-memory/index.md`** and display:
   - Total research sources
   - Total first principles
   - Total synthesized principles
   - Total experiments and retrospectives

3. **List current agents** from `.claude/agents/` or plugin agents:
   - Name, model, role summary

4. **Check for pending retro actions**:
   ```bash
   grep -r '\- \[ \]' .macrohard-memory/retrospectives/RETRO-*.md
   ```

5. **Check for uncommitted changes**:
   ```bash
   git status --porcelain
   ```

6. **Display promotion candidates** from synthesis.md that are close to First Principle promotion.

## Output Format

```
=== MacroHard Team Status ===
Iteration: N | Phase: X (NAME) | Status: running/converged
Convergence: N/3 | Experiments: N/2 | Parallel: yes/no

Team: 4 agents
  - leader (opus) — orchestrator
  - product-pm (sonnet) — PRD/specs
  - eng-lead (opus) — implementation
  - qa-tester (sonnet) — tests

Research: N sources | Principles: N first + N synthesized
Pending retro items: N
Uncommitted changes: N files

Next: [recommended action]
```

$ARGUMENTS

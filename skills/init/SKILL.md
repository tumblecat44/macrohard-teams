---
name: init
description: Initialize a self-propagating agent team in the current project. Creates .macrohard-memory/ directory structure, initial index.md, first principles, and loop-state.json. Use when starting a new project or adding self-propagation to an existing codebase.
disable-model-invocation: true
allowed-tools: Read, Write, Bash, Glob, Grep
---

# Initialize MacroHard Self-Propagating Team

Set up the institutional memory and team infrastructure for this project.

## Steps

1. **Create directory structure**:
   ```
   .macrohard-memory/
   ├── index.md                    # Knowledge graph (you'll populate this)
   ├── loop-state.json             # Iteration state tracker
   ├── research/
   │   ├── sources.jsonl           # Web research with reliability scores
   │   └── synthesis.md            # Synthesized principles
   ├── decisions/
   │   └── decisions.jsonl         # ADR and decision log (also at project root)
   ├── experiments/                # A/B tests and experiment results
   ├── retrospectives/             # Post-mortems per iteration
   ├── metrics/                    # Agent performance data
   ├── agents/                     # Per-agent performance history
   ├── assumptions/
   │   └── log.jsonl               # Tracked assumptions
   └── principles/
       ├── philosophy.md           # Evolving first principles
       └── git-commit.md           # Commit convention rules
   ```

2. **Initialize index.md** with the 3 foundational first principles:
   - Context boundary creates role. Role does not create boundary.
   - Institutional memory > individual agent capability.
   - Every decision must be traceable to a source.

3. **Initialize loop-state.json**:
   ```json
   {
     "iteration": 0,
     "phase": 0,
     "phase_name": "RESEARCH",
     "status": "fresh",
     "convergence_counter": 0,
     "convergence_target": 3,
     "last_updated": "<now>",
     "retro_actions_pending": 0,
     "experiments_completed": 0,
     "experiments_required": 2,
     "parallel_test_done": false,
     "notes": "Fresh initialization"
   }
   ```

4. **Initialize synthesis.md** with search keyword batches and the source reliability scoring table.

5. **Initialize decisions.jsonl** at project root (empty file).

6. **Create required project directories** if they don't exist:
   - `docs/product/`, `docs/specs/`, `src/`, `tests/`, `e2e/`

7. **Add `.macrohard-memory/` to .gitignore** if user prefers (ask first). Otherwise, commit it for team sharing.

8. **Print summary** of what was created and next steps:
   - "Run `/macrohard-teams:loop` to start the self-propagation research loop"
   - "Run `/macrohard-teams:status` to check current state"

$ARGUMENTS

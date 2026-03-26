# macrohard-teams

Claude Code plugin that gives you a 4-agent build team. Tell it what to build, it does the rest — PM writes the PRD, engineer implements, QA tests.

## Install

```bash
claude --plugin-dir ./macrohard-teams
```

## Use

```
/macrohard-teams:build 쇼핑몰 만들어줘
```

That's it. The leader agent:
1. Decides if a team is needed (small tasks skip the team)
2. Has PM write a PRD with acceptance criteria
3. Has engineer implement based on the PRD
4. Has QA write and run tests against the acceptance criteria
5. If tests fail, sends fixes back to engineer (max 3 retries)
6. Reports what was built

Check progress anytime:
```
/macrohard-teams:status
```

## How it works

The plugin is built on 22 principles distilled from 18 research sources across 8 iterations of research. Zero contradictions across all sources.

### Team (4 agents, heterogeneous models)

| Agent | Model | Writes to | Blocked from |
|-------|-------|-----------|-------------|
| leader | Opus | orchestration only | never implements |
| product-pm | Sonnet | docs/product/, docs/specs/ | src/, tests/ |
| eng-lead | Opus | src/, package* | tests/, docs/product/ |
| qa-tester | Sonnet | tests/, e2e/ | src/, docs/product/ |

Boundaries are **physically enforced** by PreToolUse hooks — agents can't cheat.

### Wave-based execution

Tasks run in waves based on dependencies, not fixed stages:
- **Independent tasks** (zero file overlap) → parallel, proven 1.75x speedup
- **Dependent tasks** (B needs A's output) → sequential

### What the hooks do

| Hook | What it enforces |
|------|-----------------|
| enforce-boundary.sh | Blocks agents from writing outside their directories |
| enforce-commit.sh | Requires Conventional Commits format |
| log-decision.sh | Logs every file change to decisions.jsonl |
| teammate-gate.sh | Blocks agents from going idle without deliverables |
| task-complete-gate.sh | Logs task completions |
| inject-context.sh | Reminds agents of their boundaries on startup |

## Research basis

Key sources behind the design:

- **Anthropic Official Docs** — 3-5 teammates optimal, file locking prevents conflicts
- **Google Research** — sequential tasks degrade -70% with more agents, 45% single-agent threshold
- **Nicholas Carlini (Anthropic)** — tests are THE primary control mechanism, 16-agent C compiler at $20k
- **Addy Osmani** — planner-worker-judge hierarchy, four channels of memory
- **Alex Lavaee** — Cursor + Anthropic converged on same 5 primitives independently

Full research data: 18 sources, 8 first principles, 22 synthesized principles, 0 contradictions.

## License

MIT

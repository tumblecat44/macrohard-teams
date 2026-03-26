# macrohard-teams

Claude Code plugin that gives you a 4-agent build team. Tell it what to build — PM writes the PRD, engineer implements, QA tests.

## Install

### From marketplace (recommended)

```bash
# 1. Add the marketplace
/plugin marketplace add tumblecat44/macrohard-teams

# 2. Install the plugin
/plugin install macrohard-teams@macrohard-teams

# 3. Activate (run once after install)
/reload-plugins
```

## Use

```
/macrohard-teams:build 유저 인증 시스템 만들어줘
```

The leader agent:
1. Decides if a team is needed (small tasks skip the team)
2. Has PM write a PRD with acceptance criteria
3. Has engineer implement based on the PRD
4. Has QA write and run tests against the acceptance criteria
5. If tests fail, sends fixes back to engineer (max 3 retries)
6. Reports what was built

Check progress:
```
/macrohard-teams:status
```

## Team

| Agent | Model | Writes to | Enforced by |
|-------|-------|-----------|-------------|
| leader | Opus | orchestration only | never implements |
| product-pm | Sonnet | docs/product/, docs/specs/ | PreToolUse hook |
| eng-lead | Opus | src/, package* | PreToolUse hook |
| qa-tester | Sonnet | tests/, e2e/ | PreToolUse hook |

Boundaries are **physically enforced** — agents that try to write outside their directories get blocked with exit code 2.

## How it works

### Wave-based execution

Tasks run in dependency-based waves, not fixed stages:
- **Independent tasks** (zero file overlap) → parallel (proven 1.75x speedup)
- **Dependent tasks** → sequential (PRD before implementation, implementation before tests)

### Hooks

| Hook | Event | Purpose |
|------|-------|---------|
| enforce-boundary.sh | PreToolUse (Write/Edit) | Blocks agents from writing outside their directories |
| enforce-commit.sh | PreToolUse (Bash) | Requires Conventional Commits format |
| log-decision.sh | PostToolUse (Write/Edit) | Logs every file change to decisions.jsonl |
| teammate-gate.sh | TeammateIdle | Blocks agents from going idle without deliverables |
| task-complete-gate.sh | TaskCompleted | Logs task completions |
| inject-context.sh | SubagentStart | Reminds agents of their boundaries on startup |

## Repository structure

```
macrohard-teams/
├── .claude-plugin/
│   ├── marketplace.json    # Marketplace catalog (source: ".")
│   └── plugin.json         # Plugin manifest (v2.0.0)
├── agents/                 # 4 agent specs
│   ├── leader.md
│   ├── product-pm.md
│   ├── eng-lead.md
│   └── qa-tester.md
├── hooks/
│   └── hooks.json          # 6 hook events
├── scripts/                # 6 enforcement scripts
├── skills/
│   ├── build/SKILL.md      # /macrohard-teams:build
│   └── status/SKILL.md     # /macrohard-teams:status
└── README.md
```

## Research basis

Design decisions are backed by 18 research sources across 8 iterations with zero contradictions:

- **Anthropic Official Docs** — 3-5 teammates optimal, file locking prevents conflicts
- **Google Research** — sequential tasks degrade -70% with more agents
- **Nicholas Carlini (Anthropic)** — tests are the primary control mechanism
- **Addy Osmani** — planner-worker-judge hierarchy
- **Alex Lavaee** — Cursor + Anthropic converged on same 5 primitives independently

## License

MIT

# macrohard-teams

A Claude Code plugin for self-propagating agent teams with institutional memory, research-driven evolution, and convergence detection.

## What it does

Turns any project into an AI-only startup where agents research, design, build, test, and evolve their own team composition through a structured loop called "ralph-loop".

**Core concepts:**
- **Institutional Memory** — decisions, research, experiments, and retrospectives persist across sessions in `.macrohard-memory/`
- **Context Boundaries** — each agent can only write to specific directories, enforced by PreToolUse hooks
- **Research-Driven Evolution** — team composition changes are backed by web research with reliability scoring
- **Convergence Detection** — the system detects when the team composition has stabilized and stops evolving

## Installation

```bash
# Test locally
claude --plugin-dir ./macrohard-teams

# Or install from a marketplace (when published)
# /plugin install macrohard-teams
```

## Skills (slash commands)

| Command | Description |
|---------|-------------|
| `/macrohard-teams:init` | Initialize self-propagating team in current project |
| `/macrohard-teams:loop` | Run one iteration of the ralph-loop |
| `/macrohard-teams:status` | Check current team state and convergence |
| `/macrohard-teams:research` | Run standalone research phase |
| `/macrohard-teams:retro` | Run a retrospective on recent work |

## Agents

| Agent | Model | Role | Writable Directories |
|-------|-------|------|---------------------|
| `leader` | Opus | Orchestrator, researcher, decision-maker | ALL |
| `product-pm` | Sonnet | PRD writer, feature definitions | docs/product/, docs/specs/ |
| `eng-lead` | Opus | Code implementation, architecture | src/, package* |
| `qa-tester` | Sonnet | Test writer, bug reporter | tests/, e2e/ |

## Hooks

| Event | Script | Purpose |
|-------|--------|---------|
| SessionStart | session-start.sh | Load institutional memory, inject resume context |
| PreToolUse (Write/Edit) | enforce-boundary.sh | Block context boundary violations |
| PreToolUse (Bash) | enforce-commit.sh | Enforce Conventional Commits format |
| PostToolUse (Write/Edit) | log-decision.sh | Log all file changes to decisions.jsonl |
| Stop | loop-gate.sh | Block stop until commits + retros + experiments done |
| TeammateIdle | teammate-gate.sh | Verify teammate deliverables before idle |
| TaskCompleted | task-complete-gate.sh | Log task completion |
| SubagentStart | inject-context.sh | Inject boundary rules into subagent context |

## Directory structure

```
macrohard-teams/
├── .claude-plugin/
│   └── plugin.json           # Plugin manifest
├── agents/
│   ├── leader.md             # Orchestrator agent
│   ├── product-pm.md         # Product manager agent
│   ├── eng-lead.md           # Engineering lead agent
│   └── qa-tester.md          # QA specialist agent
├── hooks/
│   └── hooks.json            # Hook event configuration
├── scripts/
│   ├── enforce-boundary.sh   # Context boundary enforcement
│   ├── enforce-commit.sh     # Conventional Commits validation
│   ├── log-decision.sh       # Decision logging
│   ├── inject-context.sh     # Subagent context injection
│   ├── teammate-gate.sh      # Teammate deliverable verification
│   ├── task-complete-gate.sh # Task completion logging
│   ├── loop-gate.sh          # Stop gate (commits + retros)
│   └── session-start.sh      # Institutional memory loader
├── skills/
│   ├── init/SKILL.md         # Initialize team
│   ├── loop/SKILL.md         # Run ralph-loop iteration
│   ├── status/SKILL.md       # Check team status
│   ├── research/SKILL.md     # Standalone research
│   └── retro/SKILL.md        # Run retrospective
└── README.md
```

## Quick start

```bash
# 1. Load the plugin
claude --plugin-dir ./macrohard-teams

# 2. Initialize the team in your project
/macrohard-teams:init

# 3. Run the first research + evolution loop
/macrohard-teams:loop

# 4. Check status
/macrohard-teams:status
```

## First Principles (converged from 18 research sources)

1. Context boundary creates role
2. Institutional memory > individual capability
3. Every decision must be traceable
4. Context isolation is structural
5. File ownership prevents conflicts
6. 3-5 workers optimal
7. Knowledge base must be pruned
8. Plan-before-parallelize

## Research

The ralph-loop has processed 18 research sources across 8 iterations with zero contradictions, converging on 22 synthesized principles. Key sources include Anthropic official docs, Google Research scaling studies, Nicholas Carlini's C compiler project, and Addy Osmani's self-improving agents work.

## License

MIT

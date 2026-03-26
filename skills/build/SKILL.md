---
name: build
description: Build a feature with a coordinated agent team. Takes a feature description and orchestrates PM, engineer, and QA through wave-based execution. Use when you want to build something non-trivial that needs PRD, implementation, and tests.
disable-model-invocation: true
context: fork
agent: leader
---

Build the following feature using the team:

$ARGUMENTS

Execute the full pipeline:

1. Decide if a team is needed for this task. If it's a single-file change, do it directly without the team.

2. If team is needed:
   - Create project directories if missing: docs/product/, docs/specs/, src/, tests/, e2e/
   - Delegate PRD to product-pm first (plan cheaply before expensive execution)
   - Wait for PRD, review acceptance criteria
   - Decompose remaining work into dependency-based waves
   - Execute waves: parallel for independent tasks, sequential for dependent ones
   - After implementation, have qa-tester verify against PRD acceptance criteria
   - If tests fail, create fix tasks for eng-lead (max 3 retry cycles)

3. When done, summarize:
   - What was built (files created/modified)
   - Test results (pass/fail)
   - Any open questions from the PRD that need user input

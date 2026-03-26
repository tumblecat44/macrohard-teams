---
name: research
description: Run a standalone research phase — search for new agent team practices, score sources, update synthesis. Use when you want to add knowledge without running a full loop iteration.
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Glob, Grep, WebSearch, WebFetch
---

# Standalone Research Phase

Run Phase 0 (RESEARCH) independently without advancing the full loop.

## Steps

1. **Read current state**:
   - `.macrohard-memory/research/synthesis.md` — check search history to rotate keywords
   - `.macrohard-memory/research/sources.jsonl` — count existing sources, find last ID

2. **Search** using 2-3 keywords from the rotation schedule:
   - Batch 1: Agent Teams Fundamentals
   - Batch 2: AI-only Companies / Agent Swarms
   - Batch 3: Institutional Memory / Self-improvement
   - Batch 4: First Principles / Failure Patterns
   - Only accept content published after 2026-02-05

3. **Score each source** (1-5 reliability):
   | Score | Meaning | Example |
   |-------|---------|---------|
   | 5 | Primary source, author is practitioner | Anthropic docs, research papers |
   | 4 | Detailed case study with code | Engineering blogs with repos |
   | 3 | Informed analysis, cites primary sources | Tech blogs citing Anthropic |
   | 2 | General overview, no original data | News articles, summaries |
   | 1 | Unverified claim, no sources | Social media, forum comments |

4. **Append to sources.jsonl** with full metadata

5. **Update synthesis.md**:
   - Add new principles if convergent across 2+ sources
   - Update existing principle source counts
   - Check promotion candidates
   - Record search in history table

6. **Check for contradictions** against existing principles

7. **Report findings**: new sources added, principles updated, contradictions found

Goal: Find CONVERGENT TRUTHS across sources. Not collect articles.

$ARGUMENTS

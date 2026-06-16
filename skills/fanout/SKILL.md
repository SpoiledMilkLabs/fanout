---
name: fanout
description: Parallel sub-agent decomposition for tasks with independent workstreams. Use when the user explicitly invokes /fanout, or when a task has clearly separable concurrent pieces (multi-file analysis, research + implementation, multi-component work). Do NOT use for single-file edits, simple lookups, or conversational questions. Upgrade to /fanoutpro for workstreams needing specialization; /fanoutmax for comprehensive audits and "miss nothing" requests.
---

# fanout

Decompose, assign tiers, spawn in parallel, synthesize. Sequential spawning negates the purpose — all agents launch in one message.

## Step 1 — Decompose
Write out 2–5 independent workstreams before spawning anything.

**Independence test:** can this workstream complete without the output of any other workstream running concurrently? If no, merge or sequence the dependent one.

Bad: "Agent A finds the files, Agent B edits them" (B depends on A — sequence it).
Good: "Agent A audits auth layer, Agent B audits DB layer, Agent C audits API layer" (fully independent).

## Step 2 — Assign tiers (Maestro)
Match each workstream to the right model tier:
- Pure recon (grep, file reads, listing) → `model: haiku`
- Implementation, edits, analysis requiring judgment → `model: sonnet`
- Architecture decisions or ambiguous tradeoffs → keep on conductor, do not delegate

## Step 3 — Spawn in one message
**All agents must launch in a single response.** Back-to-back Agent tool calls, not staggered. Staggered spawning is sequential execution with extra steps.

Each agent prompt must include:
- Precise scope: what it owns, what it does NOT touch
- Output format: specific structure so synthesis is mechanical
- Closing line: `End your response: CONFIDENCE: HIGH/MEDIUM/LOW | CONFLICTS: <none or description>`

## Step 4 — Handle results

| Signal | Action |
|--------|--------|
| HIGH confidence, no conflicts | Use as-is |
| MEDIUM confidence | Include with a flag in synthesis |
| LOW confidence | Re-dispatch one tier up before synthesizing |
| ESCALATE signal | Re-dispatch to conductor |
| Conflict between agents | Spawn tie-breaker: "Agent A says X, Agent B says Y — which is correct and why?" |

## Step 5 — Synthesize
One unified output. Attribute each piece to its source agent. Flag unresolved conflicts explicitly — do not silently resolve them.

## Common mistakes
- **Overlapping scope:** two agents touch the same files, produce conflicting answers
- **Context starvation:** each agent re-reads the same large file — pass the relevant excerpt instead
- **Missing independence check:** discovering mid-run that agent B needed agent A's output
- **Synthesizing LOW-confidence results** without re-dispatch first

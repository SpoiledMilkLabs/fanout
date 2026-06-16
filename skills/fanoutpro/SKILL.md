---
name: fanoutpro
description: Advanced parallel decomposition with pre-flight context gathering, per-agent lens specialization, cross-validation of critical findings, and a dedicated synthesis agent. Use when the user explicitly invokes /fanoutpro, or for tasks needing both speed and quality: multi-component code reviews, multi-source research synthesis, parallel implementation with verification. Upgrade to /fanoutmax when comprehensive "miss nothing" audit coverage is required.
---

# fanoutpro

Everything in `/fanout` plus four upgrades: pre-flight context scout, specialized lenses, cross-validation, dedicated synthesis agent.

## Step 0 — Pre-flight context scout
Before spawning workers, send one haiku scout to gather shared context:
> "Read [key entry points / interfaces / config]. Return: file tree, key interfaces, existing patterns relevant to this task. Be concise — this output becomes context for N parallel agents."

Inject that excerpt into every worker prompt. This prevents N agents each spending budget re-reading the same files.

## Step 1 — Decompose + assign tiers
Same as `/fanout`. 2–5 independent workstreams. Match haiku / sonnet / conductor per workstream type.

## Step 2 — Specialize with lenses
Rather than identical prompts for similar workstreams, assign each agent a distinct angle:
- `[Security lens]` — auth gaps, injection vectors, privilege escalation
- `[Performance lens]` — N+1 queries, blocking I/O, hot paths
- `[Correctness lens]` — logic errors, edge cases, null handling, off-by-ones

Same target, different angle. Each lens catches what the others won't.

## Step 3 — Spawn in one message
All workers launch together with their pre-flight context excerpt included in each prompt.

## Step 4 — Cross-validate critical findings
After workers complete, identify the 2–3 most critical findings. For each, spawn a verifier:
> "Agent reported: [finding]. Reproduce this independently or refute it. Return: CONFIRMED / REFUTED + evidence."

- **CONFIRMED** by independent verifier → high-confidence, include in synthesis
- **REFUTED** → do not silently drop. Note the conflict: "Finding [X] was reported but could not be independently reproduced."

## Step 5 — Synthesis agent
Spawn one dedicated synthesis agent — do not synthesize ad-hoc on the conductor:
> "Here are [N] agent outputs and [M] verification results: [structured list]. Produce a unified summary with source attribution. Flag all conflicts. Rank findings by severity."

The synthesis agent integrates. The conductor reviews and presents to the user.

## Step 6 — Handle escalations
LOW confidence or failed cross-validation → re-dispatch one tier up. Conflicts the synthesis agent cannot resolve → return to conductor as explicit tie: "human decision needed on [X vs Y]."

## When to upgrade
Need adversarial refutation and a completeness sweep → `/fanoutmax`.

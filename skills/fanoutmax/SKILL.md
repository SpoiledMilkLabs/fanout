---
name: fanoutmax
description: Maximum parallel coverage with adversarial verification, completeness critic, and loop-until-dry exhaustion. Use when the user explicitly invokes /fanoutmax, or for: comprehensive security audits, full codebase reviews, "find everything / miss nothing" requests. Spawns 10–20 agents. Token-heavy by design — goal is correctness and coverage, not speed. For lighter parallelism use /fanout (speed) or /fanoutpro (quality + speed).
---

# fanoutmax

Everything in `/fanoutpro` plus: adversarial refutation layer, completeness critic, and loop-until-dry with hard caps.

## Declare limits before starting (always)
State upfront before any agents launch:
> "fanoutmax: ~[N] agents estimated. Hard caps: 20 agents total, 3 completeness rounds. Starting."

When a cap is hit, log it — never claim full coverage if a cap was reached:
> "Cap hit at round [N]. [M] items uncovered, logged, not silently dropped."

## Phase 1 — Decompose + Pre-flight
Pre-flight haiku scout → shared context. Decompose into 3–7 specialized workstreams with distinct lenses (security / perf / correctness / UX / etc.). Launch all in one message.

## Phase 2 — Adversarial layer
After workers complete, for each major finding (threshold: "would I act on this finding alone?"):

Spawn **3 skeptic agents** per finding:
> "Finding: [finding]. Your job is to REFUTE this. Assume it is wrong until you cannot prove otherwise. Return: REFUTED: [evidence] OR CONFIRMED: [could not refute because...]"

**Vote rule:**
- ≥2 of 3 refute → finding is dropped. Log: "Refuted by adversarial pass: [reason]"
- 1 of 3 refutes → finding survives, flagged: "Adversarial: 1/3 skeptics refuted"
- 0 of 3 refute → finding is high-confidence

Why 3, not 1: a single skeptic can be wrong. 2-of-3 majority is the signal threshold.

## Phase 3 — Completeness critic
Spawn one completeness critic after the adversarial pass:
> "We ran [N] agents covering: [list of workstreams and lenses]. What did we NOT cover? Be specific — list angles, files, edge cases, or assumptions not examined. Generalities don't count."

Each specific gap the critic identifies → new workstream to fill.

## Phase 4 — Loop-until-dry
Fill the gaps from the completeness critic. Re-run the critic after each round.

**Stop when any of these are true (whichever comes first):**
1. Critic finds no new gaps
2. Round 3 completes (hard cap, non-negotiable)
3. New gaps in round N are <10% of round 1 gap count (diminishing returns)

## Phase 5 — Synthesis
Synthesis agent receives: all worker outputs + adversarial pass results + coverage map.

Output must include:
- Findings that survived adversarial verification (confidence rating per finding)
- Findings that were refuted (with reason — never silently omit them)
- Coverage map: what was examined, what was capped or skipped
- Unresolvable conflicts → return to conductor: "Tie: human decision needed on [X vs Y]"

## Failure handling

| Failure | Response |
|---------|----------|
| Agent returns LOW confidence | Re-dispatch one tier up, same task |
| Agent timeout / empty result | Log "workstream [N] incomplete", do not fill with assumption |
| Synthesis conflict unresolvable | Surface to conductor as explicit tie |
| Cap hit mid-run | Log remainder, surface in final output |

## What fanoutmax is NOT for
- Simple questions with knowable answers (use the conductor directly)
- Tasks where speed matters more than coverage (use `/fanout`)
- Tasks where one verification pass is sufficient (use `/fanoutpro`)
- Tasks that cannot be decomposed into independent workstreams (fix the decomposition first)
- More than ~50 natural workstreams (the decomposition is wrong — restructure)

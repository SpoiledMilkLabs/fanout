# fanout

**Three Claude Code skills for parallel sub-agent execution. Speed, quality, and maximum coverage — pick the tier.**

A companion to [Maestro](https://github.com/SpoiledMilkLabs/maestro). Works without it, but pairs well.

## What these are

Three slash commands that change how Claude approaches a task — from one sequential thread of work to N parallel sub-agents running simultaneously.

- `/fanout` — decompose and run independent workstreams in parallel. The speed tier.
- `/fanoutpro` — adds a pre-flight context scout, per-agent lens specialization, cross-validation of critical findings, and a dedicated synthesis agent. The quality + speed tier.
- `/fanoutmax` — adversarial verification (3 skeptics per finding, majority vote), completeness critic, and loop-until-dry exhaustion. The coverage tier.

## The honest part first

These are markdown skills. Structured prompt instructions. They tell Claude *how* to decompose and delegate work — they don't add any new API capability Claude didn't already have.

What they do: eliminate the habit of running tasks sequentially when the workstreams are actually independent. Most complex tasks have 3–5 natural parallel slices. Running them one after another when they don't depend on each other is just slow.

What they don't do: they can't force Claude to spawn agents if your permissions don't allow it, they can't guarantee the decomposition is always optimal, and they won't save you tokens on a task that's genuinely sequential.

## How the tiers map

| Skill | Goal | Typical agent count | Use when |
|-------|------|---------------------|----------|
| `/fanout` | Speed | 2–5 | Task has parallel workstreams, you want results fast |
| `/fanoutpro` | Speed + quality | 5–10 | Code review, research synthesis, parallel analysis with verification |
| `/fanoutmax` | Coverage | 10–20 | Audit, "find everything", "miss nothing" requests |

## Install

```bash
git clone https://github.com/SpoiledMilkLabs/fanout.git
cd fanout
./install.sh
```

`install.sh` copies the three skills into `~/.claude/skills/`. That's it.

To install manually:

```bash
mkdir -p ~/.claude/skills/fanout ~/.claude/skills/fanoutpro ~/.claude/skills/fanoutmax
cp skills/fanout/SKILL.md ~/.claude/skills/fanout/SKILL.md
cp skills/fanoutpro/SKILL.md ~/.claude/skills/fanoutpro/SKILL.md
cp skills/fanoutmax/SKILL.md ~/.claude/skills/fanoutmax/SKILL.md
```

Then restart Claude Code. The `/fanout`, `/fanoutpro`, and `/fanoutmax` commands are available immediately.

## How `/fanout` works

1. **Decompose** — write out 2–5 independent workstreams. Independence test: can this workstream complete without the output of any other? If no, merge or sequence it.
2. **Assign tiers** — recon tasks get `model: haiku`, implementation gets `model: sonnet`, architecture decisions stay on the conductor. Works with [Maestro](https://github.com/SpoiledMilkLabs/maestro) tier routing.
3. **Spawn in one message** — all agents launch simultaneously. Sequential spawning is just slow sequential execution with extra steps.
4. **Handle signals** — each agent ends with `CONFIDENCE: HIGH/MEDIUM/LOW`. LOW triggers re-dispatch one tier up before synthesis.
5. **Synthesize** — one unified output with source attribution. Conflicts are flagged, not silently resolved.

## How `/fanoutpro` upgrades this

- **Pre-flight scout** — one haiku agent reads shared context once and passes excerpts to all workers. Prevents N agents each re-reading the same 500-line file.
- **Lens specialization** — security / performance / correctness angles instead of identical prompts. Same target, different perspective.
- **Cross-validation** — top 2–3 findings each get an independent verifier. A finding that can't be reproduced doesn't silently make it to synthesis.
- **Synthesis agent** — synthesis is its own dedicated job, not an afterthought.

## How `/fanoutmax` adds adversarial coverage

- **3-skeptic vote** — each major finding gets 3 agents whose job is to refute it. 2-of-3 refute = finding dropped (logged). 0-of-3 refute = high-confidence.
- **Completeness critic** — after every round, one agent asks "what did we NOT cover?" Each specific gap becomes a new workstream.
- **Loop-until-dry** — fill gaps, re-run critic. Stop when the critic finds nothing, or after 3 rounds (hard cap).
- **Transparent caps** — fanoutmax declares its estimate upfront and logs exactly what was cut when a cap is hit. It never claims full coverage when it didn't finish.

## What fanout is not for

- Simple questions (the conductor handles these directly)
- Tasks with hidden sequential dependencies (fix the decomposition before fanning out)
- Saving tokens (fanoutmax is explicitly a coverage-over-economy trade)
- More than ~50 natural workstreams (the decomposition is wrong — restructure first)

## Pair with Maestro

fanout skills use the same scout / builder / conductor tier vocabulary as [Maestro](https://github.com/SpoiledMilkLabs/maestro). They work independently but the combination is cleaner: Maestro routes individual tasks, fanout decomposes tasks into parallel streams and routes each stream by type.

## Credit

Built on documented Claude Code features: the Agent tool, per-agent model overrides, and parallel tool calls. Nothing private, nothing that breaks on the next release.

Part of [SpoiledMilkLabs](https://github.com/SpoiledMilkLabs).

# Copus Team

A two-model collaborative agent-team workflow for Claude Code: **Claude Opus**
agents draft frozen specs and review diffs while **OpenAI Codex
(gpt-5.6-sol)** adversarially critiques every spec and implements it — with the
main Claude Code session as orchestrator, seam-checker, and independent
verifier. Cross-model disagreement is the feature: plausible-but-wrong designs
rarely survive a reviewer from a different vendor.

Born from a real production run (a private payment-privacy build on a
three-chain stack) where the adversarial pass independently rediscovered a
flaw the orchestrator had found and withheld as a canary — and then found nine
more blockers on top.

## Variants

Two families: the **review-heavy** spec pipeline (x, max) and the **fast
parallel team** (medium, high).

| Command | Worker agent | Effort | Use for |
|---|---|---|---|
| `/copus-medium` | `copus-opus-medium` | `medium` | Default for delegated work: small owned tasks in parallel, one review pass. Cheapest. |
| `/copus-high` | `copus-opus-high` | `high` | Same fast team when a task needs more depth. |
| `/copus-x` | `copus-opus-x` | `xhigh` | Frozen-spec pipeline with Codex adversarial critique: feature waves, refactors, protocol work. |
| `/copus-max` | `copus-opus-max` | `max` | Hardest problems: novel crypto, consensus-critical accounting, irreversible migrations. |

Codex is pinned to `gpt-5.6-sol` in the x and max variants. In medium and
high, Codex critique is optional and capped at two rounds.

## Pipelines

Spec pipeline (`/copus-x`, `/copus-max`):

```
Opus spec agent  → drafts FROZEN spec           (parallel per workstream; read-only)
Codex            → adversarial critique          (verifies every claim vs real code)
same Opus agent  → revises using the critique    (context intact via SendMessage)
Codex            → implements the frozen spec    (overlapping-file waves serialized)
Opus reviewer    → reviews the diff              (optional for small waves)
orchestrator     → re-runs EVERY gate, commits
```

Fast team (`/copus-medium`, `/copus-high`):

```
lead     → split the job into small tasks, one deliverable and owned files each
workers  → 3-5 workers in parallel, one task each (no shared files)
lead     → commit each result, run the gates, push
review   → ONE pass, 2-3 reviewers in parallel, one lens each, GO/NO-GO
workers  → fix findings in the same pass
lead     → re-run gates, merge
```

## Install

```bash
git clone https://github.com/ItachiDevv/copus-team.git
cd copus-team
bash install.sh            # copies skills to ~/.claude/skills, agents to ~/.claude/agents
bash install.sh --check    # reports drift between this repo and the installed copies
```

Or copy by hand:

```
skills/copus-<variant>/SKILL.md  → ~/.claude/skills/copus-<variant>/SKILL.md
agents/copus-opus-<variant>.md   → ~/.claude/agents/copus-opus-<variant>.md
```

The agent definitions pin `model: opus` and `reasoningEffort`, so workers run
at the intended depth. New agent types register at session start.

**Effort trap:** spawn workers with the agent type and **no `name`**. A named
spawn becomes an agent-team teammate and inherits the lead's effort instead of
the definition's.

## Requirements

- Claude Code with the Agent tool (subagents) and background Bash.
- For the x and max variants: OpenAI Codex CLI (`codex exec`) authenticated,
  with `~/.codex/config.toml` containing `sandbox_mode = "danger-full-access"`
  and `approval_policy = "never"` (on native Windows, requesting
  `workspace-write` silently downgrades Codex to read-only — the skills
  document this trap).

## Notes

- The orchestrator never trusts agent-reported results: every build/test gate
  is re-run in the main session before commit.
- Parallel spec agents are written blind to each other; the orchestrator owns
  cross-spec seam reconciliation and feeds known seams into critique prompts.
- Secrets never enter prompts, reports, logs, or stdout.

## License

MIT

---
name: copus-high
description: Copus Team (high) — fast agent team for bounded design + implementation. Opus 5 workers at HIGH effort take small owned tasks in parallel; one single-pass review with parallel lenses; the lead (higher effort) splits work, does long waits, verifies, commits, and merges. Use when speed matters more than multi-round review.
---

# Copus Team — HIGH variant (speed first)

The lead session (you) orchestrates at its own effort. Workers run Opus 5 at
HIGH effort. The goal is faster delivery: more parallel work, fewer and
shorter review rounds.

## Effort: how to get HIGH workers

- Spawn workers with `subagent_type: "copus-opus-high"` and NO `name`. An
  unnamed agent is an ordinary sub-agent, so its definition's
  `reasoningEffort: high` applies.
- A NAMED agent launches as an agent-team teammate, and the docs say teammates
  inherit the lead's effort level. So naming a worker raises it to the lead's
  effort. Name a worker only when it must take messages mid-task.
- To continue an unnamed worker, SendMessage to its agent id.
- A new agent definition can take a while to load in a running session
  (2026-10-01: about 80 min). Until the Agent tool lists `copus-opus-high`,
  run the team as a Workflow instead (`agent(prompt, { effort: "high",
  schema })`; the Workflow `effort` setting is always honored). The owner
  asked for the copus process at high effort, which counts as the opt-in for
  that Workflow.
- Owner rule (2026-10-01): the lead runs at its own (higher) effort; workers
  and reviewers run at HIGH. Workers make the process faster; they do not add
  review rounds.

## Pipeline (per job)

```
lead     → split the job into small tasks, one deliverable and owned files each
workers  → 3-5 copus-opus-high in parallel, one task each (no shared files)
lead     → commit each result, run the gates, push
review   → ONE pass, 2-3 copus-opus-high in parallel, one lens each
           (money path / privacy / CLI + answers), GO/NO-GO + ranked findings
workers  → fix every finding (BLOCKER, MAJOR and MINOR) in the same pass; a fix
           too large for the pass becomes a task on the board, never a note
lead     → re-run gates, merge
```

No revision loops. A second review pass happens only for a BLOCKER fix, and
only on that fix's diff. Codex adds a critique only when the owner asks for
it or the change is a new on-chain program; its rounds stay at 2 or fewer.
The helper session (if one exists) replaces a third round.

## Lead duties

- Write every fact a worker needs into its prompt: files to read, files it
  owns, the exact change, the gates to run, what it must not do.
- Keep a board file (`team-board-<date>.md` in the repo root) when the session
  has no Task tools: task, files, owner, state.
- Do the long waits yourself (live dwell times, CI, deploy gates). Never give
  a worker a multi-hour wait.
- Verify every claim yourself before a merge: diff, gates, chain signatures.
- Commit with the project's rules (no trailers where the owner said so).

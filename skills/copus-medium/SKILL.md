---
name: copus-medium
description: Copus Team (medium) — the DEFAULT agent team since 2026-10-11. Opus 5.5 workers at MEDIUM effort take small owned tasks in parallel; one single-pass review with parallel lenses; the lead splits work, does long waits, verifies, commits, and merges. Use for all delegated work unless the owner asks for /copus-high.
---

# Copus Team — MEDIUM variant (default, token economy)

Owner rule (2026-10-11): Opus 5.5 at HIGH uses the subscription too fast.
Sub-agents run at MEDIUM by default. HIGH (`/copus-high`) is only for a task
the owner names, or a money/fairness/security review lens that MEDIUM could
not finish.

## Effort: how to get MEDIUM workers

- Spawn workers with `subagent_type: "copus-opus-medium"` and NO `name`. An
  unnamed agent is an ordinary sub-agent, so its definition's
  `reasoningEffort: medium` applies.
- Do NOT pass the Agent tool's `effort` field on your own judgment; the agent
  definition sets it.
- A NAMED agent launches as an agent-team teammate and inherits the lead's
  effort. Name a worker only when it must take messages mid-task.
- To continue an unnamed worker, SendMessage to its agent id.
- Until the Agent tool lists `copus-opus-medium` (new definitions can take a
  while to load), run the team as a Workflow with `effort: "medium"`.

## Pipeline (per job)

```
lead     → split the job into small tasks, one deliverable and owned files each
workers  → 3-5 copus-opus-medium in parallel, one task each (no shared files)
lead     → commit each result, run the gates, push
review   → ONE pass, 2-3 copus-opus-medium in parallel, one lens each
           (money path / privacy / CLI + answers), GO/NO-GO + ranked findings
workers  → fix BLOCKER/MAJOR findings in the same pass
lead     → re-run gates, merge
```

No revision loops. Codex rounds stay at 2 or fewer (r1 full list, r2 fix
delta); after that only HIGH money/fairness/security findings block.

## Lead duties

- Write every fact a worker needs into its prompt: files to read, files it
  owns, the exact change, the gates to run, what it must not do.
- Keep prompts tight: point at file ranges, not "read the repo".
- Keep a board file when the session has no Task tools.
- Do the long waits yourself (live dwell times, CI, deploy gates).
- Verify every claim yourself before a merge: diff, gates, chain signatures.

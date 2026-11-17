---
name: copus-x
description: Copus Team (X) — two-model agent team for high-stakes design + implementation. Opus 5 agents at XHIGH reasoning effort draft frozen specs and review diffs; Codex (gpt-5.6-sol) adversarially critiques every spec and implements it; the main session orchestrates, cross-checks seams, and independently verifies every gate before committing.
---

# Copus Team — X variant (Opus 5 @ xhigh + Codex gpt-5.6-sol)

Two-model pipeline for work where a solo one-shot agent isn't good enough:
cross-model adversarial review BEFORE implementation, frozen specs, and
independent verification of every claim. The main session (you) is the
orchestrator and message bus — you are the only party that can talk to both
model ecosystems.

## Pinned models — do not substitute

| Role | Model | How |
|---|---|---|
| Spec author / reviser / diff reviewer | **Claude Opus 5 @ xhigh effort** | Agent tool, `subagent_type: "copus-opus-x"` (definition pins model+effort). Fallbacks if that agent type is unavailable: Agent tool `model: "opus"`, or a Workflow `agent(prompt, { model: "opus", effort: "xhigh" })` — the Workflow `effort` knob is always honored. |
| Adversarial critic / implementer | **Codex gpt-5.6-sol** | `codex exec -m gpt-5.6-sol` in background via Bash. |

**Codex-on-Windows rule (hard-won):** run `codex exec` with NO sandbox flag so
it inherits `sandbox_mode = "danger-full-access"` + `approval_policy = "never"`
from `~/.codex/config.toml`. Requesting `workspace-write` on native Windows
silently downgrades the session to READ-ONLY. Always verify the run header
prints `sandbox: danger-full-access` and the expected model before trusting a
run. Codex cannot spawn or manage Claude agents — the orchestrator relays.

Codex launch template (Bash, `run_in_background: true`):

```bash
codex exec -m gpt-5.6-sol -C "<repo>" -o "<scratchpad>/reports/<name>-report.md" - \
  < "<scratchpad>/prompts/<name>-prompt.md" > "<scratchpad>/logs/<name>-log.txt" 2>&1
```

## Pipeline (per workstream)

```
Opus spec agent  → drafts FROZEN spec           (parallel across workstreams; read-only)
Codex            → adversarial critique          (read-only; verify vs real code)
same Opus agent  → revises using the critique    (SendMessage — context intact)
Codex            → implements the frozen spec    (serialize overlapping-file waves)
Opus reviewer    → reviews the diff              (optional for small waves)
orchestrator     → re-runs EVERY gate, commits
```

### Phase 1 — Parallel Opus specs
One named agent per workstream (`name: "spec-<workstream>"`,
`subagent_type: "copus-opus-x"`). Read-only: spec only, no repo edits. Prompt
must demand: read the real code first (list exact files); every name taken
from live code, never guessed; write the spec to a shared specs dir; return a
15-line executive summary. Required spec sections:
1. File-by-file change list (NEW files marked)
2. Exact TypeScript/language signatures for public APIs
3. JSON schemas for persisted state + wire bodies
4. New env vars/config + doc lines
5. Decision tables for anything per-platform/per-variant
6. Offline smoke-test plan with every check enumerated
7. Docs to update in the same diff
8. Honest limitations/residual-risk statement
9. Migration/rollout (feature flag, default off)
10. Open questions (only genuinely unresolvable ones)

### Phase 2 — Codex adversarial critique (one per spec, parallel OK — read-only)
Prompt Codex to BREAK the spec: verify every code reference against the actual
repo; walk state × crash × restart matrices; check concurrency, idempotency,
accounting invariants, security boundaries, and honesty of privacy/limitation
claims; verify crypto against the INSTALLED library exports (node_modules),
not remembered docs. Output: verdict (APPROVE / APPROVE-WITH-FIXES / REJECT),
severity-ranked findings (BLOCKER/MAJOR/MINOR) each with repo evidence + a
concrete fix, plus a list of claims verified CORRECT.
**Orchestrator discipline:** if you spotted flaws yourself, WITHHOLD them from
the critique prompt — an independent find validates the pass; inject anything
Codex missed at revision time.

### Phase 3 — Opus revision
SendMessage the critique file path + your own findings to the SAME spec agent.
It revises in place and re-freezes. REJECT verdicts loop back through Phase 2.

### Phase 4 — Codex implementation
Hand the frozen spec verbatim (file path) plus: explicit gate list, "no live /
spending / secret-touching commands", "report file required". Serialize waves
that touch overlapping files — parallel implementation in one working tree is
how merges go wrong. Monitor via `git diff --stat` growth and log tails, not
completion notifications alone.

### Phase 5/6 — Verify, then commit
Never trust agent-reported results. The orchestrator personally re-runs every
gate (build, every named smoke, dry-runs) and reads the diff. Optionally spawn
a `copus-opus-x` reviewer for large diffs. Then commit with attribution
(note which model implemented and which reviewed), push, deploy per project
rules.

## Orchestrator duties that no agent covers

- **Cross-spec seam checks.** Parallel spec agents are blind to each other.
  Before implementation, reconcile shared interfaces, name collisions, and
  ordering (which spec defines the interface the next one builds on). Put
  known seams INTO the critique prompts.
- **Event-driven progression.** Agents notify on completion; act on each event
  (spec landed → critique; critique landed → revision; ...). Give the user a
  status line at each commit.
- **Secrets hygiene.** Secrets never appear in prompts, reports, logs, or
  stdout. Key material goes in mode-600 gitignored files only.
- **Escalate disagreements.** When Opus and Codex genuinely disagree on a
  design point, don't silently pick — surface the disagreement and your
  recommendation to the user.

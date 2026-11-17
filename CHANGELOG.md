# Changelog

## 1.2.0 — 2026-11-16

- Added the fast parallel-team variants: `/copus-medium` (default,
  `copus-opus-medium` at medium effort) and `/copus-high` (`copus-opus-high` at
  high effort). One deliverable per worker, one review pass, no revision loops.
- Added `install.sh` (install all skills and agents; `--check` reports drift).
- Replaced the repo-level CLAUDE.md/AGENTS.md (an accidental copy of the
  authoring folder's notes) with unit-specific maintainer notes.
- Added the MIT license.

## 1.1.0 — 2026-07-25

- Model bump: all Opus spec/review agent references updated from Opus 4.8 to
  Opus 5 (skills, agent descriptions, README). The `model: opus` frontmatter
  pin is unchanged — it aliases to the latest Opus, now `claude-opus-5`.

## 1.0.0 — 2026-07-23

- Initial release: `/copus-x` (Opus 4.8 @ xhigh + Codex gpt-5.6-sol) and
  `/copus-max` (Opus 4.8 @ max + Codex gpt-5.6-sol) skills, plus pinned
  `copus-opus-x` / `copus-opus-max` agent definitions.
- Workflow extracted from a private payment-privacy build
  (4 parallel frozen specs → 4 adversarial critiques → revision → serialized
  implementation waves), where the critique pass independently found a
  withheld canary flaw plus additional blockers.

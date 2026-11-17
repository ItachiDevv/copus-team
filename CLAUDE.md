# copus-team — maintainer notes

This repo ships four Claude Code skills and four agent definitions:

| Skill | Agent | Effort |
|---|---|---|
| `skills/copus-medium` | `agents/copus-opus-medium.md` | medium (default) |
| `skills/copus-high` | `agents/copus-opus-high.md` | high |
| `skills/copus-x` | `agents/copus-opus-x.md` | xhigh |
| `skills/copus-max` | `agents/copus-opus-max.md` | max |

Rules for edits:

- Keep each skill and its agent in step: the skill names the agent type, and the
  agent's `reasoningEffort` must match the variant.
- The x and max skills differ only in effort wording and agent names. Edit both together.
- Bump `CHANGELOG.md` for every release.
- After an edit, run `bash install.sh` and then `bash install.sh --check` (silent drift = none).
- No private project names, local paths, or secrets in any file. This repo is public.

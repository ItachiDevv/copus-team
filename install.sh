#!/usr/bin/env bash
# Install the Copus Team skills and agents into the Claude Code user config.
#   bash install.sh          install (overwrites the installed copies)
#   bash install.sh --check  report drift only; exit 1 if any copy differs
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
dest="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
check=0
[ "${1:-}" = "--check" ] && check=1
drift=0
for dir in "$here"/skills/*/; do
  name="$(basename "$dir")"
  src="$dir/SKILL.md"; dst="$dest/skills/$name/SKILL.md"
  if [ "$check" = 1 ]; then
    cmp -s "$src" "$dst" || { echo "DRIFT skill $name"; drift=1; }
  else
    mkdir -p "$dest/skills/$name" && cp "$src" "$dst" && echo "installed skill $name"
  fi
done
for src in "$here"/agents/*.md; do
  name="$(basename "$src")"; dst="$dest/agents/$name"
  if [ "$check" = 1 ]; then
    cmp -s "$src" "$dst" || { echo "DRIFT agent $name"; drift=1; }
  else
    mkdir -p "$dest/agents" && cp "$src" "$dst" && echo "installed agent $name"
  fi
done
if [ "$check" = 1 ]; then
  [ "$drift" = 0 ] && echo "in sync" || exit 1
else
  echo "Done. New agent types register at the next session start."
fi

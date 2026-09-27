#!/usr/bin/env bash
# Symlinks every skill in this repo into ~/.claude/skills (Claude Code) and ~/.agents/skills (Codex, Cursor).
set -euo pipefail

repo="$(cd "$(dirname "$0")" && pwd)"

for target in "$HOME/.claude/skills" "$HOME/.agents/skills"; do
  mkdir -p "$target"
  for skill in "$repo"/*/; do
    name="$(basename "$skill")"
    dest="$target/$name"
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
      echo "skip $dest (real directory exists; remove it to link this repo's copy)"
      continue
    fi
    ln -sfn "${skill%/}" "$dest"
    echo "linked $dest"
  done
done

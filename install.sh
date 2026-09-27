#!/usr/bin/env bash
# Symlinks every skill in this repo into ~/.claude/skills (Claude Code) and ~/.agents/skills (Codex, Cursor).
# On Windows (Git Bash), creates directory junctions instead, because symlinks need Developer Mode.
set -euo pipefail

repo="$(cd "$(dirname "$0")" && pwd)"

case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*) windows=true ;;
  *) windows=false ;;
esac

link() {
  local src="$1" dest="$2"
  if $windows; then
    # rmdir removes only the junction, not the files it points to.
    [ -L "$dest" ] && cmd //c rmdir "$(cygpath -w "$dest")"
    cmd //c mklink //J "$(cygpath -w "$dest")" "$(cygpath -w "$src")" > /dev/null
  else
    ln -sfn "$src" "$dest"
  fi
}

for target in "$HOME/.claude/skills" "$HOME/.agents/skills"; do
  mkdir -p "$target"
  for skill in "$repo"/*/; do
    name="$(basename "$skill")"
    dest="$target/$name"
    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
      echo "skip $dest (real directory exists; remove it to link this repo's copy)"
      continue
    fi
    link "${skill%/}" "$dest"
    echo "linked $dest"
  done
done

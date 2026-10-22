#!/bin/sh
# SPDX-License-Identifier: AGPL-3.0-or-later
# Sets every document with the kernoid template: next to each X.md it writes X.typ (Markdown → Typst with pandoc,
# template/pandoc.typ) and X.pdf (typst, template/kernoid.typ). The Markdown stays the only source.
#   ./build.sh                 all documents of this repository (except README.md)
#   ./build.sh path/to/X.md …  only these
# Notes for the authors (GitHub alerts `> [!NOTE]`, a section "Open points") stay in the Markdown only
# (template/notes.lua). Title, version, date and status come from the YAML front matter; the default status is
# "Draft". The PDF's creation date is the document's date, so an unchanged document builds to the same PDF.
# The footer carries the date of the document's last commit (or of the file, if it has uncommitted changes) and the
# short hash of its content – `git log --find-object=<hash>` finds the commit a PDF was made from.
# Needs pandoc, typst and python3 (without pandoc/typst, nix is used).
set -eu
cd "$(dirname "$0")"
repo=$(pwd)

if command -v typst >/dev/null 2>&1; then TYPST="typst"; else TYPST="nix run nixpkgs#typst --"; fi
if command -v pandoc >/dev/null 2>&1; then PANDOC="pandoc"; else PANDOC="nix run nixpkgs#pandoc --"; fi

if [ $# -gt 0 ]; then docs="$*"; else
  docs=$(git ls-files --cached --others --exclude-standard '*.md' | grep -v '^README.md$' | grep -v '^\.github/')
fi
[ -n "$docs" ] || { echo "no documents"; exit 1; }

for src in $docs; do
  base="${src%.md}"
  dir=$(dirname "$src")
  rev=$(git hash-object "$src" | cut -c1-7)
  if git ls-files --error-unmatch "$src" >/dev/null 2>&1 && git diff --quiet HEAD -- "$src" 2>/dev/null; then
    date=$(git log -1 --format=%cs -- "$src")
  else
    date=$(date -r "$src" +%F)
  fi
  kernoid=$(python3 -c 'import os,sys; print(os.path.relpath(sys.argv[1], sys.argv[2]))' "$repo/template/kernoid.typ" "$dir")
  root=$(python3 -c 'import os,sys; print(os.path.commonpath([os.path.abspath(p) for p in sys.argv[1:]]))' "$repo" "$dir")

  $PANDOC --from gfm+yaml_metadata_block --to typst --wrap=preserve --template template/pandoc.typ \
    --lua-filter template/notes.lua \
    -V src="$(basename "$base").typ" -V kernoid="$kernoid" -V stand="$date" -V rev="$rev" \
    --output "$base.typ" "$src"
  stamp=$(python3 -c 'import datetime,sys; print(int(datetime.datetime.fromisoformat(sys.argv[1]).replace(tzinfo=datetime.timezone.utc).timestamp()))' "$date")
  $TYPST compile --root "$root" --font-path template/fonts --ignore-system-fonts --creation-timestamp "$stamp" \
    "$base.typ" "$base.pdf"
  echo "$base.typ, $base.pdf"
done

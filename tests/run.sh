#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
build_dir=$(mktemp -d "${TMPDIR:-/tmp}/cstypo-tests.XXXXXX")
export TEXINPUTS="$repo_dir/tests:$repo_dir:${TEXINPUTS-}"
export LUAINPUTS="$repo_dir/tests:$repo_dir:${LUAINPUTS-}"
cd "$build_dir"

printf 'Test output: %s\n' "$build_dir"
status=0
for fixture in "$repo_dir"/tests/test-*.tex; do
  name=$(basename "$fixture" .tex)
  if lualatex -interaction=nonstopmode -halt-on-error "$fixture" >"$name.stdout" 2>&1; then
    printf '%s: passed\n' "$name"
  else
    printf '%s: FAILED\n' "$name"
    tail -n 60 "$name.stdout"
    status=1
  fi
done
exit "$status"

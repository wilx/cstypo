#!/bin/sh
set -eux

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$script_dir"

for tool in latexmk lualatex ctanify tar gzip zip; do
    if ! command -v "$tool" >/dev/null 2>&1; then
        printf 'Required tool not found: %s\n' "$tool" >&2
        exit 1
    fi
done

latexmk -gg -lualatex -interaction=nonstopmode -halt-on-error cstypotest.tex

latexmk -gg -lualatex -interaction=nonstopmode -halt-on-error cstypo.tex

DOCDIR=doc/lualatex/cstypo
LATEXDIR=tex/lualatex/cstypo
TEXDIR=tex/luatex/cstypo

ctanify --pkgname=cstypo \
        cstypo.lua=$TEXDIR \
        cstypo.sty=$LATEXDIR \
        cstypo-tex.tex=$TEXDIR \
        README.md=$DOCDIR \
        LICENSE=$DOCDIR \
        cstypotest.tex=$DOCDIR \
        cstypotest.pdf=$DOCDIR \
        cstypo.tex=$DOCDIR \
        cstypo.pdf=$DOCDIR

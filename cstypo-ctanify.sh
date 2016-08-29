#!/bin/sh
set -x
set -e

latexmk -gg -lualatex cstypotest.tex

latexmk -gg -lualatex cstypo.tex

DOCDIR=doc/lualatex/cstypo
TEXDIR=tex/lualatex/cstypo

ctanify --pkgname=cstypo \
        cstypo.lua=$TEXDIR \
        cstypo.sty=$TEXDIR \
        README.md=$DOCDIR \
        cstypotest.tex=$DOCDIR \
        cstypotest.pdf=$DOCDIR \
        cstypo.tex=$DOCDIR \
        cstypo.pdf=$DOCDIR

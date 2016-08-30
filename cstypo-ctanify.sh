#!/bin/sh
set -x
set -e

latexmk -gg -lualatex cstypotest.tex

latexmk -gg -lualatex cstypo.tex

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

#!/bin/sh

makedtx.pl -src 'cstypo\.lua$=>cstypo.lua' \
           -src 'cstypo\.sty$=>cstypo.sty' \
           -doc cstypo.tex \
           -author 'Václav Haisman' \
           -dir src \
           cstypo

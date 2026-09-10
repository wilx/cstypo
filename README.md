# cstypo

This package provides macros for Czech language typography rules using Lua(La)TeX.

- License is MIT license. See `LICENSE` file.

- Author is [Václav Haisman](mailto:vhaisman+cstypo@gmail.com?subject=[cstypo])

- Source code on GitHub in [`wilx/cstypo`](https://github.com/wilx/cstypo) repository.

To build the CTAN package, run this command from the package source directory:

```sh
./cstypo-ctanify.sh
```

This rebuilds the example and manual PDFs and writes `cstypo.tar.gz`.
The archive contains a flat `cstypo/` directory with the package files,
README, license, documentation sources, and PDFs.

Building requires LuaLaTeX, latexmk, ctanify, GNU tar, gzip, and zip, plus
the document's LaTeX packages and the Charis SIL, TeX Gyre Heros, and
DejaVu Sans Mono fonts. The complete Ubuntu dependency list is in
[the build workflow](https://github.com/wilx/cstypo/blob/master/.github/workflows/build.yml).

GitHub Actions runs the regression tests and the commands above on pushes,
pull requests, and manual runs. Download `cstypo.tar.gz` from the artifacts
of a successful **Build package** run in the repository's **Actions** tab.
Artifacts are retained for 30 days.

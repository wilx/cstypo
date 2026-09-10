Run `sh tests/run.sh` from the repository root with LuaLaTeX available.
The tests use Babel, fontspec, and Latin Modern to isolate cstypo from
Polyglossia's automatic luavlna integration. They check protected spaces
before line breaking and text on the resulting lines. Each run retains
its logs and PDFs in the temporary directory printed by the runner.

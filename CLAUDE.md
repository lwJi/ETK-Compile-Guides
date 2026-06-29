# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

This is **not** an application. It is a collection of shell scripts and configuration files for **building the Einstein Toolkit** (specifically the CarpetX-based stack: CarpetX, SpacetimeX, AsterX) and **submitting jobs** on a set of HPC machines (Frontier, Frontera, Vista, Green Prairies, plus macOS). There is no test suite or lint step; "running" this code means compiling the toolkit on a real cluster.

## Two key environment variables

Almost everything is driven by two exported variables (see any machine's `README.md`):

- `ETKPATH` — where the Einstein Toolkit source/build lives (e.g. `$HOME/EinsteinToolkit`). The toolkit source is checked out into `${ETKPATH}/Cactus`; AMReX is installed into `${ETKPATH}/amrex-<variant>`.
- `ETKGUIDE` — path to a machine directory in this repo (e.g. `.../ETK-Compile-Guides/frontier`). Compiler-variant subdirs are referenced relative to it.

## Standard build workflow (per machine)

1. `export ETKGUIDE=.../<machine>` and `export ETKPATH=...`
2. Download source with `GetComponents` using a `ThornList/*.th` file.
3. `source ${ETKGUIDE}/<variant>/Load-Module-CarpetX` — loads the module environment.
4. `${ETKGUIDE}/<variant>/Install-AMReX` — clones+builds AMReX (requires `ETKPATH` set; output goes to `${ETKPATH}/amrex-<variant>`).
5. `cd ${ETKPATH}/Cactus && ${ETKGUIDE}/../CompileScript/Compile-ETK -c ${ETKGUIDE}/<variant>/<machine>.cfg -t thornlists/<list>.th --fresh`

Each machine's `README.md` is the authoritative, copy-pasteable version of these steps and is the first thing to read/update when working on that machine.

## Repository structure

- **`<machine>/<variant>/`** — the core unit. Each compiler variant directory (e.g. `frontier/cray-20.0.0/`, `vista/gcc-nvcc/`) holds a consistent trio:
  - `Load-Module-CarpetX` — `module load …` + env exports; meant to be **sourced**.
  - `Install-AMReX` — standalone script: clones AMReX, runs `cmake` + `make install` with machine/compiler-specific flags into `${ETKPATH}/amrex-<variant>`.
  - `<machine>.cfg` — Cactus "option list": compiler binaries (`CC/CXX/F90/LD`), flags, and `*_DIR` library paths. The `VERSION =` line at the top is a cache key — changing it forces a full reconfigure+rebuild.
  - Variants come in two axes: compiler toolchain (`gcc`, `cray`, `amd`, `oneapi`, `nvc`, `icc`) and sometimes a pinned version suffix (`cray-20.0.0`, `amd-18.0.1`).
- **`CompileScript/Compile-ETK`** — generic build driver wrapping `gmake`. Copies the chosen thornlist into `configs/<exe>/ThornList`, then runs `gmake -j<n> <exe>`. `--fresh` removes `configs/<exe>` and re-runs `gmake <exe> options=<cfg>` first. Flags: `-e` executable name (default `etk`), `-t` thornlist, `-c` cfg, `-j` cores, `--fresh`.
- **`ThornList/*.th`** — Cactus component lists in GetComponents format (`!URL`, `!CHECKOUT`, etc.). Machine-specific variants exist (`asterx-frontier.th`, `asterx-gp.th`).
- **`SubmitScript/`** — `SubmitJobs` job-submission tool. `main()` in `SubmitJobs` detects the host by `$HOSTNAME` regex and sets the launcher (`ibrun`/`srun`); shared logic lives in `src/utils.sh` and `src/submit_job_scripts.sh` (`submit_job_slurm` / `submit_job_pbs`). Supports job chaining via `-n <njobs>:<dependentID>`. Either pass full resource flags or a `subscript`. **To add a new machine, add an `elif` host branch in `SubmitJobs`'s `main()`.**
- **`frontera-spack/`** — alternative Spack-based environment setup for Frontera (`spack.yaml` + config cfgs), separate from the module-based flow above.

## `gmake` cheatsheet (from root README)

These operate directly on Cactus configs inside `${ETKPATH}/Cactus` (bypassing `Compile-ETK`):

```
gmake <config>-clean / <config>-realclean      # clean
gmake <config>-reconfig options=<cfgfile>      # reconfig after editing config-info
gmake -j24 <config>-build BUILDLIST=AMReX      # build one thorn only
gmake -j8 <config> VERBOSE=yes                 # verbose build
```

## Conventions when editing

- The trio (`Load-Module-CarpetX`, `Install-AMReX`, `<machine>.cfg`) must stay mutually consistent: module versions loaded must match the library paths and compiler flags in the cfg, and the AMReX install dir (`amrex-<variant>`) must match `AMREX_DIR` in the cfg.
- Module/stack version notes and known workarounds (e.g. GPU-aware-MPI env vars) are recorded as comments in these files and in machine READMEs — keep them in sync when bumping a stack.
- `gp-pbs` vs `gp-slurm` are the same cluster (Green Prairies) under two schedulers; pick the matching submit path.

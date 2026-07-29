# ETK-Compile-Guides

Scripts and configuration files for building the [Einstein Toolkit](https://einsteintoolkit.org/) (the CarpetX-based stack: CarpetX, SpacetimeX, AsterX) and submitting jobs on a set of HPC machines.

## Supported machines

| Directory | Machine | Notes |
| --- | --- | --- |
| `frontier/` | OLCF Frontier | `amd`, `cray` variants (plus pinned versions) |
| `frontera/` | TACC Frontera | `icc`, `oneapi` variants (module-based) |
| `frontera-spack/` | TACC Frontera | alternative Spack-based environment setup |
| `vista/` | TACC Vista | `gcc`, `gcc-nvcc`, `nvc`, `nvc-nvcc`, … variants |
| `deltaai/` | NCSA DeltaAI | GH200 build and run guide |
| `gp-pbs/`, `gp-slurm/` | Green Prairies | same cluster under PBS or Slurm |
| `macos/` | macOS | local build, no scheduler |

Each machine directory has a `README.md` with copy-pasteable instructions — that is the authoritative guide for that machine.

## Standard build workflow

Everything is driven by two environment variables:

- `ETKPATH` — where the Einstein Toolkit source/build lives (e.g. `$HOME/EinsteinToolkit`); the source is checked out into `${ETKPATH}/Cactus` and AMReX is installed into `${ETKPATH}/amrex-<variant>`
- `ETKGUIDE` — path to a machine directory in this repo (e.g. `.../ETK-Compile-Guides/frontier`)

The per-machine workflow is then:

1. Set the environment variables

    ```bash
    export ETKGUIDE="{path_to_ETK-Compile-Guides}/<machine>"
    export ETKPATH="$HOME/EinsteinToolkit"
    ```

2. Download the source with `GetComponents` using a thornlist from `ThornList/`

    ```bash
    mkdir ${ETKPATH} && cd ${ETKPATH} && \
    curl -kLO https://raw.githubusercontent.com/gridaphobe/CRL/master/GetComponents && \
    chmod a+x GetComponents && \
    ./GetComponents --root Cactus --parallel --no-shallow https://raw.githubusercontent.com/lwJi/ETK-Compile-Guides/main/ThornList/<list>.th
    ```

3. Load the module environment

    ```bash
    source ${ETKGUIDE}/<variant>/Load-Module-CarpetX
    ```

4. Install AMReX to `${ETKPATH}/amrex-<variant>`

    ```bash
    ${ETKGUIDE}/<variant>/Install-AMReX
    ```

5. Compile the toolkit

    ```bash
    cd ${ETKPATH}/Cactus

    ${ETKGUIDE}/../CompileScript/Compile-ETK -c ${ETKGUIDE}/<variant>/<machine>.cfg -t thornlists/<list>.th --fresh
    ```

    - type `yes` when it asks 'Setup configuration etk'
    - run `Compile-ETK --help` to display the available options (`-e` executable name, `-t` thornlist, `-c` config file, `-j` cores, `--fresh`)

## Repository layout

- `<machine>/<variant>/` — one compiler variant per directory, each holding a consistent trio:
  - `Load-Module-CarpetX` — `module load …` + env exports; meant to be **sourced**
  - `Install-AMReX` — clones and builds AMReX with machine/compiler-specific flags
  - `<machine>.cfg` — Cactus option list (compilers, flags, library paths); the `VERSION =` line is a cache key — changing it forces a full reconfigure and rebuild
- `CompileScript/Compile-ETK` — generic build driver wrapping `gmake`
- `ThornList/*.th` — Cactus component lists in GetComponents format, including machine-specific variants (`asterx-frontier.th`, `asterx-gp.th`)
- `SubmitScript/` — `SubmitJobs` job-submission tool (Slurm/PBS/macOS, with job chaining via `-n <njobs>:<dependentID>`); see `SubmitScript/README.md`

## `gmake` options

These operate directly on Cactus configs inside `${ETKPATH}/Cactus` (bypassing `Compile-ETK`):

* Clean compilation files

    ```
    gmake <config>-clean
    gmake <config>-realclean
    ```

* Reconfig after modifying `config-info`

    ```
    gmake <config>-reconfig options=<cfgfile>
    ```

* Only compile AMReX

    ```
    gmake -j24 <config>-build BUILDLIST=AMReX
    ```

* Verbose

    ```
    gmake -j8 <config> VERBOSE=yes
    ```

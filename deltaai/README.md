# Einstein Toolkit on DeltaAI

This guide configures an Einstein Toolkit CUDA build for the four NVIDIA GH200
superchips on each NCSA DeltaAI `ghx4` node. The run templates use four MPI
ranks per node, 72 Grace CPU cores per rank, and one GPU per rank.

## Environment

```bash
git clone https://github.com/jaykalinani/ETK-Compile-Guides.git
export ETKGUIDE=/path/to/ETK-Compile-Guides/deltaai
export ETKPATH="${WORK}/EinsteinToolkit"
source "${ETKGUIDE}/gcc-nvcc/Load-Module-CarpetX.sh"
```

The module loader starts with `module reset`, so it can be sourced from a clean
login shell or from a batch job without inheriting an incompatible compiler or
MPI environment.

## Build

The default installer checks out and builds the `asterx` configuration:

```bash
"${ETKGUIDE}/gcc-nvcc/Install-Everything.sh"
```

The configuration and thorn list are configurable. For an existing checkout
that contains `thornlists/asterx_nux.th`, for example:

```bash
export CONFIGURATION=asterx_nux
export THORNLIST_FILE=thornlists/asterx_nux.th
export FRESH_BUILD=no
"${ETKGUIDE}/gcc-nvcc/Install-Everything.sh"
```

Set `THORNLIST_URL` as well when creating a new checkout from a different thorn
list. `FRESH_BUILD=yes` is the default; set it to `no` for an incremental
rebuild.

The installer also places the DeltaAI machine, option, submit, and run files in
the checkout's SimFactory `mdb` directories. It recognizes both
`Cactus/repos/simfactory2` and `Cactus/simfactory`.

## SimFactory

The four required files are:

- `deltaai.ini`: machine description and four-ranks-per-node topology
- `gcc-nvcc/deltaai.cfg`: CUDA/Cactus option list
- `deltaai.sub`: Slurm submission template
- `deltaai.run`: `srun` launch template

For manual installation:

```bash
SIMFACTORY="${ETKPATH}/Cactus/repos/simfactory2"
cp "${ETKGUIDE}/deltaai.ini" "${SIMFACTORY}/mdb/machines/"
cp "${ETKGUIDE}/gcc-nvcc/deltaai.cfg" "${SIMFACTORY}/mdb/optionlists/"
cp "${ETKGUIDE}/deltaai.sub" "${SIMFACTORY}/mdb/submitscripts/"
cp "${ETKGUIDE}/deltaai.run" "${SIMFACTORY}/mdb/runscripts/"
```

Set your allocation and email through SimFactory. Use `ghx4` for production
jobs or override the queue with `ghx4-interactive` for jobs up to two hours.

## Direct Slurm Submission

`submit_dtai.sbatch` is a one-node, four-GPU smoke-test script. Update its
account if needed, then pass a parameter file:

```bash
sbatch "${ETKGUIDE}/submit_dtai.sbatch" /absolute/path/to/run.par
```

The default executable is `${WORK}/EinsteinToolkit/Cactus/exe/cactus_asterx`.
Override it for another configuration:

```bash
EXE="${WORK}/EinsteinToolkit/Cactus/exe/cactus_asterx_nux"
export EXE
sbatch "${ETKGUIDE}/submit_dtai.sbatch" /absolute/path/to/run.par
```

The script validates the executable and parameter file before launching and
uses explicit CPU/GPU binding in `srun`.

## Notes

- CUDA architecture `sm_90` is used for GH200.
- Cray MPICH GPU support is enabled through
  `MPICH_GPU_SUPPORT_ENABLED=1`.
- The current validated CUDA build keeps Cactus OpenMP disabled. The Slurm and
  SimFactory layouts still reserve 72 CPU cores per GPU rank for correct
  process placement and host-side work.
- The system parallel HDF5 and FFTW modules are used. Boost is built by the
  Cactus ExternalLibraries infrastructure.

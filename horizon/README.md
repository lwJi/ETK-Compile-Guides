# Build and run the Einstein Toolkit on Horizon

This guide targets Horizon’s Grace Blackwell nodes, which have four GB200 GPUs and two 72-core Grace CPUs per node. The build uses GCC 15.3, CUDA 13.3, Open MPI 5.0.11 and NVPL 26.9. AMReX and Cactus both target Blackwell `sm_100` (compute capability 10.0). [TACC Horizon User Guide](https://docs.tacc.utexas.edu/hpc/horizon/) · [NVIDIA GPU compute capabilities](https://developer.nvidia.com/cuda/gpus)

## Set up the source tree

Hostname (username is the same as the one used on Vista)

```bash
horizon.tacc.utexas.edu
```

Download repo

```bash
git clone https://github.com/lwJi/ETK-Compile-Guides.git
```

From the root of this repository on Horizon, set the guide and build paths.

```bash
export ETKGUIDE="{path_to_ETK-Compile-Guides}/horizon"
export ETKPATH="$HOME/EinsteinToolkit"
```

Download CarpetX, SpacetimeX and AsterX to `${ETKPATH}`

```bash
mkdir -p "$ETKPATH"
cd "$ETKPATH"
curl -fLO https://raw.githubusercontent.com/gridaphobe/CRL/master/GetComponents
chmod +x GetComponents
./GetComponents --root Cactus --parallel --no-shallow "$ETKGUIDE/../ThornList/asterx.th"
```

Horizon’s scratch filesystem is subject to purge. Keep a copy of source changes, parameter files, and outputs you need to retain. [TACC scratch policy](https://docs.tacc.utexas.edu/hpc/horizon/#scratch-file-system-purge-policy)

## Build AMReX, Silo, and Cactus

Load Modules

```bash
source "$ETKGUIDE/gcc-nvcc/Load-Module-CarpetX"
```

Compile `AMReX` and `Silo`

```bash
$ETKGUIDE/gcc-nvcc/Install-AMReX
$ETKGUIDE/gcc-nvcc/Install-Silo
```

Compile `ETK`

```bash
cd $ETKPATH/Cactus

$ETKGUIDE/../CompileScript/Compile-ETK -e etk \
    -c $ETKGUIDE/gcc-nvcc/horizon.cfg \
    -t thornlists/asterx.th \
    -j 8 --fresh
```

Silo is built from the thorn’s bundled source against the same system serial HDF5 used by Cactus. The separate build works around the thorn’s CMake link flag handling. The expected executable is `$ETKPATH/Cactus/exe/cactus_etk`. To resume a build after fixing an error, repeat the `Compile-ETK` command without `--fresh`.

## Submit a GPU job

From a simulation directory on `$SCRATCH` containing `params.par`, submit one job with four MPI ranks on a full GPU node and one rank per GPU. The job script loads the build modules, and `SubmitJobs` launches Cactus with TACC’s `ibrun`.

```bash
$ETKGUIDE/../SubmitScript/SubmitJobs -n 1 \
    -e $ETKPATH/Cactus/exe/cactus_etk -p params.par \
    -N 1 -m 4 -t 00:10:00 -q debug -a my_project \
    -s $ETKGUIDE/subscript-baremetal
```

When the production partitions are available, use `-q gpu-dev` for a short test or `-q gpu` for a production run. Keep `-m` at four times the node count for one rank per GPU. [TACC partitions and job launching](https://docs.tacc.utexas.edu/hpc/horizon/#running-jobs)

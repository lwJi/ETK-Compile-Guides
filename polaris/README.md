# Polaris

Polaris (ALCF) configuration for CarpetX/AsterX with GNU 14.3, NVIDIA HPC
SDK 25.9, CUDA 13.0, AMReX 26.09, Cray MPICH, HDF5, and FFTW. The CUDA
target is the A100 (`sm_80`).

The module setup deliberately uses `PrgEnv-gnu` with `nvidia-mixed/25.9`.
Loading `nvidia/25.9` would switch the Cray compiler wrappers back to
`PrgEnv-nvidia`, even if `PrgEnv-gnu` had just been loaded. The mixed module
provides the CUDA/NVIDIA runtime libraries while preserving GNU 14.3 as the
C, C++, and Fortran compiler backend.

## Build prerequisites

Install the local CMake prerequisite, load the Polaris compiler environment,
and download, compile, and install Boost 1.89.0 and AMReX 26.09:

```bash
export ETKPATH=/home/jkalinan/EinsteinToolkit
export ETKGUIDE=/home/jkalinan/ETK-Compile-Guides/polaris
"$ETKGUIDE/gcc-nvcc/Install-CMake"
source "$ETKGUIDE/gcc-nvcc/Load-Module-CarpetX"
"$ETKGUIDE/gcc-nvcc/Install-Boost"
"$ETKGUIDE/gcc-nvcc/Install-AMReX"
```

`Install-CMake` installs the official CMake 3.30.7 Linux binary distribution
into `${ETKPATH}/cmake`; `Load-Module-CarpetX` adds it to `PATH`. This is needed
because Polaris does not provide a CMake module, while several bundled Cactus
libraries require CMake.

The installer downloads the official Boost source archive, compiles the
`filesystem` library with GNU 14.3 and C++20, and installs all Boost headers in
`${ETKPATH}/boost-gcc-nvcc`. Boost.System 1.89 is header-only. Set
`BUILD_JOBS` to change the default parallelism of 16 jobs:

```bash
BUILD_JOBS=32 "$ETKGUIDE/gcc-nvcc/Install-Boost"
```

`Install-AMReX` downloads the official AMReX 26.09 release and builds its
three-dimensional production static library with GNU 14.3, CUDA 13.0, C++20,
OpenMP, Cray MPI, relocatable device code, disabled runtime assertions, and
A100 (`sm_80`) code generation. CUDA fast math is explicitly disabled to
preserve IEEE-sensitive numerical behavior. It
installs into `${ETKPATH}/amrex-gcc-nvcc`; the option list uses this external
installation instead of the AMReX 25.11 archive embedded in the current
`ExternalLibraries/AMReX` thorn.

Verify the installation with:

```bash
grep BOOST_LIB_VERSION "$ETKPATH/boost-gcc-nvcc/include/boost/version.hpp"
ls "$ETKPATH/boost-gcc-nvcc/lib/libboost_filesystem.a"
grep AMREX_GIT_VERSION "$ETKPATH/amrex-gcc-nvcc/include/AMReX_Version.H"
ls "$ETKPATH/amrex-gcc-nvcc/lib/libamrex.a"
```

## Compile Einstein Toolkit

The Polaris option list uses this external Boost installation instead of the
obsolete Boost 1.55 bundled by `ExternalLibraries/Boost`. Its CUDA flags also
pre-include `boost/math/tools/toms748_solve.hpp`: Boost 1.89's umbrella
`boost/math/tools/roots.hpp` omits that host-oriented header when compiled by
NVCC, but CarpetX/Algo uses `eps_tolerance` and `bracket_and_solve_root` from
it.

This option list targets AMReX 26.09. Do not apply the included legacy
`CarpetX-AMReX-25.11.patch` to an AMReX 26.09 installation; it is retained only
for reproducing the older CUDA 12.9/AMReX 25.11 build.

The production option list uses `-O3` and `NDEBUG` without unsafe fast-math
transformations. The C++ and CUDA translation units use C++20. C translation units are pinned
to GNU C17 because GCC 14 otherwise selects GNU C23, whose built-in `bool`
conflicts with legacy C code in `AEILocalInterp`. The option list also
pre-includes the system `bits/floatn.h` for C builds to bypass the stale
GCC-14 `include-fixed` copy shipped on Polaris; without it, the bundled SSHT
library fails while expanding glibc's `<tgmath.h>` macros.

```bash
cd "$ETKPATH/Cactus"
/home/jkalinan/ETK-Compile-Guides/CompileScript/Compile-ETK \
  -e asterx_sc -c "$ETKGUIDE/gcc-nvcc/polaris.cfg" \
  -t "$ETKPATH/Cactus/repos/BHClusterX/Docs/thornlist/bhclusterx.th" \
  -j 4 --fresh
```

Four compile jobs is the tested safe setting on a Polaris login node. This does
not reduce executable performance; it only limits simultaneous compiler
processes. Eight jobs exhausted the available memory while `ptxas` compiled
the CUDA-heavy AsterX `Con2PrimFactory` translation unit.

## Install the SimFactory files

Keep the files in this repository as the source of truth, then install copies
into Cactus:

```bash
cp "$ETKGUIDE/gcc-nvcc/polaris.cfg" \
  "$ETKPATH/Cactus/simfactory/mdb/optionlists/polaris.cfg"
cp "$ETKGUIDE/polaris.ini" \
  "$ETKPATH/Cactus/simfactory/mdb/machines/polaris.ini"
cp "$ETKGUIDE/polaris.sub" \
  "$ETKPATH/Cactus/simfactory/mdb/submitscripts/polaris.sub"
cp "$ETKGUIDE/polaris.run" \
  "$ETKPATH/Cactus/simfactory/mdb/runscripts/polaris.run"
```

The default machine entry uses the `BHClusterX` allocation and its Eagle path
`/eagle/BHClusterX/$USER/simulations`. Override `--allocation` and `--queue`
on a SimFactory command when using a different project or queue.

The default runtime layout is four MPI ranks per node, one rank per A100, with
eight OpenMP threads per rank on the node's 32 physical CPU cores. The run
template reverses GPU numbering to follow Polaris topology and uses
`--no-transfer` because large Cactus executables can exceed PALS's transfer
limit. Set `POLARIS_AFFINITY_VERBOSE=1` to print every rank-to-GPU mapping.

The `preemptable` queue permits up to 72 hours and can terminate jobs without
warning. The submit template marks jobs rerunnable with `#PBS -r y`; frequent
Cactus checkpoints are still required for useful recovery.

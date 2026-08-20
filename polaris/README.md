# Polaris

Polaris (ALCF) configuration for CarpetX/AsterX with GNU 12.3, CUDA 12.9,
Cray MPICH, HDF5, and FFTW. The CUDA target is the A100 (`sm_80`).

## Build prerequisites

Install the local CMake prerequisite, load the Polaris compiler environment,
and download, compile, and install Boost 1.89.0:

```bash
export ETKPATH=/home/jkalinan/EinsteinToolkit
export ETKGUIDE=/home/jkalinan/ETK-Compile-Guides/polaris
"$ETKGUIDE/gcc-nvcc/Install-CMake"
source "$ETKGUIDE/gcc-nvcc/Load-Module-CarpetX"
"$ETKGUIDE/gcc-nvcc/Install-Boost"
```

`Install-CMake` installs the official CMake 3.30.7 Linux binary distribution
into `${ETKPATH}/cmake`; `Load-Module-CarpetX` adds it to `PATH`. This is needed
because Polaris does not provide a CMake module, while several bundled Cactus
libraries require CMake.

The installer downloads the official Boost source archive, compiles the
`filesystem` library with GNU 12.3 and C++17, and installs all Boost headers in
`${ETKPATH}/boost-gcc-nvcc`. Boost.System 1.89 is header-only. Set
`BUILD_JOBS` to change the default parallelism of 16 jobs:

```bash
BUILD_JOBS=32 "$ETKGUIDE/gcc-nvcc/Install-Boost"
```

Verify the installation with:

```bash
grep BOOST_LIB_VERSION "$ETKPATH/boost-gcc-nvcc/include/boost/version.hpp"
ls "$ETKPATH/boost-gcc-nvcc/lib/libboost_filesystem.a"
```

## Compile Einstein Toolkit

The Polaris option list uses this external Boost installation instead of the
obsolete Boost 1.55 bundled by `ExternalLibraries/Boost`. Its CUDA flags also
pre-include `boost/math/tools/toms748_solve.hpp`: Boost 1.89's umbrella
`boost/math/tools/roots.hpp` omits that host-oriented header when compiled by
NVCC, but CarpetX/Algo uses `eps_tolerance` and `bracket_and_solve_root` from
it.

The current `nuX` CarpetX branch expects newer AMReX `Array4::get_stride`
accessors, but the thornlist currently downloads AMReX 25.11, which exposes
the same values as `jstride`, `kstride`, and `nstride`. Apply the included
compatibility patch once after downloading the source:

```bash
git -C "$ETKPATH/Cactus/repos/CarpetX" apply \
  "$ETKGUIDE/gcc-nvcc/CarpetX-AMReX-25.11.patch"
```

If `git apply` reports that the patch does not apply, first check whether the
upstream CarpetX/AMReX combination has already resolved the mismatch. Do not
apply it a second time.

```bash
cd "$ETKPATH/Cactus"
/home/jkalinan/ETK-Compile-Guides/CompileScript/Compile-ETK \
  -e asterx_sc -c "$ETKGUIDE/gcc-nvcc/polaris.cfg" \
  -t thornlists/nuX.th -j 4 --fresh
```

Use four compile jobs on a Polaris login node. Larger values can exhaust the
login node's per-process memory while compiling CUDA-heavy AMReX files.

Copy `polaris.ini`, `polaris.sub`, and `polaris.run` to the matching
SimFactory `mdb` directories when using SimFactory.

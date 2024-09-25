#!/bin/bash

export MPICH_GPU_SUPPORT_ENABLED=1
export AMREX_AMD_ARCH=gfx90a
export CC=$(which hipcc)
export CXX=$(which hipcc)
export FC=$(which amdflang)
export CFLAGS="-I/opt/rocm-6.1.3/include"
export CXXFLAGS="-I/opt/rocm-6.1.3/include -Wno-pass-failed"
export LDFLAGS="-L/opt/rocm-6.1.3/lib -lamdhip64 ${PE_MPICH_GTL_DIR_amd_gfx90a} -lmpi_gtl_hsa"

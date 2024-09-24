#!/bin/bash

export MPICH_GPU_SUPPORT_ENABLED=1
export AMREX_AMD_ARCH=gfx90a
export CC=$(which hipcc)
export CXX=$(which hipcc)
export FC=$(which amdflang)
export CFLAGS="-I${MPICH_DIR}/include"
export CXXFLAGS="-I${MPICH_DIR}/include -Wno-pass-failed"
export LDFLAGS="-L${MPICH_DIR}/lib -lamdhip64 ${PE_MPICH_GTL_DIR_amd_gfx90a} -lmpi_gtl_hsa"

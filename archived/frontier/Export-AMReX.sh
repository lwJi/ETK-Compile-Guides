#!/bin/bash

export MPICH_GPU_SUPPORT_ENABLED=1
export PE_MPICH_GTL_DIR_amd_gfx90a="-L/opt/cray/pe/mpich/8.1.28/gtl/lib"
export AMREX_AMD_ARCH=gfx90a
export CC=$(which hipcc)
export CXX=$(which hipcc)
export FC=$(which amdflang)
export CFLAGS="-I${ROCM_PATH}/include"
export CXXFLAGS="-I${ROCM_PATH}/include -Wno-pass-failed"
export LDFLAGS="-L${ROCM_PATH}/lib -lamdhip64 ${PE_MPICH_GTL_DIR_amd_gfx90a} -lmpi_gtl_hsa"

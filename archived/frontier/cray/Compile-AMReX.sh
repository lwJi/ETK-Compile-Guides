#!/bin/bash

echo "MPICH_GPU_SUPPORT_ENABLED    = $MPICH_GPU_SUPPORT_ENABLED"
echo "PE_MPICH_GTL_DIR_amd_gfx90a  = $PE_MPICH_GTL_DIR_amd_gfx90a"
echo "PE_MPICH_GTL_LIBS_amd_gfx90a = $PE_MPICH_GTL_LIBS_amd_gfx90a"

cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo \
      -DCMAKE_INSTALL_PREFIX=${HOME}/local/amrex-cray \
      -DCMAKE_PREFIX_PATH='/opt/rocm-6.1.3/lib/cmake/AMDDeviceLibs;/opt/rocm-6.1.3/lib/cmake/amd_comgr;/opt/rocm-6.1.3/lib/cmake/hip;/opt/rocm-6.1.3/lib/cmake/hiprand;/opt/rocm-6.1.3/lib/cmake/hsa-runtime64;/opt/rocm-6.1.3/lib/cmake/rocprim;/opt/rocm-6.1.3/lib/cmake/rocrand' \
      -DAMReX_GPU_BACKEND=HIP \
      -DAMReX_AMD_ARCH=gfx90a \
      -DAMReX_FORTRAN=OFF \
      -DAMReX_FORTRAN_INTERFACES=OFF \
      -DAMReX_OMP=OFF \
      -DAMReX_PARTICLES=ON \
      -DAMReX_PRECISION=DOUBLE \
      ..
      # -DCMAKE_CXX_COMPILER=${ROCM_PATH}/bin/amdclang++ \
      # -DCMAKE_C_COMPILER=${ROCM_PATH}/bin/amdclang \

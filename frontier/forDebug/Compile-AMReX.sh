#!/bin/bash

#echo "MPICH_GPU_SUPPORT_ENABLED    = $MPICH_GPU_SUPPORT_ENABLED"
#echo "PE_MPICH_GTL_DIR_amd_gfx90a  = $PE_MPICH_GTL_DIR_amd_gfx90a"
#echo "PE_MPICH_GTL_LIBS_amd_gfx90a = $PE_MPICH_GTL_LIBS_amd_gfx90a"

cd ${ETKINSTALL} && git clone https://github.com/lwJi/amrex.git

cd ${ETKINSTALL}/amrex && git checkout --track origin/gpu-aware-mpi

cd ${ETKINSTALL} && mkdir amrex-lib

cd ${ETKINSTALL}/amrex && mkdir build && cd build && \
source $ETKDEBUG/Export-AMReX.sh && \
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo \
      -DCMAKE_INSTALL_PREFIX=${ETKINSTALL}/amrex-lib \
      -DCMAKE_PREFIX_PATH='${ROCM_PATH}/lib/cmake/AMDDeviceLibs;${ROCM_PATH}/lib/cmake/amd_comgr;${ROCM_PATH}/lib/cmake/hip;${ROCM_PATH}/lib/cmake/hiprand;${ROCM_PATH}/lib/cmake/hsa-runtime64;${ROCM_PATH}/lib/cmake/rocprim;${ROCM_PATH}/lib/cmake/rocrand' \
      -DAMReX_GPU_BACKEND=HIP \
      -DAMReX_AMD_ARCH=gfx90a \
      -DAMReX_FORTRAN=OFF \
      -DAMReX_FORTRAN_INTERFACES=OFF \
      -DAMReX_OMP=OFF \
      -DAMReX_PARTICLES=ON \
      -DAMReX_PRECISION=DOUBLE \
      .. && \
make -j24 install

cd ${ETKINSTALL}

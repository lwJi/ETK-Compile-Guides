#!/bin/bash

#cd ${ETKPATH} && git clone https://github.com/lwJi/amrex.git
#
#cd ${ETKPATH}/amrex && git checkout --track origin/gpu-aware-mpi
#
#cd ${ETKPATH} && mkdir amrex-lib
#
#cd ${ETKPATH}/amrex && mkdir build && cd build && \
#
#source $ETKGUIDE/Export-AMReX.sh && \

cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo \
      -DCMAKE_INSTALL_PREFIX=${ETKPATH}/amrex-lib \
      -DAMReX_GPU_BACKEND=CUDA \
      -DAMReX_CUDA_ARCH=Auto \
      -DAMReX_DIFFERENT_COMPILER=ON \
      -DAMReX_FORTRAN=OFF \
      -DAMReX_FORTRAN_INTERFACES=OFF \
      -DAMReX_OMP=OFF \
      -DAMReX_PARTICLES=ON \
      -DAMReX_PRECISION=DOUBLE \
      .. && \
make -j24 install

#cd ${ETKPATH}

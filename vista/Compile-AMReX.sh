#!/bin/bash

#cd ${ETKINSTALL} && git clone https://github.com/lwJi/amrex.git
#
#cd ${ETKINSTALL}/amrex && git checkout --track origin/gpu-aware-mpi
#
#cd ${ETKINSTALL} && mkdir amrex-lib
#
#cd ${ETKINSTALL}/amrex && mkdir build && cd build && \
#
#source $ETKDEBUG/Export-AMReX.sh && \

cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo \
      -DCMAKE_INSTALL_PREFIX=${ETKINSTALL}/amrex-lib \
      -DAMReX_GPU_BACKEND=CUDA \
      -DAMReX_CUDA_ARCH=Hopper \
      -DAMReX_FORTRAN=OFF \
      -DAMReX_FORTRAN_INTERFACES=OFF \
      -DAMReX_OMP=OFF \
      -DAMReX_PARTICLES=ON \
      -DAMReX_PRECISION=DOUBLE \
      .. && \
make -j24 install

#cd ${ETKINSTALL}

#!/bin/bash

#cd ${ETKPATH} && mkdir amrex-lib && git clone https://github.com/AMReX-Codes/amrex.git
#
#cd ${ETKPATH}/amrex && mkdir build && cd build && \

export CC=$(which gcc)
export CXX=$(which g++)
export FC=$(which gfortran)
export CFLAGS="-I${TACC_CUDA_INC}"
export CXXFLAGS="-I${TACC_CUDA_INC}"
export LDFLAGS="-L${TACC_CUDA_LIB}"

cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo \
      -DCMAKE_INSTALL_PREFIX=${ETKPATH}/amrex-lib \
      -DAMReX_GPU_BACKEND=CUDA \
      -DAMReX_CUDA_ARCH=9.0 \
      -DAMReX_FORTRAN=OFF \
      -DAMReX_FORTRAN_INTERFACES=OFF \
      -DAMReX_OMP=OFF \
      -DAMReX_PARTICLES=ON \
      -DAMReX_PRECISION=DOUBLE \
      .. && \
make -j24 install

#cd ${ETKPATH}

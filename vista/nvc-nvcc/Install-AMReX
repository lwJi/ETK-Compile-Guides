#!/bin/bash

export CC=$(which nvc)
export CXX=$(which nvc++)
export FC=$(which gfortran)
export CFLAGS="-I${TACC_NVIDIA_INC}"
export CXXFLAGS="-I${TACC_NVIDIA_INC}"
export LDFLAGS="-L${TACC_NVIDIA_LIB}"

cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo \
      -DCMAKE_INSTALL_PREFIX=${WORK}/local/amrex-lib \
      -DAMReX_GPU_BACKEND=CUDA \
      -DAMReX_CUDA_ARCH=9.0 \
      -DAMReX_DIFFERENT_COMPILER=ON \
      -DAMReX_FORTRAN=OFF \
      -DAMReX_FORTRAN_INTERFACES=OFF \
      -DAMReX_OMP=OFF \
      -DAMReX_PARTICLES=ON \
      -DAMReX_PRECISION=DOUBLE \
      .. && \
make -j24 install

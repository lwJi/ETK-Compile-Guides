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
      -DCMAKE_CUDA_COMPILER=nvcc \
      -DCMAKE_CUDA_FLAGS='-pipe -g --compiler-options -march=native -std=c++17 --compiler-options -std=gnu++17 --expt-relaxed-constexpr --extended-lambda --gpu-architecture sm_86 --forward-unknown-to-host-compiler --Werror ext-lambda-captures-this --relocatable-device-code=true --objdir-as-tempdir -x cu' \
      -DCMAKE_CUDA_COMPILER_FORCED=ON \
      -DCMAKE_CUDA_COMPILE_FEATURES=cuda_std_17 \
      -DAMReX_GPU_BACKEND=CUDA \
      -DAMReX_CUDA_ARCH=8.6+PTX \
      -DAMReX_DIFFERENT_COMPILER=ON \
      -DAMReX_FORTRAN=OFF \
      -DAMReX_FORTRAN_INTERFACES=OFF \
      -DAMReX_OMP=OFF \
      -DAMReX_PARTICLES=ON \
      -DAMReX_PRECISION=DOUBLE \
      .. && \
make -j24 install

#cd ${ETKPATH}

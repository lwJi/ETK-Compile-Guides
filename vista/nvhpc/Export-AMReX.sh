#!/bin/bash

export AMREX_CUDA_ARCH=8.6+PTX
export CC=$(which nvc)
export CXX=$(which nvc++)
export FC=$(which nvfortran)
export CFLAGS="-I${TACC_NVIDIA_INC} -I${TACC_CUDA_INC}"
export CXXFLAGS="-cuda -gpu=cc90,rdc -I${TACC_NVIDIA_INC} -I${TACC_CUDA_INC}"
export LDFLAGS="-L${TACC_NVIDIA_LIB} -L${TACC_CUDA_LIB}"

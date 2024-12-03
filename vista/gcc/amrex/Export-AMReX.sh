#!/bin/bash

export AMREX_CUDA_ARCH=8.6+PTX
export CC=$(which gcc)
export CXX=$(which g++)
export FC=$(which gfortran)
export CFLAGS="-I${TACC_CUDA_INC}"
export CXXFLAGS="-I${TACC_CUDA_INC}"
export LDFLAGS="-L${TACC_CUDA_LIB}"

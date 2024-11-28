#!/bin/bash

export CC=$(which nvc)
export CXX=$(which nvc++)
export FC=$(which nvfortran)
export CFLAGS="-I${TACC_NVIDIA_INC}"
export CXXFLAGS="-I${TACC_NVIDIA_INC}"
export LDFLAGS="-L${TACC_NVIDIA_LIB}"

#!/bin/bash

module reset
module load craype-accel-nvidia90
module load gcc-native/14
module load cray-mpich/9.0.1
module load cudatoolkit/25.5_12.9
module load cray-hdf5-parallel
module load cmake/3.30.2
module load openblas
module load gsl
module load cray-fftw

export MPICH_GPU_SUPPORT_ENABLED=1

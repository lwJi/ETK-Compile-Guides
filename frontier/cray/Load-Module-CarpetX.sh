#!/bin/bash

###############################################################################
# basic
###############################################################################
module reset
#module load cpe/24.07
#module load PrgEnv-cray
module load craype-accel-amd-gfx90a
module load amd-mixed/6.1.3
module load rocm/6.1.3

module unload darshan-runtime

###############################################################################
# more for carpetx
###############################################################################
module load cray-fftw
module load cray-hdf5-parallel
module load openpmd-api
module load boost
module load hwloc
module load adios2
module load libjpeg-turbo
module load openblas
module load zlib
module load gsl

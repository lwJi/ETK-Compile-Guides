#!/bin/bash

###############################################################################
# basic
###############################################################################
module reset
module load PrgEnv-amd
module load cpe/24.07
module load amd/6.1.3
module load rocm/6.1.3
module load craype-accel-amd-gfx90a

###############################################################################
# more for carpetx
###############################################################################
module load cray-hdf5-parallel
module load openpmd-api
module load boost
module load hwloc
module load adios2
#module load libjpeg-turbo
#module load openblas
#module load zlib
#module load gsl
#module load cray-fftw

#!/bin/bash

###############################################################################
# basic
###############################################################################
#module reset
#module load PrgEnv-cray/8.5.0
module load cpe/23.12
module load craype-accel-amd-gfx90a
module load amd-mixed/6.0.0

###############################################################################
# more for carpetx
###############################################################################
module load cray-fftw
module load cray-hdf5-parallel
module load openpmd-api
module load boost
module load gsl
module load hwloc
module load openblas
module load zlib
module load adios2
module load libjpeg-turbo

module unload darshan-runtime

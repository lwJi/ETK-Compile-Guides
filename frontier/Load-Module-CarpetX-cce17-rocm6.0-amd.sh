#!/bin/bash

###############################################################################
# basic
###############################################################################
module reset
module load PrgEnv-cray/8.5.0
module load cce/17.0.0
module load cpe/23.12
module load cray-mpich/8.1.28
module load craype-accel-amd-gfx90a
module load amd-mixed/6.0.0

#module load craype/2.7.30
#module load craype-network-ofi
#module load craype-x86-trento
#module load cray-libsci/23.12.5
#module load cray-dsmml/0.2.2
#module load cray-pmi/6.1.13
#module load perftools-base/23.12.0
#module load xpmem/2.6.2-2.5_2.22__gd067c3f.shasta

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

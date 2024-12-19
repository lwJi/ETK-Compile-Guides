#!/bin/bash

###############################################################################
# basic
###############################################################################
module reset

module unload darshan-runtime

module load cce/18.0.0
#module load cpe/24.07
module load cray-mpich/8.1.30
module load craype-accel-amd-gfx90a
module load rocm/6.1.3

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

###############################################################################
# set more env variables
###############################################################################
export LD_LIBRARY_PATH=${CRAY_LD_LIBRARY_PATH}:${LD_LIBRARY_PATH}

export MPICH_GPU_SUPPORT_ENABLED=1
export PE_MPICH_GTL_DIR_amd_gfx90a="-L/opt/cray/pe/mpich/8.1.30/gtl/lib"
export PE_MPICH_GTL_LIBS_amd_gfx90a="-lmpi_gtl_hsa"

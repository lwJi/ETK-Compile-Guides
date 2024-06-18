#!/bin/bash

module reset
module load PrgEnv-cray
module load cray-mpich/8.1.27
module load craype-accel-amd-gfx90a
module load amd-mixed/6.0.0

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

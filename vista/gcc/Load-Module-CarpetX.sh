#!/bin/bash

module reset

module unload openmpi
module unload nvidia

module load gcc/14.2.0
module load nvpl/24.7
module load openmpi/5.0.5
module load phdf5
module load boost
module load fftw3
module load gsl
module load zlib
module load adios2

#module load silo

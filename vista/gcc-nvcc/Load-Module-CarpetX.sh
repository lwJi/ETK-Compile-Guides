#!/bin/bash

module reset

module unload openmpi
module unload nvidia

module load gcc/13.2.0
module load cuda/12.5
module load nvmath/12.6.0
module load nvpl/24.5
module load openmpi/5.0.5
module load phdf5
module load boost
module load fftw3
module load gsl
module load zlib

#module load adios2
#module load silo

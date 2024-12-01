#!/bin/bash

module reset

module unload openmpi
module unload nvidia

module load gcc/13.2.0
module load cuda
module load nvmath
module load openmpi
module load phdf5
module load adios2
module load boost
module load fftw3
module load gsl
module load zlib

#module load silo

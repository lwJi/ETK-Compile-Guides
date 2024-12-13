#!/bin/bash

module reset

module unload python3

module load intel/23.1.0 &&
module load impi/21.9.0 &&
module load gsl/2.7.1 &&
module load phdf5/1.14.4 &&
module load boost/1.86.0 &&
module load petsc/3.22 &&
module load papi/5.7.0 &&
module load hwloc/1.11.13 &&
module load cmake/3.24.2


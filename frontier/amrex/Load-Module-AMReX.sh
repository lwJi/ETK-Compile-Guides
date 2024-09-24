#!/bin/bash

#module reset
#module load cpe/24.07
module load PrgEnv-gnu
module load cray-mpich/8.1.28
module load craype-accel-amd-gfx90a
module load amd-mixed/6.1.3

module unload darshan-runtime

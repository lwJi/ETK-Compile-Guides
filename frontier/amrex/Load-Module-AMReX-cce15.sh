#!/bin/bash

#module reset
#module load PrgEnv-cray
module load cray-mpich/8.1.27
module load craype-accel-amd-gfx90a
module load amd-mixed/6.0.0

module unload darshan-runtime

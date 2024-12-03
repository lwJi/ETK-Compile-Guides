#!/bin/bash

# Exit on error
set -e

# Check if ETKPATH is set
if [ -z "${ETKPATH}" ]; then
    echo "Error: ETKPATH is not set. Please set it before running this script."
    exit 1
fi

# Define paths
AMREX_REPO="https://github.com/AMReX-Codes/amrex.git"
ETKPATH=${ETKPATH:-$HOME/EinsteinToolkit}  # Default to a path if ETKPATH is not set
AMREX_DIR="${ETKPATH}/amrex"
AMREX_BUILD_DIR="${AMREX_DIR}/build"
AMREX_LIB_DIR="${ETKPATH}/amrex-lib"

# Clone AMReX repository
echo "Cloning AMReX repository..."
cd "${ETKPATH}"
if [ ! -d "${AMREX_DIR}" ]; then
    git clone "${AMREX_REPO}" amrex
else
    echo "AMReX directory already exists. Skipping clone."
fi

# Create directories for build and installation
mkdir -p "${AMREX_BUILD_DIR}" "${AMREX_LIB_DIR}"

# Set environment variables for compiler and flags
export CC=$(which gcc)
export CXX=$(which g++)
export FC=$(which gfortran)
export CFLAGS="-I${TACC_CUDA_INC}"
export CXXFLAGS="-I${TACC_CUDA_INC}"
export LDFLAGS="-L${TACC_CUDA_LIB}"

# Build and install AMReX
echo "Building AMReX..."
cd "${AMREX_BUILD_DIR}"
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo \
      -DCMAKE_INSTALL_PREFIX=${ETKPATH}/amrex-lib \
      -DAMReX_GPU_BACKEND=CUDA \
      -DAMReX_CUDA_ARCH=9.0 \
      -DAMReX_FORTRAN=OFF \
      -DAMReX_FORTRAN_INTERFACES=OFF \
      -DAMReX_OMP=OFF \
      -DAMReX_PARTICLES=ON \
      -DAMReX_PRECISION=DOUBLE \
      .. && \
make -j24 install

echo "AMReX has been successfully built and installed in ${AMREX_LIB_DIR}."

# Return to ETKPATH
cd ${ETKPATH}
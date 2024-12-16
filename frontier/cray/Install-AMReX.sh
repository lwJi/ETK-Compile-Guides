#!/bin/bash

# Exit on error
set -e

# Check if ETKPATH is set
if [ -z "${ETKPATH}" ]; then
    echo "Error: ETKPATH is not set. Please set it before running this script."
    exit 1
fi

# Define paths
#AMREX_REPO="https://github.com/AMReX-Codes/amrex.git"
AMREX_REPO="https://github.com/lwJi/amrex.git"
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
export MPICH_GPU_SUPPORT_ENABLED=1
export PE_MPICH_GTL_DIR_amd_gfx90a="-L/opt/cray/pe/mpich/8.1.28/gtl/lib"
export AMREX_AMD_ARCH=gfx90a
export CC=$(which cc)
export CXX=$(which CC)
export FC=$(which ftn)
export CFLAGS="-I${ROCM_PATH}/include"
export CXXFLAGS="-I${ROCM_PATH}/include -Wno-pass-failed -mllvm -amdgpu-function-calls=true"
export LDFLAGS="-L${ROCM_PATH}/lib -lamdhip64 ${PE_MPICH_GTL_DIR_amd_gfx90a} -lmpi_gtl_hsa"

# Build and install AMReX
echo "Building AMReX..."
cd "${AMREX_BUILD_DIR}"
cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo \
      -DCMAKE_INSTALL_PREFIX=${ETKINSTALL}/amrex-lib \
      -DCMAKE_PREFIX_PATH='${ROCM_PATH}/lib/cmake/AMDDeviceLibs;${ROCM_PATH}/lib/cmake/amd_comgr;${ROCM_PATH}/lib/cmake/hip;${ROCM_PATH}/lib/cmake/hiprand;${ROCM_PATH}/lib/cmake/hsa-runtime64;${ROCM_PATH}/lib/cmake/rocprim;${ROCM_PATH}/lib/cmake/rocrand' \
      -DAMReX_GPU_BACKEND=HIP \
      -DAMReX_AMD_ARCH=gfx90a \
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

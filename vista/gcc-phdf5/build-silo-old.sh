#! /bin/bash

################################################################################
# Build
################################################################################

# Set up shell
if [ "$(echo ${VERBOSE} | tr '[:upper:]' '[:lower:]')" = 'yes' ]; then
    set -x                      # Output commands
fi
set -e                          # Abort on errors


    
# Define some environment variables
export CC=${EXTERNAL_CC:-${CC}}
export CXX=${EXTERNAL_CXX:-${CXX}}
export F90=${EXTERNAL_F90:-${F90}}
export LD=${EXTERNAL_LD:-${LD}}
export CFLAGS=${EXTERNAL_CFLAGS:-${CFLAGS}}
export CXXFLAGS=${EXTERNAL_CXXFLAGS:-${CXXFLAGS}}
export F90FLAGS=${EXTERNAL_F90FLAGS:-${F90FLAGS}}
export LDFLAGS=${EXTERNAL_LDFLAGS:-${LDFLAGS}}



# Set locations
THORN=Silo
NAME=silo-4.11.1
SRCDIR="$(dirname $0)"
BUILD_DIR=${SCRATCH_BUILD}/build/${THORN}
if [ -z "${SILO_INSTALL_DIR}" ]; then
    INSTALL_DIR=${SCRATCH_BUILD}/external/${THORN}
else
    echo "BEGIN MESSAGE"
    echo "Installing Silo into ${SILO_INSTALL_DIR}"
    echo "END MESSAGE"
    INSTALL_DIR=${SILO_INSTALL_DIR}
fi
DONE_FILE=${SCRATCH_BUILD}/done/${THORN}
SILO_DIR=${INSTALL_DIR}

echo "Silo: Preparing directory structure..."
cd ${SCRATCH_BUILD}
mkdir build external done 2> /dev/null || true
rm -rf ${BUILD_DIR} ${INSTALL_DIR}
mkdir ${BUILD_DIR} ${INSTALL_DIR}

# Build core library
echo "Silo: Unpacking archive..."
pushd ${BUILD_DIR}
${TAR?} xf ${SRCDIR}/../dist/${NAME}.tar

cd ${NAME}

echo "Silo: Applying patches..."
${PATCH?} -p1 < ${SRCDIR}/../dist/config_site.patch
# Some (ancient but still used) versions of patch don't support the
# patch format used here but also don't report an error using the exit
# code. So we use this patch to test for this
${PATCH?} -p1 < ${SRCDIR}/../dist/patchtest.patch
if [ ! -e .patch_tmp ]; then
    echo 'BEGIN ERROR'
    echo 'The version of patch is too old to understand this patch format.'
    echo 'Please set the PATCH environment variable to a more recent '
    echo 'version of the patch command.'
    echo 'END ERROR'
    exit 1
fi
rm -f .patch_tmp

echo "Silo: Configuring..."

unset LIBS

# Silo fails with HDF5 1.12 due to H5Oget_info silently having changed its API,
# so force the minimum knonw API to work
CPPFLAGS="$CPPFLAGS -DH5Oget_info_vers=1 -DH5O_info_t_vers=1"

if [ "${CCTK_DEBUG_MODE}" = yes ]; then
    SILO_OPTIMISE=
else
    SILO_OPTIMISE=--enable-optimization
fi

mkdir build
cd build
# need to extract the actual directory with HDF5 in it from the potentially
# longer list HDF5 supplied
HDF5_INC_DIR="`for DIR in $HDF5_INC_DIRS ; do
  ls 2>/dev/null $DIR/hdf5.h
done | head -n1 | sed 's!/hdf5\.h$!!'`"
HDF5_LIB_DIR="`for DIR in $HDF5_LIB_DIRS; do
  ls 2>/dev/null $DIR/libhdf5.* $HDF5_LIB_DIRS/hdf5.lib $HDF5_LIB_DIRS/*hdf5.dylib
done | head -n1 | sed 's!/[^/]*$!!'`"
export LIBS="$(echo '' $(for lib in ${HDF5_LIBS} ${SILO_CCTK_LIBS}; do echo '' -l$lib; done))"
export CFLAGS="$CFLAGS $(echo '' $(for dir in ${HDF5_INC_DIRS}; do echo '' -I${dir}; done))"
export LDFLAGS="$LDFLAGS $(echo '' $(for dir in ${HDF5_LIB_DIRS} ${SILO_CCTK_LIBDIRS}; do echo '' -L${dir} -Wl,-rpath,${dir}; done))"

# ZFP compression leads to compile time failures in zfp due to only some code
# being awre of using a bns struct rather than globals
# force libdir so that it does not change from lib to lib64 and we can refer to
# it in detect.sh
../configure --disable-zfp --disable-fortran ${SILO_OPTIMISE} --with-hdf5=${HDF5_INC_DIR},${HDF5_LIB_DIR} --prefix=${INSTALL_DIR} --libdir=${INSTALL_DIR}/lib

echo "Silo: Building..."
${MAKE}

echo "Silo: Installing..."
${MAKE} install
popd

echo "Silo: Cleaning up..."
rm -rf ${BUILD_DIR}

date > ${DONE_FILE}
echo "Silo: Done."

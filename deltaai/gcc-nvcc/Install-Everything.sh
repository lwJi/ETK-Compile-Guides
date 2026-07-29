#!/bin/bash

set -euo pipefail

if [[ -z "${ETKGUIDE:-}" ]]; then
  echo "ETKGUIDE is not set." >&2
  echo "Example: export ETKGUIDE=/path/to/ETK-Compile-Guides/deltaai" >&2
  exit 1
fi
if [[ -z "${ETKPATH:-}" ]]; then
  echo "ETKPATH is not set." >&2
  echo "Example: export ETKPATH=\$WORK/EinsteinToolkit" >&2
  exit 1
fi

CONFIGURATION="${CONFIGURATION:-asterx}"
THORNLIST_URL="${THORNLIST_URL:-https://raw.githubusercontent.com/jaykalinani/ETK-Compile-Guides/main/ThornList/asterx.th}"
THORNLIST_FILE="${THORNLIST_FILE:-thornlists/asterx.th}"
FRESH_BUILD="${FRESH_BUILD:-yes}"

source "${ETKGUIDE}/gcc-nvcc/Load-Module-CarpetX.sh"

mkdir -p "${ETKPATH}"
cd "${ETKPATH}"

if [[ ! -x GetComponents ]]; then
  curl --fail --location --show-error --remote-name \
    https://raw.githubusercontent.com/gridaphobe/CRL/master/GetComponents
  chmod a+x GetComponents
fi

if [[ ! -d Cactus ]]; then
  ./GetComponents --root Cactus --parallel --no-shallow "${THORNLIST_URL}"
fi

if [[ ! -f "${ETKPATH}/Cactus/${THORNLIST_FILE}" ]]; then
  echo "Thorn list not found: ${ETKPATH}/Cactus/${THORNLIST_FILE}" >&2
  exit 1
fi

simfactory_dir="${ETKPATH}/Cactus/repos/simfactory2"
if [[ ! -d "${simfactory_dir}" ]]; then
  simfactory_dir="${ETKPATH}/Cactus/simfactory"
fi
if [[ -d "${simfactory_dir}/mdb" ]]; then
  install -m 0644 "${ETKGUIDE}/deltaai.ini" \
    "${simfactory_dir}/mdb/machines/deltaai.ini"
  install -m 0644 "${ETKGUIDE}/gcc-nvcc/deltaai.cfg" \
    "${simfactory_dir}/mdb/optionlists/deltaai.cfg"
  install -m 0644 "${ETKGUIDE}/deltaai.sub" \
    "${simfactory_dir}/mdb/submitscripts/deltaai.sub"
  install -m 0755 "${ETKGUIDE}/deltaai.run" \
    "${simfactory_dir}/mdb/runscripts/deltaai.run"
fi

build_args=(
  -e "${CONFIGURATION}"
  -t "${THORNLIST_FILE}"
  -c "${ETKGUIDE}/gcc-nvcc/deltaai.cfg"
)
if [[ "${FRESH_BUILD}" == "yes" ]]; then
  build_args+=(--fresh)
fi

cd "${ETKPATH}/Cactus"
"${ETKGUIDE}/../CompileScript/Compile-ETK" "${build_args[@]}"

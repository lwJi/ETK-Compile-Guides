#!/bin/bash
#SBATCH --job-name=etk-gh200
#SBATCH --partition=ghx4-interactive
#SBATCH --account=bgmi-dtai-gh
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=72
#SBATCH --gpus-per-node=4
#SBATCH --gpus-per-task=1
#SBATCH --gpu-bind=closest
#SBATCH --exclusive
#SBATCH --mem=480G
#SBATCH --time=00:30:00
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err

set -euo pipefail

module reset
source "${WORK}/ETK-Compile-Guides/deltaai/gcc-nvcc/Load-Module-CarpetX.sh"
module list

export MPICH_GPU_SUPPORT_ENABLED=1
export OMP_NUM_THREADS=72
export OMP_PLACES=cores
export OMP_PROC_BIND=spread
export OMP_STACKSIZE=64M

EXE="${EXE:-${WORK}/EinsteinToolkit/Cactus/exe/cactus_asterx}"
PARFILE="${1:-${PARFILE:-}}"
RUN_DIR="${RUN_DIR:-${SLURM_SUBMIT_DIR}}"

if [[ -z "${PARFILE}" ]]; then
  echo "Usage: sbatch $0 /absolute/path/to/simulation.par" >&2
  echo "Alternatively export PARFILE before calling sbatch." >&2
  exit 2
fi
if [[ ! -x "${EXE}" ]]; then
  echo "Executable not found or not executable: ${EXE}" >&2
  exit 2
fi
if [[ ! -f "${PARFILE}" ]]; then
  echo "Parameter file not found: ${PARFILE}" >&2
  exit 2
fi

cd "${RUN_DIR}"
echo "Starting ${EXE} on ${SLURM_NNODES} node(s) at $(date)"

time srun \
  --ntasks="${SLURM_NTASKS}" \
  --ntasks-per-node=4 \
  --cpus-per-task=72 \
  --gpus-per-task=1 \
  --gpu-bind=closest \
  --cpu-bind=cores \
  --distribution=block:block \
  "${EXE}" -L 3 "${PARFILE}"

#!/bin/bash -
#SBATCH -o spectre.stdout
#SBATCH -e spectre.stderr
#SBATCH --ntasks-per-node 20
#SBATCH -J KerrSchild
#SBATCH --nodes 8
#SBATCH -p orca-1
#SBATCH -t 24:00:00
#SBATCH -D .

# Distributed under the MIT License.
# See LICENSE.txt for details.

# To run a job on Ocean:
# - Set the -J, --nodes, and -t options above, which correspond to job name,
#   number of nodes, and wall time limit in HH:MM:SS, respectively.
# - Set the build directory, run directory, executable name,
#   and input file below. The input file path is relative to ${RUN_DIR}.
#
# NOTE: The executable will not be copied from the build directory, so if you
#       update your build directory this file will use the updated executable.
#
# Optionally, if you need more control over how SpECTRE is launched on
# Ocean you can edit the launch command at the end of this file directly.
#
# To submit the script to the queue run:
#   sbatch Ocean.sh

export SPECTRE_BUILD_DIR=/home/geoffrey/Codes/spectre/spectre-kerrschild-rebase/build
export SPECTRE_EXECUTABLE=EvolveGeneralizedHarmonic
export SPECTRE_INPUT_FILE=./KerrSchild.yaml

source ${SPECTRE_BUILD_DIR}/../support/Environments/ocean_gcc.sh
spectre_load_modules

############################################################################
# Set desired permissions for files created with this script
umask 0022

export PATH=${SPECTRE_BUILD_DIR}/bin:$PATH
#cd ${RUN_DIR}

# The 23 is there because Charm++ uses one thread per node for communication
#srun -n ${SLURM_JOB_NUM_NODES} -c 20 ${SPECTRE_EXECUTABLE} ++ppn 19 --input-file ${SPECTRE_INPUT_FILE}
#charmrun --map-by ppr:1:node +p228 ./EvolveValenciaDivClean +ppn 19 +pemap 0-18 +commap 19 ++mpiexec --input-file CylindricalBlastWave.yaml &> spectre.out
mpirun -np 8 --map-by ppr:1:node ./EvolveGeneralizedHarmonic +ppn 19 +pemap 0-18 +commap 19 --input-file KerrSchild.yaml

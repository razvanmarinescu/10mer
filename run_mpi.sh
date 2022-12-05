#!/bin/bash
#SBATCH -A m4229
#SBATCH -C gpu
#SBATCH -q regular
#SBATCH -t 11:58:00
#SBATCH -N 21
#SBATCH --ntasks-per-node=4
#SBATCH -c 32
#SBATCH --gpus-per-task=1
#SBATCH --gpu-bind=map_gpu:0,1,2,3
#SBATCH --job-name=10mer
#SBATCH --output=slurm.out

export SLURM_CPU_BIND="cores"

# Make sure environment is set
source env_mpi.sh

# Clean up
rm -f west.log
cp west_mab.cfg west.cfg


export OMPI_MCA_pml=ob1
export OMPI_MCA_btl="self,tcp"
export OMPI_MCA_opal_warn_on_missing_libcuda=0
export OMPI_MCA_opal_cuda_support=true

export PMIX_MCA_psec=native

which mpiexec
echo 'tasks:' $SLURM_NTASKS
echo $WEST_ROOT
echo $WEST_PYTHON
echo $WEST_BIN

# Run w_run
srun --mpi=pmix -n $SLURM_NTASKS w_run --work-manager mpi "$@"


#w_run --work-manager processes "$@"
#w_run --work-manager serial "$@" # check on wiki for serial managers, etc .. 

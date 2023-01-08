#!/bin/bash
#SBATCH -A bbpa-delta-gpu
#SBATCH --partition=gpuA40x4
#SBATCH -t 11:58:00
#SBATCH --cpus-per-task=2    # <- match to OMP_NUM_THREADS
#SBATCH -N 56
#SBATCH --ntasks-per-node=4
#SBATCH --gpus-per-task=1
#SBATCH --gpus-per-node=4
#SBATCH --job-name=10mer
#SBATCH --output=slurm.out
#SBATCH --mail-user=mrazvan22@gmail.com

#module reset
#module load gcc/11.2.0 openmpi  # ... or any appropriate modules
#module list  # job documentation and metadata

export SLURM_CPU_BIND="cores"
export OMP_NUM_THREADS=2

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

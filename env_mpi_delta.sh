#!/bin/bash

# Set up environment for westpa
# Actviate a conda environment containing westpa, openmm and mdtraj;
# you may need to create this first (see install instructions)


#module use /global/common/software/m3169/perlmutter/modulefiles
#module load openmpi

export TMPDIR=/scratch/bbpa/rmarinescu/westpa_tmp/
mkdir -p $TMPDIR


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/sw/external/python/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/sw/external/python/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/sw/external/python/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/sw/external/python/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


#/global/common/software/m4229/miniconda/condabin/conda activate westpa
which conda
source activate westpa

export HDF5_USE_FILE_LOCKING=0 # processes have trouble writing to hdf5 otherwise

export MPI=1

export WEST_SIM_ROOT="$PWD"
export SIM_NAME=$(basename $WEST_SIM_ROOT)

export WM_N_WORKERS=1

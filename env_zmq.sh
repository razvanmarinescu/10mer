#!/bin/bash

# Set up environment for westpa
# Actviate a conda environment containing westpa, openmm and mdtraj;
# you may need to create this first (see install instructions)


module use /global/common/software/m3169/perlmutter/modulefiles
#module load openmpi

export TMPDIR=$PSCRATCH
mkdir -p $TMPDIR

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/global/common/software/m4229/miniconda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
	    eval "$__conda_setup"
    else
	        if [ -f "/global/common/software/m4229/miniconda/etc/profile.d/conda.sh" ]; then
			        . "/global/common/software/m4229/miniconda/etc/profile.d/conda.sh"
				    else
					            export PATH="/global/common/software/m4229/miniconda/bin:$PATH"
						        fi
fi
unset __conda_setup
# <<< conda initialize <<<


#/global/common/software/m4229/miniconda/condabin/conda activate westpa
which conda
source activate westpa-dev

export HDF5_USE_FILE_LOCKING=0 # processes have trouble writing to hdf5 otherwise

export MPI=0
export ZMQ=1

export WEST_SIM_ROOT="$PWD"
export SIM_NAME=$(basename $WEST_SIM_ROOT)

export WM_N_WORKERS=4
export WM_WORK_MANAGER=zmq
export WM_ZMQ_COMM_MODE=tcp
export WM_ZMQ_SERVER_INFO=$WEST_SIM_ROOT/wemd_server_info.json
export PMIX_MCA_psec=native

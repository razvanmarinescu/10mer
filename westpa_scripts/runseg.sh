#!/bin/bash

if [ -n "$SEG_DEBUG" ] ; then
  set -x
  env | sort
fi

cd $WEST_SIM_ROOT
mkdir -pv $WEST_CURRENT_SEG_DATA_REF
cd $WEST_CURRENT_SEG_DATA_REF
echo $WEST_CURRENT_SEG_DATA_REF

#sed "s/RAND/$WEST_RAND16/g" $WEST_SIM_ROOT/common_files/run_md.py > run_md.py


## uncomment the following code when HDF5 framework is off ##
# don't use symbolic links, as the folders are turned into .h5 files
#ln -sv $WEST_SIM_ROOT/common_files/bstate.psf .
#ln -sv $WEST_SIM_ROOT/common_files/bstate.pdb .
#cp $WEST_PARENT_DATA_REF/seg.xml ./parent.xml 
#cp $WEST_PARENT_DATA_REF/seg.dcd ./parent.dcd

if ! [[ -z "${ZMQ}" ]]; then
echo 'ZMQ mode: setting CUDA_VISIBLE_DEVICES to a single GPU'
export CUDA_DEVICES=(`echo $CUDA_VISIBLE_DEVICES_ALLOCATED | tr , ' '`)
export CUDA_VISIBLE_DEVICES=${CUDA_DEVICES[$WM_PROCESS_INDEX]}
echo "WM_PROCESS_INDEX: $WM_PROCESS_INDEX"
echo "CUDA_DEVICES: $CUDA_DEVICES"
echo "CUDA_VISIBLE_DEVICES: $CUDA_VISIBLE_DEVICES"
fi

# Run the dynamics with OpenMM
# python run_md.py SEED GPU_DEVICE
echo 'Will run dynamics'
date
nvidia-smi
echo python $WEST_SIM_ROOT/common_files/run_md.py $WEST_RAND16 $WM_PROCESS_INDEX
python $WEST_SIM_ROOT/common_files/run_md.py $WEST_RAND16 $WM_PROCESS_INDEX
date
#Calculate pcoord with MDAnalysis
python $WEST_SIM_ROOT/common_files/dist.py > $WEST_PCOORD_RETURN
date


cp bstate.pdb $WEST_TRAJECTORY_RETURN
cp seg.dcd $WEST_TRAJECTORY_RETURN

cp bstate.pdb $WEST_RESTART_RETURN
cp seg.xml $WEST_RESTART_RETURN/parent.xml

cp seg.log $WEST_LOG_RETURN
date

# Clean up
#rm -f dist.dat run_md.py

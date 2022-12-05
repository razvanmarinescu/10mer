#!/bin/bash
set -x

mkdir -p $WEST_STRUCT_DATA_REF
cd $WEST_STRUCT_DATA_REF
echo `pwd`
# don't use symbolic links, as the folders are turned into .h5 files
#cp $WEST_SIM_ROOT/common_files/xray.xml xray.xml
#cp $WEST_SIM_ROOT/common_files/xray.pdb xray.pdb
#cp $WEST_SIM_ROOT/common_files/bstate.psf bstate.psf
cp $WEST_SIM_ROOT/common_files/bstate.xml seg.xml
#cp $WEST_SIM_ROOT/common_files/bstate.dcd seg.dcd

python $WEST_SIM_ROOT/common_files/dist_init.py > pcoord.init

cat $WEST_STRUCT_DATA_REF/pcoord.init > $WEST_PCOORD_RETURN 

cp $WEST_SIM_ROOT/common_files/bstate.pdb $WEST_TRAJECTORY_RETURN
#cp /home/bizon/research/md/twodimers/istates/1/2/basis.xml /tmp/tmpzembelm4
cp $WEST_SIM_ROOT/common_files/bstate.xml basis.xml #made a copy of basis.xml
cp $WEST_STRUCT_DATA_REF/basis.xml $WEST_TRAJECTORY_RETURN

cp $WEST_SIM_ROOT/common_files/bstate.pdb $WEST_RESTART_RETURN
cp $WEST_STRUCT_DATA_REF/seg.xml $WEST_RESTART_RETURN/parent.xml

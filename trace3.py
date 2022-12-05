import h5py
import numpy
import mdtraj
import os
import sys
# python trace3.py <iteration> <segment_nr>


#294 [84]
# 405 seg: [87]
#iteration = 405 
iteration = int(sys.argv[1])
#segment = 87
segment = int(sys.argv[2])
pcoord_len = 5


os.system("w_trace -W west2.h5 %s:%s"%(iteration,segment))

iter_list = numpy.loadtxt("traj_%s_%s_trace.txt"%(iteration,segment), usecols=0, skiprows=8)
seg_list = numpy.loadtxt("traj_%s_%s_trace.txt"%(iteration,segment), usecols=1, skiprows=8)

print("tracing trajectory...")

seg_val = int(seg_list[0])
first_iter_h5_filepath = "./traj_segs/iter_"+str(1).zfill(6)+".h5"
pointer = h5py.File(first_iter_h5_filepath)['pointer'][:,1]
where = numpy.where(pointer == seg_val)
print(seg_val, where)
traj_trace = mdtraj.load(first_iter_h5_filepath)[where]

for idx, iter_val in enumerate(iter_list[1:]):
    idx += 1
    iter_h5_filepath = "./traj_segs/iter_"+str(int(iter_val)).zfill(6)+".h5"
    seg_val = int(seg_list[idx])
    pointer = h5py.File(iter_h5_filepath)['pointer'][:,1]
    where = numpy.where(pointer == seg_val)
    print(seg_val, where)
    next_traj = mdtraj.load(iter_h5_filepath)[where]
    traj_trace = mdtraj.join((traj_trace, next_traj))
fi = "trace%d_%d.dcd" % (iteration, segment)
traj_trace.save(fi)
print("trajectory successfully saved to " + fi)

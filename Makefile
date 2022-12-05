jstart:
	 jupyter notebook --no-browser --port=8888

jssh:
	ssh -N -f -L localhost:8890:localhost:8888 bizon@128.114.59.144

#mount:
#        sudo umount mnt; sudo sshfs -o kill_on_unmount,reconnect,allow_other,defer_permissions,IdentityFile=~/.ssh/id_rsa bizon@73.162.206.107:/home/bizon/research/md/twodimers  mnt

pdist:
	#cp west.h5 west2.h5; /home/bizon/anaconda3/envs/westpa-dev/bin/w_pdist -W west2.h5
	cp west.h5 west2.h5; /global/common/software/m4229/miniconda/envs/westpa-dev/bin/w_pdist -W west2.h5
	plothist evolution pdist.h5


clean:
	rm -rf traj_segs seg_logs istates west.h5

sbatch:
	sbatch ./run_mpi.sh

int:
	salloc --nodes 1 --qos interactive --time 01:00:00 --constraint gpu --gpus 1 --account=m4229

# got it working!!!! use commmand below
intmpi:
	salloc --nodes 2 --qos interactive --time 03:00:00 --constraint gpu --tasks-per-node=4 --gpus-per-task=1 --gpu-bind=map_gpu:0,1,2,3 -c 32 --job-name=trimer --account=m4229

find_pcoord:
	python find_pcoord.py <maxiter> <p_coord>
	python find_pcoord.py 750 800



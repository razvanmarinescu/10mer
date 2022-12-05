#/bin/bash
# script is called as ./truncate ITER_NR

if ! [ -z "$1" ] 
then
#echo traj_segs/*$1
#rm -rf traj_segs/*$1
echo w_truncate -n $1
w_truncate -n $1

for i in $(seq -f "%06g" $1 $(($1+50)))
do
  echo traj_segs/iter_$i
  rm -f traj_segs/iter_$i.h5
  rm -rf traj_segs/$i
done

fi

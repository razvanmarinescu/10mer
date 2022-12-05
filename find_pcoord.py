import numpy
import h5py
import os
import sys
# python find_pcoord.py <end_iteration <target_prog_coord>

os.system('cp west.h5 west2.h5')
h5file = h5py.File("west2.h5", 'r')
fi = 1 #start iteration
li = int(sys.argv[1]) # end iteration
target = int(sys.argv[2]) # target progress coordinate
target_walkers = []
for i in range(fi,li+1):
  i = str(i)
  iteration = "iter_" + str(numpy.char.zfill(i,8))
  pc = h5file['iterations'][iteration]['pcoord'][:,-1,0]
  print('iter ', i)
  #print('  pc', pc)
  #print('h5-full',  h5file['iterations'][iteration]['pcoord'][:,:,0] )
  #print(h5file['iterations'][iteration]['pcoord'].shape)
  #pc2 = h5file['iterations'][iteration]['pcoord'][:,-1,1]
  #pc2 = h5file['iterations'][iteration]['pcoord'][:,-1,0]
  weights = h5file['iterations'][iteration]['seg_index']['weight']
  for val in pc:
      if val < target:
          nw = numpy.where(pc==val)
          for seg in nw:
              seg_weight = weights[seg]
              #pcoord = pc[seg]
              print('iter:', int(i), 'seg:', seg, '  pcoord:', val, '  weight:', seg_weight)
#              if seg_weight[0] > 0.001:
#                  print(int(i), seg, val, pcoord2, seg_weight)
#              else:
#                  continue
              #target_walkers.append([int(i),seg.item(),seg_weight.item()])
#arr = numpy.array(target_walkers)

#numpy.set_printoptions(precision=5,suppress=True)

#print(arr)
#nw = numpy.where(max_values>(maxmax-maxmax*0.0001))
#iter_num = str((nw[0]+1)[0])
#
#wheretolook = "iter_" + str(numpy.char.zfill(iter_num,8))
#max_iter = h5file['iterations'][wheretolook]['pcoord'][:,-1,pcoord_dim-1]
#segmax = numpy.max(max_iter)
#nw2 = numpy.where(max_iter>(segmax-segmax*0.0001))
#seg_num = (nw2[0]+1)[0]
#print ("Maximum pcoord value for dimension",pcoord_dim,"is:",segmax) 
#print ("It is segment:",seg_num,"of iteration:",iter_num))

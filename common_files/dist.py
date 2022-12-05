#!/usr/bin/env python
#
# dist.py
#
# Calculate distance between key selected atoms at the interface of the protein. 
# We need all timepoints from the current segment, and the final timepoint
# from the parent segment (which is where the current segment starts)
# REQUIREMENT: this script should print, for each frame, either one number (e.g. 11.801), or 3 numbers (for 3D progress coordinate separated by space) 
import MDAnalysis as mda
from MDAnalysis.tests.datafiles import PSF, DCD, CRD
from MDAnalysis.analysis import rms,contacts
import MDAnalysis.lib.util
import numpy as np
import pickle

# Load the trajectory.
f = '../../../common_files/'
u = mda.Universe(f + 'packed.pdb', 'seg.dcd')

# contInd - (indices_group1, indices_group2) tuple of indices of c-alpha atoms from which to compute RMSD
# dist - distance matrix
def distBetweenContacts(contInd, dist):
  return dist[contInd[0], contInd[1]].mean()

def compDist(u):
    ds = pickle.load(open(f + "interfIndAll.npy", "rb" ) )
    pairs=ds['pairs']
    #uPairs=ds['uPairs']
    conts=ds['conts']
    dTarget=ds['dTarget']

    for ts in u.trajectory:
      tot = 0
      for p1, p2 in pairs: # ('A0', 'A1'), ... takes around 6s. so 6*5=30s for a single segment. So with 300segments and 32cores, it will take ~5min
          ca1 = u.select_atoms('name CA and segid ' + p1)
          ca2 = u.select_atoms('name CA and segid ' + p2)

          # distances in the current frame
          distM1M2 = contacts.distance_array(ca1.positions, ca2.positions)

          # distances at pre-selected contacts
          meanM1M2 = distBetweenContacts(conts[p1[0] + p2[0]], distM1M2)

          tot += meanM1M2
      
      print(tot)
    
d = compDist(u) # 79714.52531276768

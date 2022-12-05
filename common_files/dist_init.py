# dist_init.py
#
# Calculate distance between key selected atoms at ALL interfaces of the capsid (240 interfaces)
# REQUIREMENT: this script should only print one number (e.g. 11.801) per line, or 3 numbers (for 3D progress coordinate separated by space), to stdout, for initial state

import MDAnalysis as mda
from MDAnalysis.tests.datafiles import PSF, DCD, CRD
from MDAnalysis.analysis import rms,contacts
import MDAnalysis.lib.util
import numpy as np
import pickle


f = '../../common_files/'
# Load the trajectory.
u = mda.Universe(f + 'packed.pdb', f + 'bstate.pdb') # need to load original topology, as openMM doesn't save segids


# contInd - (indices_group1, indices_group2) tuple of indices of c-alpha atoms from which to compute RMSD
# dist - distance matrix
def distBetweenContacts(contInd, dist):
  return dist[contInd[0], contInd[1]].mean()

# distance in the reference protein, i.e. cristallographic structure with formed complex

#pickle.dump(dict(contB2D1=contB2D1, contB1C1=contB1C1, contA0A1=contA0A1), open(f + "contactIndices.npy", "wb" ) )

ds = pickle.load(open(f + "interfIndAll.npy", "rb" ) )
pairs=ds['pairs']
#uPairs=ds['uPairs']
conts=ds['conts']
dTarget=ds['dTarget']

tot = 0
for p1, p2 in pairs: # ('A0', 'A1'), ... takes around 6s. so 6*5=30s for a single segment. So with 300segments and 32cores, it will take ~5min
    #print(p1,p2)
    ca1 = u.select_atoms('name CA and segid ' + p1)
    ca2 = u.select_atoms('name CA and segid ' + p2)
    
    # distances in the current frame
    distM1M2 = contacts.distance_array(ca1.positions, ca2.positions)
    
    # distances at pre-selected contacts
    #print(conts.keys())
    #print(p1[0] + p2[0])
    meanM1M2 = distBetweenContacts(conts[p1[0] + p2[0]], distM1M2)
    #print(meanM1M2)
    #print(dTarget[p1[0] + p2[0]])
    tot += meanM1M2
    

print(tot) 

from openmm.app import *
from openmm import *
from openmm.unit import *
from sys import stdout
import time
start = time.time()
import os

# python run_md.py SEED GPU_DEVICE

RAND = int(sys.argv[1])
print('seed=', RAND)
NR_TOT_GPUS=4
if os.environ['MPI']:
	print('Running with MPI')
	GPU_DEVICE = [0]
else:
	GPU_DEVICE=int(sys.argv[2]) % NR_TOT_GPUS

pdb = PDBFile('bstate.pdb') # segIDs are A B C D, not A0, B1, ..
GB = True

if GB:
    forcefield = ForceField('amber14/protein.ff14SB.xml', 'implicit/gbn2.xml') # also works
else:
    forcefield = ForceField('amber14/protein.ff14SB.xml', 'amber14/tip4pew.xml') # also works

# making heavy hydrogens is actually 30% slower, prob due to the extra constraints
mode = 'normal'
if mode == 'heavy': # 670ns/day
  dt = 0.005*picoseconds
  constraints = AllBonds
  hydrogenMass = 4*amu
elif mode == 'noconstraints': #230ns/day
  dt = 0.001*picoseconds
  constraints = None
  hydrogenMass = 1.5*amu
else: # 900ns/day
  dt = 0.004*picoseconds
  constraints = HBonds
  hydrogenMass = 1.5*amu


# for speed, add CutoffNonPeriodic, to cutoff long-range electrostatics
# Peter Eastman: for GB, use 2nm cutoff
if GB:
    system = forcefield.createSystem(pdb.topology, nonbondedMethod=CutoffNonPeriodic, 
      nonbondedCutoff=2*nanometer, constraints=constraints, hydrogenMass=hydrogenMass)
else:
    system = forcefield.createSystem(pdb.topology, nonbondedMethod=PME, 
      nonbondedCutoff=1*nanometer, constraints=constraints, hydrogenMass=hydrogenMass)


# Langevin Middle Integrator is more accurate for larger timesteps
# 4fs ok, but need to keep constraints on HBonds (I think)
# 5fs works, but need heavy hydrogens (mass redistribution from heavy atoms)
integrator = LangevinMiddleIntegrator(300*kelvin, 1/picosecond, dt)
integrator.setRandomNumberSeed(RAND)

platform = Platform.getPlatformByName('CUDA')
properties = {'DeviceIndex': '%s' % GPU_DEVICE} # implicit solvent doesn't support more than 1 GPU
print('properties', properties)
simulation = Simulation(pdb.topology, system, integrator, platform, properties)
simulation.context.setPositions(pdb.positions)
print('psb.positons', len(pdb.positions))

simulation.loadState('parent.xml')
simulation.reporters.append(StateDataReporter('seg.log', 5000, step=True, potentialEnergy=True, kineticEnergy=True, temperature=True, speed=True)) 
simulation.reporters.append(DCDReporter('seg.dcd', 5000))
simulation.reporters.append(StateDataReporter(stdout, 5000, step=True,
        potentialEnergy=True, temperature=True, speed=True))
simulation.step(25000)
simulation.saveState('seg.xml')

end = time.time()
print('elapsed seconds:', end - start)

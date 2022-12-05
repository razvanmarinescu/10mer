#!/bin/bash

# Make sure environment is set
source env.sh

# Clean up
rm -f west.log
cp west_mab.cfg west.cfg

# Run w_run
w_run --work-manager processes "$@"
#w_run --work-manager serial "$@" # check on wiki for serial managers, etc .. 

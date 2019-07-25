#!/bin/bash
#$ -cwd
# error = Merged with joblog
#$ -o joblog.$JOB_ID
#$ -j y
#$ -l h_rt=0:30:00,h_data=2G
#$ -pe shared 2
# Email address to notify
#$ -M $USER@mail
# Notify when
#$ -m a

# load the job environment:
. /u/local/Modules/default/init/modules.sh
module load julia/1.0.1
module load R/3.5.1

# run julia code
julia -e 'using Distributions; d, n, reps, s = TDist(1), 500, 100, 123; include("runSim.jl")' > output.$JOB_ID 2>&1

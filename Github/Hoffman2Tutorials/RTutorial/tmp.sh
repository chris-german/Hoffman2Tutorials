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
module load R/3.5.1

# run julia code
R -e "n = 500; d = 'rt(n, 1)'; reps = 100; s = 123; oFile = 'n_500d_rt(n, 1).txt'; source('runSim.R')" > output.$JOB_ID 2>&1
#!/bin/bash #sets bash up
#$ -cwd #uses current working directory
# error = Merged with joblog
#$ -o joblog.$JOB_ID #creates a file called joblog.jobidnumber to write to. 
#$ -j y 
#$ -l h_rt=0:30:00,h_data=2G #requests 30 minutes, 2GB of data (per core)
#$ -pe shared 2 #requests 2 cores
# Email address to notify
#$ -M $USER@mail #don't change this line, finds your email in the system 
# Notify when
#$ -m bea #sends you an email (b) when the job begins (e) when job ends (a) when job is aborted (error)

# load the job environment:
. /u/local/Modules/default/init/modules.sh
module load julia/1.1.0 #loads julia/1.1.0 for use 

# run julia code
echo 'Running runSim.jl for n = 500' #prints this quote to joblog.jobidnumber
julia -e 'using Distributions; n = 100; d = Normal(); reps = 100; s = 123; include("runSim.jl")' > output.$JOB_ID 2>&1 #runs julia code in quotes and outputs any text to output.JOB_ID

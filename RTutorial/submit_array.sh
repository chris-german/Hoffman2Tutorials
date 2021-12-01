#!/bin/bash
#$ -cwd #uses current working directory
# error = Merged with joblog
#$ -o joblog.$JOB_ID.$TASK_ID #creates a file called joblog.jobidnumber.taskidnumber to write to. 
#$ -j y 
#$ -l h_rt=0:30:00,h_data=2G #requests 30 minutes, 2GB of data (per core)
#$ -pe shared 2 #requests 2 cores
# Email address to notify
#$ -M $USER@mail #don't change this line, finds your email in the system 
# Notify when
#$ -m bea #sends you an email (b) when the job begins (e) when job ends (a) when job is aborted (error)
#$ -t 100-500:100 # 100 to 500, with step size of 100

# load the job environment:
. /u/local/Modules/default/init/modules.sh
module load R

echo ${SGE_TASK_ID}
echo $1
# run julia code
echo Running runSim.jl for n = ${SGE_TASK_ID} #prints this quote to joblog.jobidnumber
Rscript runSim.R ${SGE_TASK_ID} 100 123 $1 > output.$JOB_ID.${SGE_TASK_ID} 2>&1

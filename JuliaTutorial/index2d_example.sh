#!/bin/bash
#$ -cwd
# error = Merged with joblog
#$ -o joblog.$JOB_ID.$TASK_ID
#$ -j y
#$ -pe shared 2
#$ -l h_rt=3:00:00,h_data=8G,arch=intel*
# Email address to notify
##$ -M $USER@mail
# Notify when
#$ -m a
#  Job array indexes
#$ -t 1-352:1

## For use on UCLA's Hoffman2 cluster (Job scheduler: Univa Grid Engine)

NCHUNKS=16
CHUNKIDX=$(( (${SGE_TASK_ID} - 1) % ${NCHUNKS} + 1 ))
CHR=$(( (${SGE_TASK_ID} - 1) / ${NCHUNKS} + 1))

PROJECTDIR=... # intentionally omitted
BGENDIR=... # intentionally omitted
FITTED_NULL=... # intentionally omitted
PVALFILE=... # intentionally omitted

. /u/local/Modules/default/init/modules.sh
echo $CHUNKIDX
echo $CHR
echo $PVALFILE
module load julia/1.5.4
/usr/bin/time -o ${PROJECTDIR}/times/t-${SGE_TASK_ID} julia --project=${PROJECTDIR} ${PROJECTDIR}/scoretest.jl ${BGENDIR} ${CHR} ${FITTED_NULL} ${PVALFILE} ${CHUNKIDX} ${NCHUNKS}

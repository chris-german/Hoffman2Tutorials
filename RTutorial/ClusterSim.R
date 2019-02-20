#File runs 100 replicates of finding the mean average and estimated mean prime
#using seed 123 and sample sizes 100, 200, 300, 400, and 500 for distributioned
#Normal(0, 1), t(5), t(1) on the Hoffman2 cluster. 

reps = 100 # number of simulation replicates
s = 123 # seed
nVals <- seq(100, 500, by=100)
dists <- c("rnorm(n)", "rt(n, 5)", "rt(n, 1)")
for (n in nVals){
  for (d in dists){
    #display job info
    cat("submit job for n=", n, "d=", d, "\n")
    #create outfile name
    oFile <- paste("n_", n, "d_", d, ".txt", sep="")
    #create rcode to run
    rcode = paste0("n = ", n, "; d = '", d, "'; reps = ", reps, "; s = ", s,
                   "; oFile = '", oFile, "'; source('runSim.R')")
    
    # prepare sh file for qsub
    tp <- file("tmp.sh", "w")
    writeLines(con = tp, "#!/bin/bash")
    writeLines(con = tp, "#$ -cwd")
    writeLines(con = tp, "# error = Merged with joblog")
    writeLines(con = tp, "#$ -o joblog.$JOB_ID")
    writeLines(con = tp, "#$ -j y")
    writeLines(con = tp, "#$ -l h_rt=0:30:00,h_data=2G") # request runtime and memory
    writeLines(con = tp, "#$ -pe shared 2") # request # shared-memory nodes
    writeLines(con = tp, "# Email address to notify")
    writeLines(con = tp, "#$ -M $USER@mail")
    writeLines(con = tp, "# Notify when")
    writeLines(con = tp, "#$ -m a")
    writeLines(con = tp, "")
    writeLines(con = tp, "# load the job environment:")
    writeLines(con = tp, ". /u/local/Modules/default/init/modules.sh")
    writeLines(con = tp, "module load R/3.5.1")
    writeLines(con = tp, "")
    writeLines(con = tp, "# run julia code")
    cat(file = tp, "R -e \"", rcode, "\" > output.$JOB_ID 2>&1", sep = "")
    close(tp)
    sysCall <- paste("qsub tmp.sh")
    system(sysCall)
  }
}






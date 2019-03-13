reps = 100 # number of simulatin replicates
s = 123 # seed
for n in 100:100:500
    for d in ["Normal()", "TDist(5)", "TDist(1)"]
        println("submit job for n=$n, d=$d")
        jcode = "using Distributions; d, n, reps, s = $d, $n, $reps, $s; include(\"runSim.jl\")"
        # prepare sh file for qsub
        open("tmp.sh", "w") do io
            println(io, "#!/bin/bash")
            println(io, "#\$ -cwd")
            println(io, "# error = Merged with joblog")
            println(io, "#\$ -o joblog.\$JOB_ID")
            println(io, "#\$ -j y")
            println(io, "#\$ -l h_rt=0:30:00,h_data=2G") # request runtime and memory
            println(io, "#\$ -pe shared 2") # request # shared-memory nodes
            println(io, "# Email address to notify")
            println(io, "#\$ -M \$USER@mail")
            println(io, "# Notify when")
            println(io, "#\$ -m a")
            println(io)
            println(io, "# load the job environment:")
            println(io, ". /u/local/Modules/default/init/modules.sh")
            println(io, "module load julia/1.0.1")
            println(io, "module load R/3.5.1")
            println(io)
            println(io, "# run julia code")
            println(io, "julia -e '$jcode' > output.\$JOB_ID 2>&1")
        end
        # submit job
        run(`qsub tmp.sh`)
    end
end

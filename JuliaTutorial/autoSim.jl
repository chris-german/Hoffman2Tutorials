reps = 100
s = 123
for n in 100:100:500
    for d in ["Normal()", "TDist(5)", "TDist(1)"]
        println("simulation for n=$n, d=$d")
        jcode = "using Distributions; d, n, reps, s = $d, $n, $reps, $s; include(\"runSim.jl\")"
        run(`julia -e $jcode`)
    end
end

using DelimitedFiles, Distributions, Primes, Random, Statistics
using Distributions
n = parse(Int, ARGS[1])
reps = parse(Int, ARGS[2])
seed = parse(Int, ARGS[3])
if length(ARGS) < 4
    d = Normal()
else
    d = eval(Meta.parse(ARGS[4]))
end

"""
    est_mean_prime(x)

Estimate mean by averaging prime-indexed data in `x`.
"""
function est_mean_prime(x::Vector{<:Real})
    s, c = zero(eltype(x)), 0
    for i in eachindex(x)
        if Primes.isprime(i)
            s += x[i]
            c += 1
        end
    end
    s / c
end

"""
    est_mean_avg(x)

Estimate mean by sample average.
"""
function est_mean_avg(x::Vector{<:Real})
    mean(x)
end

function compare_methods(n::Int, d::ContinuousUnivariateDistribution)
    x = rand(d, n)
    est_mean_avg(x), est_mean_prime(x)
end

# Simulate `reps` replicates of sample size `n` from distribution `d` using seed `s`
simres = zeros(reps, 2)
Random.seed!(seed)
for r in 1:reps
    x = rand(d, n)
    simres[r, 1] = est_mean_avg(x)
    simres[r, 2] = est_mean_prime(x)
end

outfile = "simresults/n_$(n)_reps_$(reps)_dist_$(d).txt"
DelimitedFiles.writedlm(outfile, simres, ",")
# may add an optional zip step here to reduce storage

## check if a given integer is prime
isPrime = function(n) {
  if (n <= 3) {
    return (TRUE)
  }
  if (any((n %% 2:floor(sqrt(n))) == 0)) {
    return (FALSE)
  }
  return (TRUE)
}

## estimate mean only using observation with prime indices
estMeanPrimes = function (x) {
  n = length(x)
  ind = sapply(1:n, isPrime)
  return (mean(x[ind]))
}

# Simulate `reps` replicates of sample size `n` from distribution `d` using seed `s`
simres = data.frame(est_mean_avg = double(reps), est_mean_prime = double(reps))
set.seed(s)
for (r in 1:reps){
  x = eval(parse(text = d))
  simres[r, 1] = mean(x)
  simres[r, 2] = estMeanPrimes(x)
}

write.csv(simres, file = oFile, row.names = F)




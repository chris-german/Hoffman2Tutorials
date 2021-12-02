qsub submit_array.sh # defaults to rnorm(n)
qsub submit_array.sh "rnorm(n)"
qsub submit_array.sh "rt(n,5)"
qsub submit_array.sh "rt(n,1)"

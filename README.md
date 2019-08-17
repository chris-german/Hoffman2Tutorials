# Hoffman2 Tutorials

This is a guide for using UCLA IDRE's Hoffman2 cluster computing system. There are guides for running jobs specific to [R](https://github.com/chris-german/Hoffman2Tutorials/tree/master/RTutorial) and [Julia](https://github.com/chris-german/Hoffman2Tutorials/tree/master/JuliaTutorial), as well as general guides for commands and what is available for users. 

## What is it?

A computer cluster is a set of connected computers (nodes) that work together under one system. Each node will have its own instance of an operating system and hardware. Clusters are used for high-performace distributed computing tasks. They are ideal for multilevel simulations and large-scale computations.

The Hoffman2 Cluster is a group of computing nodes that consists of over 1,200 64-bit nodes and 13,340 cores. It has an aggergate of over 50TB of memory. It consists of login nodes and compute nodes. Login nodes are where you can organize data (install packages, arrange data) and submit jobs and compute nodes are where computer-intensive tasks are run.

![cluster computing](JuliaTutorial/pngs/cluster.png)

# Account Creation
The first step you need to take is to create an account.

Register for an account at: https://www.hoffman2.idre.ucla.edu/getting-started/#newuser

Once you register and your account gets approved, you’ll get an email with a link to see your temporary password that must be used within 4 weeks.

# Logging in 

To login, go to terminal linux/unix and type:

```
ssh username@hoffman2.idre.ucla.edu 

```

<img src="JuliaTutorial/pngs/Hoffman2login.png" width="500">




and enter your password when prompted (Can also setup ssh keys so no password is required) https://www.hoffman2.idre.ucla.edu/access/passwordless_ssh/.

# Basic Commands
To use Hoffman2, you have to use linux/unix commands to navigate. See Dr. Zhou's linux slides for more details.

Some useful commands:

  * make a directory: `mkdir dirname `  
  * go to home directory: `cd`  
  * go to a certain directory: `cd /path/ `  
  * see current directory: `pwd`  
  * remove a file: `rm filename`  
  * remove a directory: `rm -r dirname`  
  * see whats in current directory: `ls`  
  * see whats in current directory (including hidden items): `ls -a`  
  * see size of current directory: `du -h`  
  * transfer files between cluster/local computer via ssh: `scp` (more on this later) 
  * to go to directory containing the current directory: `cd ..`
  

# Available Software

Current software that you can use on Hoffman2 can be found using:
```
module avail

```



<img src="JuliaTutorial/pngs/Moduleavail.png" width="500">

 
(More than the ones shown are available... it's a very long list).

To see available modules that begin with a specific phrase, such as those that start with j type:

``` 
module avail j
```

<img src="JuliaTutorial/pngs/modavailj.png" width="500">

# Loading Software
To load a module, say `julia` version 1.1.0, for use type:
```
module load julia/1.1.0
```

If you are going to need packages installed for your use on Hoffman2, load julia using `julia` and then install the packges. Note: This should be done on a compute node as compiling julia and libraries can take quite a bit of resources. Therefore, you should use `qrsh`, discussed later to do this. Computing power is limited on login nodes so you should not run any analyses on the login node.

# Accessing a compute node

## qsub

For most analyses/jobs you'd like to run on Hoffman2, you should use the `qsub` command. This submits a batch job to the queue (scheduler). The type of file you `qsub` has to have a specific format (shell script).



```
;cat submit.sh

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
    julia -e "n = 500;  include('runSim.jl')" > output.$JOB_ID 2>&1 #runs julia code in quotes and outputs any text to output.JOB_ID
```


To send this script to the scheduler to run on a compute node, you would simply type:

```
qsub submit.sh
```

## qrsh

For some analyses, you may want to do things interactively instead of just submitting jobs. The `qrsh` command is for loading you onto an interactive compute node. 

Typing `qrsh` on the Hoffman2 login node will submit q request for an interactive session. By default, the session will run for two hours and the physical memory alotted will be 1GB.

To request more, you can use the commmand
```
qrsh -l h_rt=4:00:00,h_data=4G
```

This will request a four hour session where the maximum physical memory is 4GB. 

If you'd like to use more than one CPU core for your job, add `-pe shared #` to the end. Note, the amount of memory requested will be for each core. For example, if you'd like to request 4 CPU cores, each with 2GB of memory for a total of 8GB for 5 hours, run:
```
qrsh -l h_rt=5:00:00,h_data=2G -pe shared 4
```

The more time and memory you request, the longer you will have to wait for an interactive compute node to become available to you. It's normal to wait a few minutes to get an interactive session. 

For more advanced options you can use
                                        
```
   qrsh -help                                     
```

## Resource limitations
The maximum time for a session is 24 hours unless you're working in a group that owns their compute nodes. So do not have an `h_rt` value greated than `h_rt=24:00:00`.

Different compute nodes have different amounts of memory. There are fewer nodes with lots of memory, so the larger the amount of memory you're requesting the longer you will have to wait for the job to start running. If you request too much, the job may never run. 

Requesting more than 4 cores for an interactive session can possibly take a long time for the interactive session to start. 


# Biostatistics Specific Nodes
If you are a biostatistics student, there are compute nodes that the biostatistics department has which will allow you to run jobs longer than 24 hours (up to 14 days). These nodes give group users priority to use them, so a job is guaranteed to run within 24 hours of the job submission on these nodes unless they're all being used by other biostatistics group members. To get membership for these nodes, you will need to select Dr. Banerjee or Dr. Zhou as faculty sponsor. 

The biostatistics nodes are under Dr. Sudipto Banerjee, and the group name is `@sudipto_pod`. To view the list of biostatistics nodes you can run the command:

```
qconf -shgrp @sudipto_pod

group_name @sudipto_pod
hostlist n6277 n7277 n6278 n7278 n6285 n7285
```

To see what types of nodes there are (how many cores and how much memory each node has) you can run:

```
qhost -h n6277 n7277 n6278 n7278 n6285 n7285

HOSTNAME                ARCH         NCPU NSOC NCOR NTHR NLOAD  MEMTOT  MEMUSE  SWAPTO  SWAPUS
----------------------------------------------------------------------------------------------
global                  -               -    -    -    -     -       -       -       -       -
n6277                   intel-X5650    12    2   12   12  1.00   47.3G   17.9G   15.3G   94.8M
n6278                   intel-X5650    12    2   12   12  0.92   47.3G   15.3G   15.3G   60.2M
n6285                   intel-X5650    12    2   12   12  0.99   47.3G    3.4G   15.3G   55.9M
n7277                   intel-X5650    12    2   12   12  1.00   47.3G   13.6G   15.3G   53.4M
n7278                   intel-X5650    12    2   12   12  1.00   47.3G    8.0G   15.3G   53.9M
n7285                   intel-X5650    12    2   12   12  1.00   47.3G   17.5G   15.3G   64.1M
```

This shows that the biostatistics group has six nodes, each with 12 cores and 48GB of memeory (an average of 4GB/core).

## Requesting group nodes
To request these nodes specifically, include `-l highp` when requesting the job.

For example, the line in your `.sh` file should look like:
```
-l h_data=1G,h_rt=48:00:00,highp
```

To alter (without re-submitting it) a already-pending job from non-highp to highp, use following steps:

1. Get the “hard resource” parameter list:
`qstat -j job_id | grep ^'hard resource_list'`


For example, you have hard resource_list: `h_data=1024M,h_rt=259200`
You will use the list beyond the colon (“:”) in the “hard resource_list” output above in the next step.

2. Add the highp option to the hard resource_list using the qaltercommand:
`qalter -l h_data=1024M,h_rt=259200,highp job_id`


where job_id is replaced by the actual job ID (number). For more information about qalter, try the command: `man qalter`

Guides for submitting [R jobs](https://github.com/chris-german/Hoffman2Tutorials/tree/master/RTutorial) and [Julia jobs](https://github.com/chris-german/Hoffman2Tutorials/tree/master/JuliaTutorial), including code for simulations are also available in this github repo.
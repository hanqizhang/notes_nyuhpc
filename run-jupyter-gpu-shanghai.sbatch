#!/bin/bash

#SBATCH --job-name=gpu-jupyter
#SBATCH -N 1
#SBATCH -c 2
#SBATCH -M pudong
#SBATCH -p gpu
#SBATCH -t 23:59:59
#SBATCH --mem-per-cpu=20GB
#SBATCH --gres=gpu:1

module purge
unset XDG_RUNTIME_DIR;
source ~/dev/bin/activate
jupyter notebook --no-browser --ip=0.0.0.0 --port 8777 --notebook-dir=~/foldername

## -N nodes
## -n ntasks
## -c cpus-per-task
## -t time

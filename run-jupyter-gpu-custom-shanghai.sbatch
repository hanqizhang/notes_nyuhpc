#!/bin/bash

#SBATCH --job-name=gpu-jupyter
#SBATCH -N 1
#SBATCH -c 2
#SBATCH -M pudong
#SBATCH -p gpu
#SBATCH -t 0:59:59
#SBATCH --mem-per-cpu=20GB
#SBATCH --gres=gpu:1
#SBATCH --mail-type=ALL # select which email types will be sent
#SBATCH --mail-user=NETID@nyu.edu # NOTE: put your netid here if you want emails

sleep $(( (RANDOM%10) + 1 )) 

echo "SLURM_JOBID: " $SLURM_JOBID
echo "SLURM_ARRAY_JOB_ID: " $SLURM_ARRAY_JOB_ID
echo "SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID

source /scratch/<net-id>/env.sh # if you use your custom installed miniconda
conda init
conda activate /scratch/<net-id>/<environmentname>
jupyter notebook --no-browser --ip=0.0.0.0 --port 8777 --notebook-dir=$(pwd)

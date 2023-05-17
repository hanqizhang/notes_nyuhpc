#!/bin/bash

#SBATCH --job-name=gpu-jupyter
#SBATCH -N 1
#SBATCH -c 2
#SBATCH -M pudong
#SBATCH -p gpu # comment out this line if not using gpu
#SBATCH -t 0:59:59
#SBATCH --mem-per-cpu=20GB
#SBATCH --gres=gpu:1 # comment out this line if not using gpu
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<net-id>@nyu.edu

sleep $(( (RANDOM%10) + 1 )) # as suggested by watchernyu, to avoid issues when submitting large amounts of jobs

echo "SLURM_JOBID: " $SLURM_JOBID
echo "SLURM_ARRAY_JOB_ID: " $SLURM_ARRAY_JOB_ID
echo "SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID

module load anaconda
conda init bash
source ~/.bashrc
conda activate /gpfsnyu/scratch/<net-id>/<environmentname>
jupyter notebook --no-browser --ip=0.0.0.0 --port 8777 --notebook-dir=~

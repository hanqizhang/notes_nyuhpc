#!/bin/bash

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

sleep $(( (RANDOM%10) + 1 )) # as suggested by watchernyu, to avoid issues when submitting large number of jobs

echo "SLURM_JOBID: " $SLURM_JOBID
echo "SLURM_ARRAY_JOB_ID: " $SLURM_ARRAY_JOB_ID
echo "SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID

module purge
source /scratch/<net-id>/env.sh # can also incorporate the script in env.sh in ~/.bashrc and source it instead
conda init
conda activate <environmentname>
unset XDG_RUNTIME_DIR;
jupyter notebook --no-browser --ip=0.0.0.0 --port 8777 --notebook-dir=$(pwd)

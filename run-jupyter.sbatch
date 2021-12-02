#!/bin/bash

#SBATCH --job-name=jupyter
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=32GB
#SBATCH --cpus-per-task=2
#SBATCH --time=2:00:00
#SBATCH --gres=gpu:1

module purge

# here I use port 8766, which in Doruk Kilitcioglu's tutorial is 8888. You can pick anything
# from 6000-9999.
singularity exec --nv \
            --overlay /scratch/<net-id>/pytorch-example/my-pytorch.ext3 \
            /scratch/work/public/singularity/cuda11.2.2-cudnn8-devel-ubuntu20.04.sif \
            /bin/bash -c "source /ext3/env.sh; 
            conda activate base; 
            /usr/bin/ssh -N -f -R 8766:localhost:8766 log-1;
            unset XDG_RUNTIME_DIR;
            jupyter notebook --no-browser --port 8766 --notebook-dir=$(pwd)"

Notes, references, and example files for setting up the NYU Greene HPC and NYU Shanghai HPC

# notes_nyugreene
Notes for setting up the NYU Greene HPC

## singularity and miniconda
The first thing to do to get started on Greene is to set up a [singularity](https://en.wikipedia.org/wiki/Singularity_(software)) container. Then you are free to install stuff in your conda environment. For guide on setting up singularity and conda, follow NYU HPC's official guide:  
https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/greene/software/singularity-with-miniconda  

Two potential points of confusion:
1. When creating ext3/env.sh, you can do this while in the singualrity container, no need to exit.
2. When installing torch, make sure to install the version corresponding to the singularity image you use. Follow instructions on the [pytorch website](https://pytorch.org) and to be consistent with the instructions on the Greene HPC guide, choose pip as your package manager.

## notes for running jupyter notebook on greene with ssh port forwarding, in the context of singularity container
For the most part, we can follow the tutorial in this link:  
https://dorukkilitcioglu.com/2018/11/18/nyu-hpc-data-science.html  
The instructions were based on the old Prince cluster, but are still valid for Greene,
except for the content in the sbatch file. This is because Singularity is adopted for
Greene, so we have to run Jupyter in a Singularity container.

For an example sbatch file, please see my run-jupyter.sbatch in this repo.

Your slurm-\<job id\>.out will output something like the following:  
```
[I 22:10:48.082 NotebookApp] Serving notebooks from local directory: /home/<net-id>/... 
[I 22:10:48.083 NotebookApp] Jupyter Notebook 6.4.6 is running at:  
[I 22:10:48.083 NotebookApp] http://localhost:8766/  
[I 22:10:48.083 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).  
```

Note that I don't have to input jupyter notebook token here. It is also okay to use a token, but I feel it's worth it to set up a password like [so](https://jupyter-notebook.readthedocs.io/en/stable/public_server.html).


# notes_nyushanghai hpc
Notes for setting up NYU Shanghai HPC

NYU Shanghai HPCs do not use singularity at the moment, so we can simply set up our virtual environment or conda environment once we log in.

You can use the anaconda module provided in the system or install your own miniconda under ```/scratch/<net-id>/```
```
cd /scratch/<net-id>/
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p miniconda3
```
If you don't need the installation file any longer:
```
rm Miniconda3-latest-Linux-x86_64.sh
```
Create conda environment:
```
conda create -n environmentname python=3.9
```
(if later for some reason you want to remove this environment: ```conda env remove -n environmentname```)

Next, create a wrapper script /scratch/\<net-id\>/env.sh
The wrapper script will activate your conda environment, to which you will be installing your packages and dependencies. The script should contain the following:
```
#!/bin/bash
source /scratch/<net-id>/miniconda3/etc/profile.d/conda.sh
export PATH=/scratch/<net-id>/miniconda3/bin:$PATH
export PYTHONPATH=/scratch/<net-id>/miniconda3/bin:$PATH
```
Activate your conda environment with the following:
```
source /scratch/<net-id>/env.sh
conda activate environmentname
```
Install packages:
```
conda install pip -y
conda install ipykernel -y
conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia # refer to pytorch website
conda install jupyter jupyterhub pandas matplotlib scipy scikit-learn scikit-image Pillow
```
Now you can submit a GPU job if you are eligible to access GPU nodes on the pudong cluster. If not, CPUs on the cluster are always available. Just delete the line ```#SBATCH --gres=gpu:1``` in the sbatch file.

## gpu jobs on nyu shanghai hpc
An example sbatch file is shared in the repo.

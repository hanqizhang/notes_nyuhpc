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

---

# notes_nyushanghai hpc
Notes for setting up NYU Shanghai HPC

NYU Shanghai HPCs do not use singularity at the moment, so we can simply set up our virtual environment or conda environment once we log in.

You can use the anaconda module provided in the system or install your own miniconda under ```/scratch/<net-id>/```

## using the anaconda module by default (recommended)
```
module load anaconda
```
Create conda environment, preferably directly under the scratch folder:
```
conda create --prefix /scratch/<net-id>/environmentname python=3.9
```
Activate your conda environment with the following:
```
conda init bash
conda activate /scratch/<net-id>/environmentname
```
Install packages:
```
conda install pip -y
conda install ipykernel -y
conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia # refer to pytorch website
conda install jupyter jupyterhub pandas matplotlib scipy scikit-learn scikit-image Pillow
...
```

## installing and using your own miniconda
```
cd /scratch/<net-id>/
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p miniconda3
```
If you don't need the installation file any longer:
```
rm Miniconda3-latest-Linux-x86_64.sh
```
Create conda environment, preferably directly under the scratch folder:
```
conda create --prefix /scratch/<net-id>/environmentname python=3.9
```
(if later for some reason you want to remove this environment: ```conda env remove -n environmentname```)

Next, create a wrapper script /scratch/\<net-id\>/env.sh
The wrapper script will activate your conda environment, to which you will be installing your packages and dependencies. (see [advantages of using a wrapper script](https://ncgas.org/training/installing-conda-packages.html) than ```conda init```.) The script should contain the following:
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
...
```
Now you can submit a GPU job if you are eligible to access GPU nodes on the pudong cluster. If not, CPUs on the cluster are always available. Just delete the lines ```#SBATCH --gres=gpu:1``` and ```#SBATCH -p gpu``` in the sbatch file.

## gpu jobs on nyu shanghai hpc
Currently only the ```pudong``` cluster has GPU nodes. So make sure to specify the cluster ```#SBATCH -M pudong``` if you are running a GPU job. For CPU jobs either leave the cluster unspecified or choose pudong or nyushc as preferred.

An example sbatch file is shared in the repo. Note that when using a GPU node, ```module: command not found``` error might come up. In that case define the module command using what is provided in the example sbatch file.

use ```squeue -u <net-id>``` to check jobs that are currently running for the user. An inconvenience is that jobs on a cluster are only visible through that cluster's log-in node: ```<net-id>@hpclogin.shanghai.nyu.edu``` for nyushc and ```<net-id>@hpc.shanghai.nyu.edu``` for pudong.

---

## notes for running jupyter notebook on nyu shanghai hpc with ssh port forwarding

First, submit job specifying to run jupyter notebook and what ip address and port to use for port forwarding on the remote server. (see example sbatch file in this repo)

Second, find out the ```remoteip``` assigned to you by the cluster. You can run ```squeue -u <net-id>``` on the cluster and find it listed under 'NODELIST', for example, it could be ```compute 118``` or ```gpu6```.

Third, open up another terminal window on your local computer and ssh into the cluster with the command:
```
sshpass -f ~/<your_password_file>.pwd ssh -L <localport>:<remoteip>:<remoteport> <net-id>@<login_node>.shanghai.nyu.edu
```

Decide yourself what local port to use. It could be 8888 or any number around that value, as long as it is not already occupied on your local machine.

Then simply open your browser locally and type in the address: ```http://localhost:<localport>```. Then you can use jupyter notebook in the same way as you'd use it locally.

---

(Disclaimer: notes here are not official. Please refer to the official guides if available. Ask IT Services for help if these notes fail in your situation.)

# notes_nyugreene
Notes and useful references for setting up the NYU Greene HPC

## notes for forwarding Jupyter notebook in the context of Singularity container
For the most part, we can follow the tutorial in this link:
https://dorukkilitcioglu.com/2018/11/18/nyu-hpc-data-science.html
The instructions were based on the old Prince cluster, but are still valid for Greene,
except for the content in the sbatch file. This is because Singularity is adopted for
Greene, so we have to run Jupyter in a Singularity container.

For an example sbatch file, please see my run-jupyter.sbatch in this repo.

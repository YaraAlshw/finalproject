#!/bin/bash
#SBATCH --job-name=ipyrad_param_toaddata
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --time 7-00:00:00
#SBATCH --mem-per-cpu=2G
#SBATCH --mail-type=ALL
#SBATCH --mail-user=<yara.alshwairikh@yale.edu>

module load miniconda
conda activate ipyrad

## call ipyrad on your params file
ipyrad -p params-toaddata.txt -s 1234567 -c 32

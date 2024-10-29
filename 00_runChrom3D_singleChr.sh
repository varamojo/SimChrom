#!/bin/sh

# Slurm Parameters
#SBATCH -p fat --qos 7d
#SBATCH -c 8
#SBATCH --job-name=chr3d.fat
#SBATCH --output=chr3d.fat.%A_%a.out
#SBATCH --error=chr3d.fat.%A_%a.err
#SBATCH --time=7-00:00:00
#SBATCH -C scratch
#SBATCH --mem 90
#SBATCH --array=0-22

#make Chrom3D executable
export PATH=$PATH:/your_path_to_Chrom3D/Software/Chrom3D-1.0.2

################################################################
##Commands
###############################################################

#Set parameters
chrom=(chr1 chr2 chr3 chrX)                                           #set the chromosomes 
#Set array for the different chromosomes (optional)
ch=${chrom[${SLURM_ARRAY_TASK_ID}]}

gtrack_InDir="home/path_to_gtrack/"                                   #input directory containing the .gtrack from the preproccesing
gtrack_File="D0_bead_interactions.lads.diploid.rep.${ch}.gtrack"      #input file name (.gtrack) that results from the preproccesing
repp="100000"                                                         #number of iterations
cmm_OutDir="home/path_to_cmm/"                                        #output directory to the Chrom3D output (.cmm file)
cmm_File="3M_model_ladatlas.${ch}.cmm"                                #output file name (.cmm)


#Create output dir
mkdir -p ${cmm_OutDir}/${ch}

#######################################
###Call Chrom3D for single chromosomes
#######################################

Chrom3D -o ${cmm_OutDir}/${ch}/${cmm_File} -n ${repp} -r 5.0 --nucleus -y 0.01 -l 1000 -c 0.001 ${gtrack_InDir}/${gtrack_File}


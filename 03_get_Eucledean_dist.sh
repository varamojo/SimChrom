#!/bin/bash

# Slurm Parameters
#SBATCH -p fat
#SBATCH --job-name=dist
#SBATCH --output=dist.%A_%a.out
#SBATCH --error=dist.%A_%a.err
#SBATCH --mem=10gb
#SBATCH --time=20:00:00
#SBATCH --array=0-22
#SBATCH -C scratch

chromosomes=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X)
ch=${chromosomes[${SLURM_ARRAY_TASK_ID}]}

ALLEL=(A B)
for allel in ${ALLEL};do

#Set parameters
cmm_Dir="home/path_to_cmm"                                                        #output directory to the Chrom3D output (.cmm file)
cmm_File="3M_model_ladatlas.CTCF.chr${ch}_${allel}"                               #output file name with CTCF highlight (.cmm) , dont include .cmm while we need to use other formats with the same name as well
violin_dir="path/to/violin_plot/destination"

#Get x,y,z coordinates
grep chrID ${cmm_Dir}/${cmm_File}.cmm | awk '{print $2,$3,$4,$5}'| sed 's/"//g'| sed 's/=/\t/g'| awk '{print $2+1,$4,$6,$8}'| sed 's/ /\t/g' > ${violin_dir}/${cmm_File}.txt

#Calculate distances
Rscript 03_get_Eucledean_dists.R ${violin_dir} ${cmm_File}.txt EucDist_2.0_${ch}_${allel}.txt

#Get IDs for beads with and without CTCF based on the color of the bead
grep ID ${cmm_Dir}/${cmm_File}.cmm| grep chr${i}_${allel} | grep -v  0.411764705882| awk '{print $2}'| sed 's/=/ /g' |  awk '{print $2}' |  sed 's/"//g' |  awk '{print $1+1}' > ${violin_dir}/CTCF_lads_all_beads_chr${i}_${allel}
grep ID ${cmm_Dir}/${cmm_File}.cmm| grep chr${i}_${allel} | grep 0.411764705882| awk '{print $2}'| sed 's/=/ /g' |  awk '{print $2}' |  sed 's/"//g' |  awk '{print $1+1}' > ${violin_dir}/nonCTCF_lads_all_beads_chr${i}_${allel}

#Set parameters for the violin plot creation and the Wilcoxon Test
arg1="${violin_dir}"
arg2="${file}.txt"
arg3="EucDist_2.0_${ch}_${allel}.txt"
arg4="CTCF_lads_all_beads_chr${i}_${allel}"
arg5="nonCTCF_lads_all_beads_chr${i}_${allel}"
arg6="stats_distances_chr${i}_${allel}"
arg7="violin_plot_distances_chr${i}_${allel}"

#Get violin plots and Wilcoxon Test
echo "Get plot for chr${i}_${allel}"
Rscript 03_get_violin_plots_per_chr.R ${arg1} ${arg2} ${arg3} ${arg4} ${arg5} ${arg6} ${arg7}.svg
done


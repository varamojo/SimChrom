#Set parameters
repp="3000000"                                                  #number of iterations
cmm_Dir="home/path_to_cmm"                                      #output directory to the Chrom3D output (.cmm file)
cmm_File="3M_model_ladatlas.cmm"                                #output file name (.cmm)
TAD_dir="home/path_to_TADs"

#Path to processing scripts
script_dir="/path_to/INC-tutorial/processing_scripts/"

#Split chromosome parameters
declare -a chrom=(chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX)
declare -a ALLEL=(A B)

#load bedtools
module load bedtools


#Get CTCF domains
bedtools intersect -a ${TAD_dir}/TAD_domains.bed -b home/path_to_CTCF_peaks/CTCF_top0.01.peaks.w_motifs.show.bed -wa > ./IDs_CTCF/TAD_CTCF_domains.bed

#Make IDs compatible with .cmm
sed 's/\t/_A:/1'  ./IDs_CTCF/TAD_CTCF_domains.bed | sed 's/\t/-/1' > a.tmp
sed 's/\t/_B:/1'  ./IDs_CTCF/TAD_CTCF_domains.bed | sed 's/\t/-/1' > b.tmp
cat a.tmp b.tmp | sort > ./IDs_CTCF/TAD_CTCF_domains.id

#Highlight CTCF domains
python2 ${script_dir}/color_beads.py ${cmm_Dir}/${cmm_File} /IDs_CTCF/TAD_CTCF_domains.id 255,200,0 override > ${cmm_Dir}/3M_model_ladatlas.CTCF.cmm

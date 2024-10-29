#Set parameters
cmm_Dir="home/path_to_cmm"                                      #output directory to the Chrom3D output (.cmm file)
cmm_File="3M_model_ladatlas.CTCF.cmm"                           #output file name (.cmm)

#Split chromosome parameters
declare -a chrom=(chr1 chr2 chr3 chr4 chr5 chr6 chr7 chr8 chr9 chr10 chr11 chr12 chr13 chr14 chr15 chr16 chr17 chr18 chr19 chr20 chr21 chr22 chrX)
declare -a ALLEL=(A B)

#Extract chromosomes from whole genome .cmm file
grep "<marker_set name=" ${cmm_Dir}/3M_model_ladatlas.CTCF.cmm > header
grep "</marker_set>" ${cmm_Dir}/3M_model_ladatlas.CTCF.cmm > tail

for ch in ${chrom[@]};do
echo "${ch}"

for allel in ${ALLEL[@]};do
echo "${allel}"

grep -A 1 "${ch}_${allel}" ${cmm_Dir}/3M_model_ladatlas.CTCF.cmm > main_${allel}.tmp
cat header main_${allel}.tmp tail > ${cmm_Dir}/3M_model_ladatlas.CTCF.${ch}_${allel}.cmm
rm main_${allel}.tmp

done
done



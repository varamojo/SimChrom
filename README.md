This repository provides scripts for simulating chromatin 3D structures and further dowsntream analysis with the .cmm files (Chrom3D output) such as:

  - Calculating the Euclidean distances between intrachromosomal beads
  - Visualisation of the distances as violin plots
  - Tag and track of beads according highlight (e.g CTCF association)
  - Extraction of .cmm file information

These scripts can be used for structural analysis of chromatin, identifying spatial relationships within genomic data, and generating visualizations of chromatin interactions.

Dependeces:

Chrom3D installation: https://github.com/Chrom3D/Chrom3D

Chrom3D preproccesed scripts: https://github.com/Chrom3D/preprocess_scripts

install.packages("svglite")

install.packages("ggpubr")

install.packages("rstatix")

install.packages("ggplot2")





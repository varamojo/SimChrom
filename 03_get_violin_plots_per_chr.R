install.packages("svglite")
install.packages("ggpubr")
install.packages("rstatix")
install.packages("ggplot2")

library(svglite)
library(ggpubr)
library(rstatix)
library(ggplot2)

args <- commandArgs(trailingOnly = TRUE)
setwd(args[1])

xyz<-read.delim(args[2], header=F, sep="\t")
dims<-read.delim(args[3], header=F, sep="\t")
dims[dims >= 10.5] <- NA

as.matrix(dims)->dims

SigBead<-read.delim(args[4], header=F, sep="\t")
cbind(SigBead-1,"CTCF-CTCF")->SigBead
rownames(SigBead)<-(SigBead[,1])
colnames(SigBead)<-c("","")

noSigBead<-read.delim(args[5], header=F, sep="\t")
cbind(noSigBead-1,"nonCTCF-nonCTCF")->noSigBead
rownames(noSigBead)<-(noSigBead[,1])
colnames(noSigBead)<-c("","")


all<-rbind(noSigBead,SigBead)
all[order(as.numeric(row.names(all))), ]->alla
cbind(alla,seq(1,nrow(alla),1))->alla
rownames(alla)<-seq(1,nrow(alla),1)

which(alla[,2]=="nonCTCF-nonCTCF")->noSigBead_sample
which(alla[,2]=="CTCF-CTCF")->SigBead_sample

# Find the distances between CTCF beads
ctcf_to_ctcf<-vector(length=10)
ct<-1
for (i in 1:length(SigBead_sample)){
  for (e in 1:length(SigBead_sample)){
  ctcf_to_ctcf[[ct]]<-dims[SigBead_sample[i],SigBead_sample[e]]
  ct<-ct+1
  ctcf_to_ctcf[[ct]]<-dims[SigBead_sample[e],SigBead_sample[i]]
  ct<-ct+1
  }
}

# Find the distances between CTCF beads to nonCTCF beads
ctcf_to_non<-vector(length=10)
ct<-1
for (i in 1:length(SigBead_sample)){
  for (e in 1:length(noSigBead_sample)){
  ctcf_to_non[[ct]]<-dims[SigBead_sample[i],non_sample[e]]
  ct<-ct+1
  ctcf_to_non[[ct]]<-dims[non_sample[e],SigBead_sample[i]]
  ct<-ct+1
  }
}



# Find the distances between nonCTCF beads to CTCF beads
non_to_ctcf<-vector(length=10)
ct<-1
for (i in 1:length(noSigBead_sample)){
   for (e in 1:length(noSigBead_sample)){
   non_to_ctcf[[ct]]<-dims[noSigBead_sample[i],noSigBead_sample[e]]
   ct<-ct+1
   non_to_ctcf[[ct]]<-dims[noSigBead_sample[e],noSigBead_sample[i]]
   ct<-ct+1
   }
}

#work withthe whole sample
ctcf_to_ctcf[which(ctcf_to_ctcf>0)]->ctcf_to_ctcf
ctcf_to_non[which(ctcf_to_non>0)]->ctcf_to_non
non_to_ctcf[which(non_to_ctcf>0)]->non_to_ctcf

ctcf_to_ctcf_matrix<-cbind.data.frame(ctcf_to_ctcf,"ctcf_to_ctcf", "all")
ctcf_to_non_matrix<-cbind.data.frame(ctcf_to_non,"ctcf_to_non", "all")
non_to_ctcf_matrix<-cbind.data.frame(non_to_ctcf,"non_to_ctcf", "all")

colnames(ctcf_to_ctcf_matrix)<-c("distance","bead_type","all");colnames(non_to_ctcf_matrix)<-c("distance","bead_type","all");colnames(ctcf_to_non_matrix)<-c("distance","bead_type","all")

##significant tests

wilcox.test(ctcf_to_ctcf,ctcf_to_non)
wilcox.test(ctcf_to_ctcf,non_to_ctcf)
wilcox.test(ctcf_to_non,non_to_ctcf)

R<-rbind(ctcf_to_non_matrix, non_to_ctcf_matrix, ctcf_to_ctcf_matrix)
head(R)
R$bead_type <- factor(R$bead_type, levels = c("CTCF_to_CTCF","NON_to_CTCF","CTCF_to_NON"))
write.table(R, args[6], sep="\t", row.names=F, col.names=F, quote=F)

print("Perform stats")
res.stat <- R %>% group_by(all) %>% wilcox_test(distance ~ bead_type) %>% adjust_pvalue(method = "bonferroni") %>% add_significance("p.adj")

res.stat
res.stat <- res.stat %>% add_xy_position(x = 'bead_type')
res.stat <- res.stat %>% add_y_position(fun = 'max')
write.table(res.stat, args[6], sep="\t", row.names=F, col.names=F, quote=F)

#Make plot
p=ggplot(R, aes(x=bead_type, y=distance)) +
  geom_violin(aes(fill = bead_type),trim=F)+
  theme_classic()+
  theme(plot.title = element_text(hjust = 0.5))+
  scale_fill_manual(values=c("yellow","#40e0d0","#9fd40a"))+
  stat_summary(fun=mean, geom="point", shape=18,size=3, color="black")+
  stat_pvalue_manual(res.stat, label = "p.adj.signif",  y.position = 6, step.increase = 0.15)
  labs(title="CTCF clusters \nBead distance ",subtitle=args[7],
       y="Distance in 3D space (nucleus)", x="Clusters") +
 ggsave(file=args[9], plot=p)



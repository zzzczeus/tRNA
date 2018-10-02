library(edgeR)
args<-commandArgs(TRUE)
file<-args[1]

outfile=paste(file,".edgeR.normalization",sep="")
x <- read.table(file,header=T,row.names=1) 
tt <- apply(x, 1, mean)
x <- x[tt >=0,]

y <- DGEList(counts=x) 
y <- calcNormFactors(y,method="TMM")
y <- estimateCommonDisp(y) 
y <- estimateTagwiseDisp(y) 
et <- y$pseudo.counts 
write.table(et,file=outfile,quote = F, sep = "\t")

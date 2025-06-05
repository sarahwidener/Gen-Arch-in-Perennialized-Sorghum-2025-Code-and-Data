setwd("/Users/alipka/Library/CloudStorage/Box-Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/Initial_Test_Pipeline/H6/H6data")
home.dir <- getwd()

#Read in some prerequisite libraries
#install.packages("rrBLUP")
library(rrBLUP)
library('MASS')
library(multtest)
library(gplots)



#Use the "load" function to read in the SNPs. The SNPs are in a data set called "myG"

setwd("/Users/alipka/Library/CloudStorage/Box-Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/Initial_Test_Pipeline/Scripts_to_Read_In")
source("k.fold.CV.Function.to.Read.In.v.1.5.R")
source("GAPIT_Code_from_Internet_20120411_Allelic_Effect.R")
setwd(home.dir)

#Take a look at the genoytpic and phenotypic data
myG <- read.delim("Genotype.H6.rf.filter.in.Hapmap.Format.txt", head = FALSE) 
View(myG)

myY <- read.csv("H6_all_pheno.csv", head = TRUE)

View(myY)


#Set a seed number - this will ensure that the same folds are being used.
this.seed.number <- sample(-1000000:1000000,1)

#Temporary code
#this.seed.number <- -673994
#End temporary code

#The version of myY has a zillion different phenotypes. For demonstration purposes,
# we'll pick the first trait

myY.for.GS <- myY[,c(1,12)]
View(myY.for.GS)

#####Run 5-fold CV on the genome-wide marker set
dir.create(paste("1Results_X1000Seed",colnames(myY.for.GS)[2],"TEMP",sep = ""))
rrblup.kfoldfoldCV(Y = myY.for.GS, Geno = myG, traitname = colnames(myY.for.GS)[2], path.for.results = paste("1Results_X1000Seed",colnames(myY.for.GS)[2],"TEMP","/",sep = ""), number.of.folds = 5, seed.number = 443943)





#sal

setwd("/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/Initial_Test_Pipeline/H6/H6GS")
home.dir <- getwd()

myY.for.GS <- myY[,c(1,13)]
View(myY.for.GS)

#####Run 5-fold CV on the genome-wide marker set
dir.create(paste("SalResults_X1000Seed",colnames(myY.for.GS)[2],sep = ""))
rrblup.kfoldfoldCV(Y = myY.for.GS, Geno = myG, traitname = colnames(myY.for.GS)[2], path.for.results = paste("SalResults_X1000Seed",colnames(myY.for.GS)[2],"/",sep = ""), number.of.folds = 5, seed.number = this.seed.number)


#Ath

myY.for.GS <- myY[,c(1,14)]
View(myY.for.GS)

#####Run 5-fold CV on the genome-wide marker set
dir.create(paste("AthResults_X1000Seed",colnames(myY.for.GS)[2],sep = ""))
rrblup.kfoldfoldCV(Y = myY.for.GS, Geno = myG, traitname = colnames(myY.for.GS)[2], path.for.results = paste("AthResults_X1000Seed",colnames(myY.for.GS)[2],"/",sep = ""), number.of.folds = 5, seed.number = this.seed.number)


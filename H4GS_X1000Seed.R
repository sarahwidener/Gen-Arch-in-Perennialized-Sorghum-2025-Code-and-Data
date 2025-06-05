setwd("/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/Initial_Test_Pipeline/H4/H4 data")
home.dir <- getwd()

#Read in some prerequisite libraries
#install.packages("rrBLUP")
library(rrBLUP)
library('MASS')
library(multtest)
library(gplots)



#Use the "load" function to read in the SNPs. The SNPs are in a data set called "myG"
setwd("Scripts_to_Read_In")
source("k.fold.CV.Function.to.Read.In.v.1.5.R")
source("GAPIT_Code_from_Internet_20120411_Allelic_Effect.R")
setwd(home.dir)

setwd("/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/Initial_Test_Pipeline/H4/H4_data")
home.dir <- getwd()
#Take a look at the genoytpic and phenotypic data

myG <- read.delim("Genotype.H4.rf.filter.in.Hapmap.Format.txt", head = FALSE) 
View(myG)

myY <- read.csv("H4_Yield_Data.csv", head = TRUE)
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

setwd("/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/Initial_Test_Pipeline/H4/H4GS")
home.dir <- getwd()

#####Run 5-fold CV on the genome-wide marker set
dir.create(paste("1Results_X1000Seed",colnames(myY.for.GS)[2],sep = ""))
rrblup.kfoldfoldCV(Y = myY.for.GS, Geno = myG, traitname = colnames(myY.for.GS)[2], path.for.results = paste("1Results_X1000Seed",colnames(myY.for.GS)[2],"/",sep = ""), number.of.folds = 5, seed.number = this.seed.number)


#################
myY.for.GS <- myY[,c(1,13)]
View(myY.for.GS)

setwd("/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/Initial_Test_Pipeline/H4/H4GS")
home.dir <- getwd()

#####Run 5-fold CV on the genome-wide marker set
dir.create(paste("SalResults_X1000Seed",colnames(myY.for.GS)[2],sep = ""))
rrblup.kfoldfoldCV(Y = myY.for.GS, Geno = myG, traitname = colnames(myY.for.GS)[2], path.for.results = paste("SalResults_X1000Seed",colnames(myY.for.GS)[2],"/",sep = ""), number.of.folds = 5, seed.number = this.seed.number)


#############
myY.for.GS <- myY[,c(1,14)]
View(myY.for.GS)

setwd("/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/Initial_Test_Pipeline/H4/H4GS")
home.dir <- getwd()

#####Run 5-fold CV on the genome-wide marker set
dir.create(paste("AthResults_X1000Seed",colnames(myY.for.GS)[2],sep = ""))
rrblup.kfoldfoldCV(Y = myY.for.GS, Geno = myG, traitname = colnames(myY.for.GS)[2], path.for.results = paste("AthResults_X1000Seed",colnames(myY.for.GS)[2],"/",sep = ""), number.of.folds = 5, seed.number = this.seed.number)



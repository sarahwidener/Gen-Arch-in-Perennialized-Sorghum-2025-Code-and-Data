setwd("/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Kernel")
home.dir <- getwd()


#Read in some prerequisite libraries
#install.packages("rrBLUP")
library(rrBLUP)
library('MASS')
library(multtest)
library(gplots)



#Use the "load" function to read in the SNPs. The SNPs are in a data set called "myG"


setwd("/Users/sarahjw2/Box//Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/Scripts_to_Read_In")
source("k.fold.CV.Function.to.Read.In.v.1.5.R")
source("GAPIT_Code_from_Internet_20120411_Allelic_Effect.R")
setwd(home.dir)



#Take a look at the genoytpic and phenotypic data
setwd("/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Kernel")
myG <- read.delim("Genotype.H4.rf.filter.in.Hapmap.Format.txt", head = FALSE) 
View(myG)


myY <- read.csv("H4_yield_data.csv", head = TRUE)
View(myY)


#Set a seed number - this will ensure that the same folds are being used.
this.seed.number <- sample(-1000000:1000000,1)

#Temporary code
#this.seed.number <- -673994
#End temporary code

#The version of myY has a zillion different phenotypes. For demonstration purposes,
# we'll pick the first trait

myY.for.GS <- myY[,c(1,13)]
View(myY.for.GS)

#####Run 5-fold CV on the genome-wide marker set for the RR-BLUP Model

setwd("/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Kernel")
dir.create(paste("Results_Yeild_S",colnames(myY.for.GS)[2],"RRBLUP",sep = ""))

rrblup.kfoldfoldCV(Y = myY.for.GS, Geno = myG, traitname = colnames(myY.for.GS)[2], path.for.results = paste("Results_Yeild_S",colnames(myY.for.GS)[2],"RRBLUP","/",sep = ""), number.of.folds = 5, seed.number = this.seed.number)




##########################################
#####Using the same seed number and the same trait, run 5-fold CV on the genome-wide marker set for the Multi-Kernel MultiBLUP model
library(sommer)
setwd("/Users/sarahjw2/Box//Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/AEL_Experimental_Pipeline/Scripts_to_Read_In_Exp")
source("hey.where.are.my.SNPs.R")
source("k.fold.CV.Function.Multi.BLUP.R")
setwd(home.dir)

####Go back to the working directory where you are trying out the experiment
setwd("/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Kernel")

#Read in a csv file containing the Chromosome and bp positon of SNPs of interest
these.regions.of.interest <- read.csv("Chr_bp_Pos_Input_File_1000_Seed_Salina.csv", head = TRUE)
View(these.regions.of.interest)

#Find the indices of the SNPs in the vicinity of the region of interest
put.these.row.numbers.of.SNPs.into.separate.kernel <- hey.where.are.my.snps(regions.of.interest = these.regions.of.interest,
                                                                            G = myG)
##########Now, run the MultiBLUP model

dir.create(paste("Results_Yeild_S",colnames(myY.for.GS)[2],"MultiBLUP",sep = ""))
multi.BLUP.kfoldfoldCV(Y = myY.for.GS, Geno = myG, traitname = colnames(myY.for.GS)[2], 
                       path.for.results = paste("Results_Yeild_S",colnames(myY.for.GS)[2],"MultiBLUP","/",sep = ""), 
                       number.of.folds = 5, seed.number = this.seed.number,
                       row.number.of.SNPs.in.separate.kernel = put.these.row.numbers.of.SNPs.into.separate.kernel,
                       quality.control.check = FALSE)


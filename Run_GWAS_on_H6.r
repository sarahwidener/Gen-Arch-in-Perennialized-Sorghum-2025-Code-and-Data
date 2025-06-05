
#Step 0: Set directory to load GAPIT source files (this step is omited for using package)
#######################################################################################
#Read in the prerequisite libraries
library('MASS')
library(multtest)
library(gplots)
#Set the working directory
setwd("/Users/alipka/Library/CloudStorage/Box-Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/Initial_Test_Pipeline/H6/")
home.dir <- getwd()

#Use "source()" to read in some prerequisite scripts
setwd("H6_GWAS/Scripts_Necessary_for_GAPIT")
source("GAPIT_EMMA source code.txt")
source("GAPIT_Code_from_Internet_20120411_Allelic_Effect.r")
setwd(home.dir)


###########################################################
#Create a character string called called "mydataPath". This will enable GAPIT
# to output results in a subdirectory while simultaneously being able
# to read in data from home.dir
mydataPath <- paste(home.dir,"/H6data/", sep = "")



###########################################################
#Read in the data
#Phenotypic Data
myY  <- read.csv(paste(mydataPath,"H6_all_pheno.csv",sep=""), head = TRUE)

#Columns 2, 3, and 4 of myY do not have any phenotypic data. I will remove these
# in the following line of code

myY <- myY[,-c(2,3,4)]

#Read in the genotype file
myG=read.delim(paste(mydataPath,"Genotype.H6.rf.filter.in.Hapmap.Format.txt",sep = ""), head = FALSE)


#Step 2: Set result directory and run GAPIT
setwd(paste(home.dir, "/H6_GWAS", sep = ""))
#######################################################################################
dir.create(paste("Results_GLM",sep = ""))
setwd(paste(home.dir, "/Results_GLM", sep = ""))

#Step 2: Set result directory and run GAPIT
#######################################################################################
#setwd("D:\\GAPIT_GBS_Data")

#mydata=read.delim("zea110812.cov10.fT1E1pLD.mgNoHet.c1.hmp.txt", head = FALSE, nrows = 5)

  
myGAPIT <- GAPIT(
Y=myY,				#This is phenotype data
G=myG,				#This is genotype data,set it to NULL with multiple genotype files

file.path=mydataPath,		#The location of genotype files

kinship.algorithm = "Loiselle",
PCA.total = 0,

group.from=1,		#Was 232	#Lower bound for number of group
group.to=1,			#Upper bound for number of group
group.by=1,				#rang between 1 and number of individuals, smaller the finner optimization 

SNP.impute = "Major",
SNP.MAF = 0.05,
cutOff = 0.00,
Model.selection = TRUE

)
#


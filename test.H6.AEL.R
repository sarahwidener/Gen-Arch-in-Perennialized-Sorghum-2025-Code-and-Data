#Simmulations
setwd("/Users/alipka/Library/CloudStorage/Box-Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/Initial_Test_Pipeline/H6/Simulation/")
home.dir <- getwd()

#install simplepheno
#setRepositories(ind = 1:2)
#devtools::install_github("samuelbfernandes/simplePHENOTYPES", build_vignettes = TRUE)

#if (!require("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")

#BiocManager::install("SNPRelate")
#BiocManager::install("gdsfmt")

#nlibrary(mvtnorm, lqmm, data.table)

#install.packages('simplePHENOTYPES')

#install.packages("readx1")
#library(readxl)
library(simplePHENOTYPES)


#data <- read.delim("Genotype.H4.rf.filter.in.Hapmap.Format.txt", head = FALSE)

#"/Genotype.H4.simulations.Hapmap.Hets.as.C/Genotype.H4.simulations.Hapmap.Hets.as.C.csv"

#data install
data <- read.delim("Genotype.H6.rf.filter.in.Hapmap.Format.NA.as.N.txt", head = TRUE)
View(data)
#colnames(data.numeric)[1:5] <- colnames(SNP55K_maize282_maf04)[1:5]
#data[1:8, 1:10]

#Change the working directory to the results
setwd("Simulated_Traits")

#single trait
create_phenotypes(
  geno_obj = data,
  add_QTN_num = 3,
  add_effect = 0.2,
  big_add_QTN_effect = 0.9,
  rep = 10,
  h2 = 0.7,
  model = "A",
  home_dir = getwd())


#single trait
create_phenotypes(
  geno_obj = SNP55K_maize282_maf04,
  add_QTN_num = 3,
  add_effect = 0.2,
  big_add_QTN_effect = 0.9,
  rep = 10,
  h2 = 0.7,
  model = "A",
  home_dir = home.dir)

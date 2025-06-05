# Set the working directory to the directory where you want to save the boxplots
setwd("/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/")

this.setting <- "many small qtl H0.2"
this.population <- "H4"

#Idenfiy the complete path to the corresponding RR-BLUP and MultiBLUP results for a given simualtion setting
file_paths <- c(
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/many small qtl H0.2/Mean.5.fold.CV.PA.H4.many.small.qtl.H0.2.RRBLUP.csv",
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/many small qtl H0.2/Mean.5.fold.CV.PA.H4.many.small.qtl.H0.2.multiBLUP.csv" 
)

#Add some quality control to make sure you are reading the the results from the setting you think you are

results.RRBLUP <- read.csv(paste(file_paths[1], sep = ""), head = TRUE)
                           #<-"Mean.5.fold.CV.PA.H4.many.small.qtl.H0.2.RRBLUP.csv" 

results.MultiBLUP <- read.csv(paste(file_paths[2], sep = ""), head = TRUE)
#read.csv <-"Mean.5.fold.CV.PA.H4.many.small.qtl.H0.2.multiBLUP.csv" 

#Sarah and Alex noticed that results.RRBLUP and results.MultiBLUP have
# the same column names. Also we don't need the first column in 
# both of these files to make the box plot
colnames(results.RRBLUP)[2] <- "Mean_RRBLUP"
colnames(results.MultiBLUP)[2] <- "Mean_MultiBLUP"

#Use cbind to join results.RRBLUP and resutls MultiBLUP
results.both <- data.frame(results.RRBLUP[,-1], results.MultiBLUP[,-1])


#"Melt" the data so that they are formatted for making a box plot
library(reshape2)

results.melted.for.boxplot <- melt(data = results.both, measure.vars = colnames(results.both))
means <- c(mean(results.both$results.RRBLUP....1., na.rm = TRUE), mean(results.both$results.MultiBLUP....1., na.rm = TRUE) )

#Make the boxplot


pdf(paste("RRBLUP.vs.Multiblup", this.population, ".", this.setting, ".pdf", sep= ""))
boxplot(results.melted.for.boxplot$value ~ results.melted.for.boxplot$variable, col = "Red", 
        xlab = "GS Model", ylab = "Predictive Ability", ylim = c(-0.5, 1.5))
points(c(1:length(means)), means, pch = 3, cex = 0.75) #Adds the means, which are indicated by the "+" symbol
dev.off()


png(paste("RRBLUP.vs.Multiblup", this.population, ".", this.setting, ".png", sep= ""))
boxplot(results.melted.for.boxplot$value ~ results.melted.for.boxplot$variable, col = "Red", 
        xlab = "Many small qtl H0.2 H4", ylab = "Predictive Ability", ylim = c(-0.5, 1.5))
points(c(1:length(means)), means, pch = 3, cex = 0.75) #Adds the means, which are indicated by the "+" symbol
dev.off()












# Set the working directory to the directory where you want to save the boxplots
setwd("/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/")

this.setting <- "many small qtl H0.5"
this.population <- "H4"

#Idenfiy the complete path to the corresponding RR-BLUP and MultiBLUP results for a given simualtion setting
file_paths <- c(
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/many small qtl H0.5/Mean.5.fold.CV.PA.H4.many.small.qtl.H0.5.RRBLUP.csv",
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/many small qtl H0.5/Mean.5.fold.CV.PA.H4.many.small.qtl.H0.5.multiBLUP.csv" 
)

#Add some quality control to make sure you are reading the the results from the setting you think you are

results.RRBLUP <- read.csv(paste(file_paths[1], sep = ""), head = TRUE)
#<-"Mean.5.fold.CV.PA.H4.many.small.qtl.H0.5.RRBLUP.csv" 

results.MultiBLUP <- read.csv(paste(file_paths[2], sep = ""), head = TRUE)
#read.csv <-"Mean.5.fold.CV.PA.H4.many.small.qtl.H0.5.multiBLUP.csv" 

#Sarah and Alex noticed that results.RRBLUP and results.MultiBLUP have
# the same column names. Also we don't need the first column in 
# both of these files to make the box plot
colnames(results.RRBLUP)[2] <- "Mean_RRBLUP"
colnames(results.MultiBLUP)[2] <- "Mean_MultiBLUP"

#Use cbind to join results.RRBLUP and resutls MultiBLUP
results.both <- data.frame(results.RRBLUP[,-1], results.MultiBLUP[,-1])


#"Melt" the data so that they are formatted for making a box plot
library(reshape2)

results.melted.for.boxplot <- melt(data = results.both, measure.vars = colnames(results.both))
means <- c(mean(results.both$results.RRBLUP....1., na.rm = TRUE), mean(results.both$results.MultiBLUP....1., na.rm = TRUE) )

#Make the boxplot


pdf(paste("RRBLUP.vs.Multiblup", this.population, ".", this.setting, ".pdf", sep= ""))
boxplot(results.melted.for.boxplot$value ~ results.melted.for.boxplot$variable, col = "Red", 
        xlab = "GS Model", ylab = "Predictive Ability", ylim = c(-0.5, 1.5))
points(c(1:length(means)), means, pch = 3, cex = 0.75) #Adds the means, which are indicated by the "+" symbol
dev.off()


png(paste("RRBLUP.vs.Multiblup", this.population, ".", this.setting, ".png", sep= ""))
boxplot(results.melted.for.boxplot$value ~ results.melted.for.boxplot$variable, col = "Red", 
        xlab = "Many small qtl H0.5 H4", ylab = "Predictive Ability", ylim = c(-0.5, 1.5))
points(c(1:length(means)), means, pch = 3, cex = 0.75) #Adds the means, which are indicated by the "+" symbol
dev.off()

















# Set the working directory to the directory where you want to save the boxplots
setwd("/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/")

this.setting <- "many small qtl H0.8"
this.population <- "H4"

#Idenfiy the complete path to the corresponding RR-BLUP and MultiBLUP results for a given simualtion setting
file_paths <- c(
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/many small qtl H0.8/Mean.5.fold.CV.PA.H4.many.small.qtl.H0.8.RRBLUP.csv",
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/many small qtl H0.8/Mean.5.fold.CV.PA.H4.many.small.qtl.H0.8.multiBLUP.csv" 
)

#Add some quality control to make sure you are reading the the results from the setting you think you are

results.RRBLUP <- read.csv(paste(file_paths[1], sep = ""), head = TRUE)
#<-"Mean.5.fold.CV.PA.H4.many.small.qtl.H0.8.RRBLUP.csv" 

results.MultiBLUP <- read.csv(paste(file_paths[2], sep = ""), head = TRUE)
#read.csv <-"Mean.5.fold.CV.PA.H4.many.small.qtl.H0.8.multiBLUP.csv" 

#Sarah and Alex noticed that results.RRBLUP and results.MultiBLUP have
# the same column names. Also we don't need the first column in 
# both of these files to make the box plot
colnames(results.RRBLUP)[2] <- "Mean_RRBLUP"
colnames(results.MultiBLUP)[2] <- "Mean_MultiBLUP"

#Use cbind to join results.RRBLUP and resutls MultiBLUP
results.both <- data.frame(results.RRBLUP[,-1], results.MultiBLUP[,-1])


#"Melt" the data so that they are formatted for making a box plot
library(reshape2)

results.melted.for.boxplot <- melt(data = results.both, measure.vars = colnames(results.both))
means <- c(mean(results.both$results.RRBLUP....1., na.rm = TRUE), mean(results.both$results.MultiBLUP....1., na.rm = TRUE) )

#Make the boxplot


pdf(paste("RRBLUP.vs.Multiblup", this.population, ".", this.setting, ".pdf", sep= ""))
boxplot(results.melted.for.boxplot$value ~ results.melted.for.boxplot$variable, col = "Red", 
        xlab = "GS Model", ylab = "Predictive Ability", ylim = c(-0.5, 1.5))
points(c(1:length(means)), means, pch = 3, cex = 0.75) #Adds the means, which are indicated by the "+" symbol
dev.off()


png(paste("RRBLUP.vs.Multiblup", this.population, ".", this.setting, ".png", sep= ""))
boxplot(results.melted.for.boxplot$value ~ results.melted.for.boxplot$variable, col = "Red", 
        xlab = "Many small qtl H0.8 H4", ylab = "Predictive Ability", ylim = c(-0.5, 1.5))
points(c(1:length(means)), means, pch = 3, cex = 0.75) #Adds the means, which are indicated by the "+" symbol
dev.off()

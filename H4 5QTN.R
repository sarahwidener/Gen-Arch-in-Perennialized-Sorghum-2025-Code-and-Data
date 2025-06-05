# Set the working directory to the directory where you want to save the boxplots
setwd("/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/")

# Load necessary libraries
library(reshape2)

# Define a function to generate the box plot for each setting
generate_boxplot <- function(setting, file_paths) {
  
  # Read the CSV files
  results.GBLUP <- read.csv(file_paths[1], head = TRUE)
  results.MultiBLUP <- read.csv(file_paths[2], head = TRUE)
  
  # Modify column names to simplify the labels
  colnames(results.GBLUP)[2] <- "GBLUP"
  colnames(results.MultiBLUP)[2] <- "MultiBLUP"
  
  # Merge the results
  results.both <- data.frame(results.GBLUP[,-1], results.MultiBLUP[,-1])
  
  # Melt the data for boxplot
  results.melted <- melt(data = results.both, measure.vars = colnames(results.both))
  
  # Rename the variable levels in melted data for cleaner labels
  levels(results.melted$variable) <- c("GBLUP", "MultiBLUP")
  
  # Create the boxplot with renamed labels
  boxplot(results.melted$value ~ results.melted$variable, col = "darkgreen", 
          xlab = expression("GS Model"), ylab = expression("Predictive Ability"), ylim = c(-0.5, 1.5),
          cex.main = 3, cex.lab = 3, cex.axis = 3, main = setting)
}

# Define file paths for each setting
file_paths_list <- list(
  c(
    "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/Large qtl H0.2/Mean.5.fold.CV.PA.H4.Large qtl H0.2.GBLUP.csv",
    "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/Large qtl H0.2/Mean.5.fold.CV.PA.H4.Large qtl H0.2.multiBLUP.csv"
  ),
  c(
    "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/Large qtl H0.5/Mean.5.fold.CV.PA.H4.Large qtl H0.5.GBLUP.csv",
    "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/Large qtl H0.5/Mean.5.fold.CV.PA.H4.Large qtl H0.5.multiBLUP.csv"
  ),
  c(
    "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/Large qtl H0.8/Mean.5.fold.CV.PA.H4.Large qtl H0.8.GBLUP.csv",
    "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/Large qtl H0.8/Mean.5.fold.CV.PA.H4.Large qtl H0.8.multiBLUP.csv"
  )
)

# Define corresponding setting names with superscripts for the numbers
settings <- list(
  expression("5 Large qtl H"~0.2),
  expression("5 Large qtl H"~0.5),
  expression("5 Large qtl H"~0.8)
)

# Create the PNG device to save the combined plot as a single figure
png("/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/combined_boxplots_H4_5QTN.png", 
    width = 1800, height = 600)

# Set up plotting area for 3 plots side by side
par(mfrow = c(1, 3))  # Arrange plots in 1 row and 3 columns

# Generate boxplots for all three settings
for (i in 1:3) {
  generate_boxplot(settings[[i]], file_paths_list[[i]])
}

# Add a centered title across the entire plot
mtext(expression("H4 with 5 QTN"), side = 3, line = 1, cex = 4, font = 2, col = "black", outer = TRUE)

# Turn off the PNG device (save the image)
dev.off()

# View the plot in RStudio plot panel before saving it
dev.new()
par(mfrow = c(1, 3))
for (i in 1:3) {
  generate_boxplot(settings[[i]], file_paths_list[[i]])
}

# Add a centered title across the entire plot in RStudio plot panel
mtext(expression("H4 with 5 QTN"), side = 3, line = 1, cex = 4, font = 2, col = "black",
      























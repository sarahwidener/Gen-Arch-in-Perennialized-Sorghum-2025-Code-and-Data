# Set the working directory to the directory where you want to save the boxplots
setwd("/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/")

# Load necessary libraries
library(reshape2)

# Define a function to generate the box plot for each setting
generate_boxplot <- function(setting, population, file_paths) {
  
  # Read the CSV files
  results.GBLUP <- read.csv(file_paths[1], head = TRUE)
  results.MultiBLUP <- read.csv(file_paths[2], head = TRUE)
  
  # Modify column names
  colnames(results.GBLUP)[2] <- "GBLUP"
  colnames(results.MultiBLUP)[2] <- "MultiBLUP"
  
  # Merge the results
  results.both <- data.frame(results.GBLUP[,-1], results.MultiBLUP[,-1])
  
  # Melt the data for boxplot
  results.melted.for.boxplot <- melt(data = results.both, measure.vars = colnames(results.both))
  
  # Create the boxplot for this specific setting
  boxplot(results.melted.for.boxplot$value ~ results.melted.for.boxplot$variable, 
          col = "lightgreen", 
          xlab = "GS Model", 
          ylab = "Predictive Ability", 
          ylim = c(-0.5, 1.0), 
          cex.main = 3, 
          cex.lab = 2, 
          cex.axis = 3, 
          names = c("GBLUP", "MultiBLUP")) # Set boxplot names
}

# File paths for each setting
file_paths_1 <- c(
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/Large qtl H0.2/Mean.5.fold.CV.PA.H4.Large qtl H0.2.GBLUP.csv",
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/Large qtl H0.2/Mean.5.fold.CV.PA.H4.Large qtl H0.2.multiBLUP.csv"
)

file_paths_2 <- c(
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/Large qtl H0.5/Mean.5.fold.CV.PA.H4.Large qtl H0.5.GBLUP.csv",
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/Large qtl H0.5/Mean.5.fold.CV.PA.H4.Large qtl H0.5.multiBLUP.csv"
)

file_paths_3 <- c(
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/Large qtl H0.8/Mean.5.fold.CV.PA.H4.Large qtl H0.8.GBLUP.csv",
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/Large qtl H0.8/Mean.5.fold.CV.PA.H4.Large qtl H0.8.multiBLUP.csv"
)

# Create the PNG device to save the combined plot as a single figure
png("/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/combined_boxplots_H4_5QTN.png", 
    width = 1800, height = 600) 

# Set up plotting area for 3 plots side by side
par(mfrow = c(1, 3)) 

# Generate boxplots for all three settings and show them side by side
generate_boxplot("5 Large qtl H0.2", "H4", file_paths_1)
generate_boxplot("5 large qtl H0.5", "H4", file_paths_2)
generate_boxplot("5 Large qtl H0.8", "H4", file_paths_3)

# Turn off the PNG device (save the image)
dev.off()

# You can also use dev.new() to see the plots in RStudio plot panel before saving them
dev.new()

# Generate the plots to appear in the RStudio plot panel
par(mfrow = c(1, 3)) 
generate_boxplot("5 Large qtl H0.2", "H4", file_paths_1)
generate_boxplot("5 large qtl H0.5", "H4", file_paths_2)
generate_boxplot("5 Large qtl H0.8", "H4", file_paths_3)

# Create the PNG device to save the combined plot as a single figure
png("/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/combined_boxplots_H4_5GTN.png", 
    width = 1800, height = 600) 

# Set up plotting area for 3 plots side by side
par(mfrow = c(1, 3), mar = c(5, 4, 4, 2) + 0.1) 

# Generate boxplots for all three settings and show them side by side
generate_boxplot("5 Large qtl H0.2", "H4", file_paths_1)
generate_boxplot("5 large qtl H0.5", "H4", file_paths_2)
generate_boxplot("5 Large qtl H0.8", "H4", file_paths_3)

# Add a centered title across the entire plot
mtext("H4 with 5 QTN", side = 3, line = 1, cex = 4, font = 2, col = "black", outer = TRUE)

# Turn off the PNG device (save the image)
dev.off()

# You can also use dev.new() to see the plots in RStudio plot panel before saving them
dev.new()

# Generate the plots to appear in the RStudio plot panel
par(mfrow = c(1, 3), mar = c(5, 4, 4, 2) + 0.1) 
generate_boxplot("5 Large qtl H0.2", "H4", file_paths_1)
generate_boxplot("5 large qtl H0.5", "H4", file_paths_2)
generate_boxplot("5 Large qtl H0.8", "H4", file_paths_3)

# Add a centered title across the entire plot in RStudio plot panel
mtext("H4 with 5 QTN", side = 3, line = 1, cex = 4, font = 2, col = "black", outer = TRUE)


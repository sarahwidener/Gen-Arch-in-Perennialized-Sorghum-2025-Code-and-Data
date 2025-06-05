# Set the working directory to the directory where you want to save the boxplots
# Ensure this path exists and R has write permissions.
setwd("/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/")

# Load necessary libraries
library(reshape2)

# ---
## Function to generate a single boxplot for the grid
# ---
generate_boxplot <- function(file_paths, main_title = "", ylim_range = c(-0.5, 1.0), box_color = "lightgreen") {
  
  # Check if files exist before trying to read them
  if (!file.exists(file_paths[1])) {
    stop(paste0("Error: GBLUP/RRBLUP file not found at: ", file_paths[1],
                "\nPlease verify the exact path and filename."))
  }
  if (!file.exists(file_paths[2])) {
    stop(paste0("Error: MultiBLUP file not found at: ", file_paths[2],
                "\nPlease verify the exact path and filename."))
  }
  
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
          col = box_color,
          xlab = "", # Removed xlab here for overall plot clarity
          ylab = "", # Removed ylab here for overall plot clarity
          ylim = ylim_range,
          cex.main = 1.8, # Adjusted for grid
          cex.lab = 1.2,  # Adjusted for grid
          cex.axis = 1.2, # Adjusted for grid
          names = c("GBLUP", "MultiBLUP"), # Set boxplot names
          main = main_title) # Added main title for individual plot
}

# ---
## Define ALL File Paths (CRITICAL: UPDATE THESE WITH YOUR EXACT PATHS)
# ---

# IMPORTANT: Replace these placeholder paths with the actual, verified paths on your system.
# Use forward slashes (/) for all paths, even on Windows.
# Ensure file names match exactly, including capitalization and extensions.

# 5 QTN Files
file_paths_5_H0.2 <- c(
  "C:/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/Large qtl H0.2/Mean.5.fold.CV.PA.H4.Large qtl H0.2.GBLUP.csv",
  "C:/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/Large qtl H0.2/Mean.5.fold.CV.PA.H4.Large qtl H0.2.multiBLUP.csv"
)
file_paths_5_H0.5 <- c(
  "C:/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/Large qtl H0.5/Mean.5.fold.CV.PA.H4.Large qtl H0.5.GBLUP.csv",
  "C:/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/Large qtl H0.5/Mean.5.fold.CV.PA.H4.Large qtl H0.5.multiBLUP.csv"
)
file_paths_5_H0.8 <- c(
  "C:/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/Large qtl H0.8/Mean.5.fold.CV.PA.H4.Large qtl H0.8.GBLUP.csv",
  "C:/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/Large qtl H0.8/Mean.5.fold.CV.PA.H4.Large qtl H0.8.multiBLUP.csv"
)

# 15 QTN Files (Assuming these use RRBLUP for the first file, as per your previous code)
file_paths_15_H0.2 <- c(
  "C:/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/several medium qtl H0.2/Mean.5.fold.CV.PA.H4.many.small.qtl.H0.2.RRBLUP.csv", # Check filename
  "C:/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/several medium qtl H0.2/Mean.5.fold.CV.PA.H4.many.small.qtl.H0.2.multiBLUP.csv" # Check filename
)
file_paths_15_H0.5 <- c(
  "C:/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/several medium qtl H0.5/Mean.5.fold.CV.PA.H4.several medium qtl H0.5.RRBLUP.csv", # Check filename
  "C:/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/several medium qtl H0.5/Mean.5.fold.CV.PA.H4.several medium qtl H0.5.multiBLUP.csv" # Check filename
)
file_paths_15_H0.8 <- c(
  "C:/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/several medium qtl H0.8/Mean.5.fold.CV.PA.H4.several medium qtl H0.8.RRBLUP.csv", # Check filename
  "C:/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/several medium qtl H0.8/Mean.5.fold.CV.PA.H4.several medium qtl H0.8.multiBLUP.csv" # Check filename
)

# 30 QTN Files
file_paths_30_H0.2 <- c(
  "C:/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/many small qtl H0.2/Mean.5.fold.CV.PA.H4.many.small.qtl.H0.2.RRBLUP.csv", # Check filename
  "C:/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/many small qtl H0.2/Mean.5.fold.CV.PA.H4.many.small.qtl.H0.2.multiBLUP.csv" # Check filename
)
file_paths_30_H0.5 <- c(
  "C:/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/many small qtl H0.5/Mean.5.fold.CV.PA.H4.many.small.qtl.H0.5.RRBLUP.csv", # Check filename
  "C:/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/many small qtl H0.5/Mean.5.fold.CV.PA.H4.many.small.qtl.H0.5.multiBLUP.csv" # Check filename
)
file_paths_30_H0.8 <- c(
  "C:/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/many small qtl H0.8/Mean.5.fold.CV.PA.H4.many.small.qtl.H0.8.RRBLUP.csv", # Check filename
  "C:/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/many small qtl H0.8/Mean.5.fold.CV.PA.H4.many.small.qtl.H0.8.multiBLUP.csv" # Check filename
)

# Store all file paths in a structured way for easy looping
# This allows access like all_paths[["5_0.2"]]
all_paths <- list(
  "5_0.2" = file_paths_5_H0.2, "5_0.5" = file_paths_5_H0.5, "5_0.8" = file_paths_5_H0.8,
  "15_0.2" = file_paths_15_H0.2, "15_0.5" = file_paths_15_H0.5, "15_0.8" = file_paths_15_H0.8,
  "30_0.2" = file_paths_30_H0.2, "30_0.5" = file_paths_30_H0.5, "30_0.8" = file_paths_30_H0.8
)

# ---
## Create and Save the 3x3 Box Plot Grid
# ---

output_png_path <- "/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/combined_boxplots_3x3_QTN_H2.png"

png(output_png_path, width = 2400, height = 2400, res = 150) # Increased resolution

# Set up plotting area for 3 rows and 3 columns
par(mfrow = c(3, 3),         # 3 rows, 3 columns
    mar = c(4, 4, 3, 1),     # Margins: bottom, left, top, right
    oma = c(3, 3, 5, 1))     # Outer margins: bottom, left, top, right (for overall titles)

# Define QTN values and Heritability values for consistent iteration
qtn_values <- c("5", "15", "30")
heritability_values <- c("0.2", "0.5", "0.8")

# Define box colors for each QTN group
box_color_map <- c("5" = "lightgreen", "15" = "lightyellow", "30" = "lightpink")

for (qtn_num_str in qtn_values) {
  for (h_val in heritability_values) {
    file_key <- paste0(qtn_num_str, "_", h_val)
    current_file_paths <- all_paths[[file_key]]
    
    plot_title <- paste0("H^2 = ", h_val)
    current_box_color <- box_color_map[[qtn_num_str]]
    
    generate_boxplot(
      file_paths = current_file_paths,
      main_title = plot_title,
      box_color = current_box_color
    )
    
    # Add row labels (QTN numbers) on the left side of the plots (only for the first column)
    if (h_val == heritability_values[1]) {
      mtext(paste0(qtn_num_str, " QTN"), side = 2, line = 3.5, cex = 1.8, font = 2, las = 0)
    }
  }
}

# Add overall titles
mtext("Predictive Ability of GBLUP vs. MultiBLUP across QTN and Heritability",
      side = 3, line = 2.5, cex = 2.5, font = 2, outer = TRUE, col = "black")
mtext("GS Model", side = 1, line = 1.5, cex = 2, outer = TRUE, adj = 0.5)
mtext("Predictive Ability", side = 2, line = 1.5, cex = 2, outer = TRUE, adj = 0.5)

dev.off()
cat(paste0("3x3 box plot grid saved to: ", output_png_path, "\n"))

# ---
## Display the 3x3 Box Plot Grid in RStudio (optional)
# ---

dev.new(width = 12, height = 12) # Adjust size for RStudio viewer

par(mfrow = c(3, 3),
    mar = c(4, 4, 3, 1),
    oma = c(3, 3, 5, 1))

for (qtn_num_str in qtn_values) {
  for (h_val in heritability_values) {
    file_key <- paste0(qtn_num_str, "_", h_val)
    current_file_paths <- all_paths[[file_key]]
    
    plot_title <- paste0("H^2 = ", h_val)
    current_box_color <- box_color_map[[qtn_num_str]]
    
    generate_boxplot(
      file_paths = current_file_paths,
      main_title = plot_title,
      box_color = current_box_color
    )
    
    if (h_val == heritability_values[1]) {
      mtext(paste0(qtn_num_str, " QTN"), side = 2, line = 3.5, cex = 1.8, font = 2, las = 0)
    }
  }
}

mtext("Predictive Ability of GBLUP vs. MultiBLUP across QTN and Heritability",
      side = 3, line = 2.5, cex = 2.5, font = 2, outer = TRUE, col = "black")
mtext("GS Model", side = 1, line = 1.5, cex = 2, outer = TRUE, adj = 0.5)
mtext("Predictive Ability", side = 2, line = 1.5, cex = 2, outer = TRUE, adj = 0.5)


dev.off()

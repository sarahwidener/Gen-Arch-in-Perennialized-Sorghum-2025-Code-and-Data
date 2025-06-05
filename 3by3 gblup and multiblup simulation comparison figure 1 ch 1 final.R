# Set the working directory to the directory where you want to save the boxplots
setwd("/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H6/Simulation/")

# Load necessary libraries
library(reshape2)
library(ggplot2)
library(dplyr)
library(tidyr)
library(patchwork) # For arranging multiple ggplot objects

# ---
## Function to generate a single boxplot (now returns a ggplot object)
# ---
generate_boxplot_ggplot <- function(file_paths, main_title = "", ylim_range = c(-0.5, 1.0), box_color = "lightgreen") {
  
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
  results.GBLUP <- read.csv(file_paths[1], header = TRUE)
  results.MultiBLUP <- read.csv(file_paths[2], header = TRUE)
  
  # Modify column names
  colnames(results.GBLUP)[2] <- "GBLUP"
  colnames(results.MultiBLUP)[2] <- "MultiBLUP"
  
  # Merge the results
  results.both <- data.frame(GBLUP = results.GBLUP[,-1], MultiBLUP = results.MultiBLUP[,-1])
  
  # Melt the data for ggplot
  results.melted.for.boxplot <- results.both %>%
    pivot_longer(
      cols = everything(), # Melts all columns
      names_to = "GS_Model",
      values_to = "Predictive_Ability"
    )
  
  # Convert GS_Model to a factor with desired order for plotting
  results.melted.for.boxplot$GS_Model <- factor(results.melted.for.boxplot$GS_Model,
                                                levels = c("GBLUP", "MultiBLUP"))
  
  # Perform Wilcoxon rank-sum test
  wilcox_test_result <- wilcox.test(
    Predictive_Ability ~ GS_Model,
    data = results.melted.for.boxplot,
    paired = FALSE # Assuming unpaired, adjust if your data is paired
  )
  
  # Determine significance stars
  p_value <- wilcox_test_result$p.value
  significance_label <- ""
  if (p_value < 0.001) {
    significance_label <- "***"
  } else if (p_value < 0.01) {
    significance_label <- "**"
  } else if (p_value < 0.05) {
    significance_label <- "*"
  } else {
    significance_label <- "NS" # Not significant
  }
  
  # Find the maximum value in the data for annotation positioning
  max_y_value_plot <- max(results.melted.for.boxplot$Predictive_Ability, na.rm = TRUE)
  annotation_y_pos <- max_y_value_plot + 0.05 * (ylim_range[2] - ylim_range[1])
  
  
  # Create the ggplot boxplot
  p <- ggplot(results.melted.for.boxplot, aes(x = GS_Model, y = Predictive_Ability)) +
    geom_boxplot(fill = box_color, color = "black", width = 0.6) +
    #geom_point(aes(color = GS_Model), position = position_jitter(width = 0.2), alpha = 0.6) + # Optional: show individual points
    stat_summary(fun = mean, geom = "point", shape = 8, size = 3, color = "darkblue") + # Add mean as a cross
    labs(title = main_title, y = "Predictive Ability", x = "GS Model") + # Set labels
    ylim(ylim_range) + # Set y-axis limits
    theme_minimal() + # A clean theme
    theme(
      plot.title = element_text(hjust = 0.5, size = 16, face = "bold"), # Center and size main title
      axis.title.x = element_text(size = 14, margin = margin(t = 10)), # X-axis title font size and spacing
      axis.title.y = element_text(size = 14, margin = margin(r = 10)), # Y-axis title font size and spacing
      axis.text.x = element_text(size = 12), # X-axis labels font size
      axis.text.y = element_text(size = 12)  # Y-axis labels font size
    ) +
    # Add significance label
    annotate("text",
             x = 1.5, # Position between the two boxplots
             y = annotation_y_pos,
             label = significance_label,
             size = 6, # Size of the star annotation
             fontface = "bold")
  
  return(p)
}

# ---
## Define ALL File Paths for H6 Simulation (CRITICAL: VERIFY THESE)
# ---

# Base directory for H6 Simulation
# Ensure this path is correct and exists on your system.
base_dir_H6_sim <- "/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H6/Simulation/Simulated_Traits/"

# 5 QTN Files
# **ACTION REQUIRED:** Carefully check these file names and paths against your actual files.
# The error originated from 'Large qtl H0.8.RRBLUP (2).csv'. Make sure you have the correct name.
file_paths_5_H0.2 <- c(
  paste0(base_dir_H6_sim, "Large qtl H0.2/Mean.5.fold.CV.PA.H6.Large qtl H0.2.RRBLUP.csv"),
  paste0(base_dir_H6_sim, "Large qtl H0.2/Mean.5.fold.CV.PA.H6.Large qtl H0.2.multiBLUP.csv")
)
file_paths_5_H0.5 <- c(
  paste0(base_dir_H6_sim, "Large qtl H0.5/Mean.5.fold.CV.PA.H6.Large qtl H0.5.RRBLUP.csv"),
  paste0(base_dir_H6_sim, "Large qtl H0.5/Mean.5.fold.CV.PA.H6.Large qtl H0.5.multiBLUP.csv")
)
file_paths_5_H0.8 <- c(
  # THIS WAS THE PROBLEM FILE: Re-verify this path and filename.
  # If the file is literally named "...RRBLUP (2).csv", then keep it.
  # Otherwise, correct it. I've removed the "(2)" and the duplicated "Mean.5.fold.CV.PA.H6.Large qtl" for a cleaner path.
  paste0(base_dir_H6_sim, "Large qtl H0.8/Mean.5.fold.CV.PA.H6.Large qtl H0.8.RRBLUPusethis.csv"),
  paste0(base_dir_H6_sim, "Large qtl H0.8/Mean.5.fold.CV.PA.H6.Large qtl H0.8.multiBLUP.csv")
)

# 15 QTN Files
# **ACTION REQUIRED:** Double-check these paths and filenames.
# Note the change from "large qtl" to "several medium qtl" in folder and file names.
file_paths_15_H0.2 <- c(
  paste0(base_dir_H6_sim, "several medium qtl H0.2/Mean.5.fold.CV.PA.H6.several medium qtl H0.2.RRBLUP.csv"),
  paste0(base_dir_H6_sim, "several medium qtl H0.2/Mean.5.fold.CV.PA.H6.several medium qtl H0.2.multiBLUP.csv")
)
file_paths_15_H0.5 <- c(
  paste0(base_dir_H6_sim, "several medium qtl H0.5/Mean.5.fold.CV.PA.H6.several medium qtl H0.5.RRBLUP.csv"),
  paste0(base_dir_H6_sim, "several medium qtl H0.5/Mean.5.fold.CV.PA.H6.several medium qtl H0.5.multiBLUP.csv")
)
file_paths_15_H0.8 <- c(
  paste0(base_dir_H6_sim, "several medium qtl H0.8/Mean.5.fold.CV.PA.H6.several medium qtl H0.8.RRBLUP.csv"),
  paste0(base_dir_H6_sim, "several medium qtl H0.8/Mean.5.fold.CV.PA.H6.several medium qtl H0.8.multiBLUP.csv")
)

# 30 QTN Files
# **ACTION REQUIRED:** Double-check these paths and filenames.
# Note the change from "several medium qtl" to "many small qtl" in folder and file names.
file_paths_30_H0.2 <- c(
  paste0(base_dir_H6_sim, "many small qtl H0.2/Mean.5.fold.CV.PA.H6.many small qtl H0.2.RRBLUP.csv"),
  paste0(base_dir_H6_sim, "many small qtl H0.2/Mean.5.fold.CV.PA.H6.many small qtl H0.2.multiBLUP.csv")
)
file_paths_30_H0.5 <- c(
  paste0(base_dir_H6_sim, "many small qtl H0.5/Mean.5.fold.CV.PA.H6.many small qtl H0.5.RRBLUP.csv"),
  paste0(base_dir_H6_sim, "many small qtl H0.5/Mean.5.fold.CV.PA.H6.many small qtl H0.5.multiBLUP.csv")
)
file_paths_30_H0.8 <- c(
  # **VERY IMPORTANT:** This path was incorrect in your original H6 script, pointing to "Large qtl H0.8"
  # I've corrected it to "many small qtl H0.8" assuming consistency with the other 30 QTN files.
  # If your data structure is different, adjust this accordingly.
  paste0(base_dir_H6_sim, "many small qtl H0.8/Mean.5.fold.CV.PA.H6.many small qtl H0.8.RRBLUP.csv"),
  paste0(base_dir_H6_sim, "many small qtl H0.8/Mean.5.fold.CV.PA.H6.many small qtl H0.8.multiBLUP.csv")
)

# Store all file paths in a structured way for easy looping
all_paths <- list(
  "5_0.2" = file_paths_5_H0.2, "5_0.5" = file_paths_5_H0.5, "5_0.8" = file_paths_5_H0.8,
  "15_0.2" = file_paths_15_H0.2, "15_0.5" = file_paths_15_H0.5, "15_0.8" = file_paths_15_H0.8,
  "30_0.2" = file_paths_30_H0.2, "30_0.5" = file_paths_30_H0.5, "30_0.8" = file_paths_30_H0.8
)

# Define QTN values and Heritability values for consistent iteration
qtn_values <- c("5", "15", "30")
heritability_values <- c("0.2", "0.5", "0.8")

# Define box colors for each QTN group
box_color_map <- c("5" = "#C6E7B9", "15" = "#FFF7B9", "30" = "#F2B8B8") # Lighter, softer colors

# Initialize a list to hold all ggplot objects
plot_list <- list()

# Loop to generate each individual ggplot object
for (qtn_num_str in qtn_values) {
  for (h_val in heritability_values) {
    file_key <- paste0(qtn_num_str, "_", h_val)
    current_file_paths <- all_paths[[file_key]]
    
    current_box_color <- box_color_map[[qtn_num_str]]
    
    # Call the ggplot version of the function
    p <- generate_boxplot_ggplot(
      file_paths = current_file_paths,
      main_title = "", # Individual plot titles will be handled by patchwork
      box_color = current_box_color
    )
    plot_list[[file_key]] <- p
  }
}

# ---
## Arrange and Display the 3x3 Box Plot Grid using patchwork
# ---

# Re-create plot_list with main_title set to HERITABILITY for column titles
plot_list_with_col_titles <- list()
for (qtn_num_str in qtn_values) {
  for (h_val in heritability_values) {
    file_key <- paste0(qtn_num_str, "_", h_val)
    current_file_paths <- all_paths[[file_key]]
    current_box_color <- box_color_map[[qtn_num_str]]
    
    # Only add H2 title to the top row
    plot_title_for_individual <- if (qtn_num_str == qtn_values[1]) {
      # Use expression for H^2 formatting
      eval(parse(text=paste0("expression(H^2 == ", h_val, ")")))
    } else {
      "" # No title for other rows
    }
    
    p <- generate_boxplot_ggplot(
      file_paths = current_file_paths,
      main_title = plot_title_for_individual, # Now individual plots get the H2 title
      box_color = current_box_color
    )
    
    # Adjust title size within the plot's theme
    p <- p + theme(plot.title = element_text(hjust = 0.5, size = 18, face = "bold"))
    
    plot_list_with_col_titles[[file_key]] <- p
  }
}

# Add row labels as separate plot objects
row_label_plots <- list(
  ggplot() + annotate("text", x = 0.5, y = 0.5, label = "5 QTNs", angle = 90, size = 8, fontface = "bold") + theme_void(),
  ggplot() + annotate("text", x = 0.5, y = 0.5, label = "15 QTNs", angle = 90, size = 8, fontface = "bold") + theme_void(),
  ggplot() + annotate("text", x = 0.5, y = 0.5, label = "30 QTNs", angle = 90, size = 8, fontface = "bold") + theme_void()
)

# Combine row labels with the main plot grid
final_plot_with_rows <- (
  row_label_plots[[1]] + plot_list_with_col_titles[["5_0.2"]] + plot_list_with_col_titles[["5_0.5"]] + plot_list_with_col_titles[["5_0.8"]] + plot_layout(ncol = 4, widths = c(0.1, 1, 1, 1))
) / (
  row_label_plots[[2]] + plot_list_with_col_titles[["15_0.2"]] + plot_list_with_col_titles[["15_0.5"]] + plot_list_with_col_titles[["15_0.8"]] + plot_layout(ncol = 4, widths = c(0.1, 1, 1, 1))
) / (
  row_label_plots[[3]] + plot_list_with_col_titles[["30_0.2"]] + plot_list_with_col_titles[["30_0.5"]] + plot_list_with_col_titles[["30_0.8"]] + plot_layout(ncol = 4, widths = c(0.1, 1, 1, 1))
) +
  plot_annotation(
    title = "Predictive Ability of GBLUP vs. MultiBLUP across QTN and Heritability",
    theme = theme(plot.title = element_text(hjust = 0.5, size = 22, face = "bold", margin = margin(b = 20)))
  ) &
  theme(plot.margin = margin(5, 5, 5, 5)) # Adjust margins for the whole combined plot

# Display the plot in RStudio
print(final_plot_with_rows)

# Save the combined plot to a PNG file
output_png_path_ggplot <- "/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H6/Simulation/combined_boxplots_3x3_QTN_H2_ggplot.png"
ggsave(output_png_path_ggplot, plot = final_plot_with_rows, width = 15, height = 12, dpi = 300)

cat(paste0("3x3 box plot grid saved with ggplot2 to: ", output_png_path_ggplot, "\n"))

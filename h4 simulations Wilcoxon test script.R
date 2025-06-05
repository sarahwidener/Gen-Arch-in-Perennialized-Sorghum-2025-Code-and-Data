

# Load necessary libraries
library(readr)
library(dplyr)

# Define file paths for all 9 scenarios
file_paths_1 <- c(
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/many small qtl H0.2/Mean.5.fold.CV.PA.H4.many.small.qtl.H0.2.RRBLUP.csv",
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/many small qtl H0.2/Mean.5.fold.CV.PA.H4.many.small.qtl.H0.2.multiBLUP.csv"
)
file_paths_2 <- c(
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/many small qtl H0.5/Mean.5.fold.CV.PA.H4.many.small.qtl.H0.5.RRBLUP.csv",
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/many small qtl H0.5/Mean.5.fold.CV.PA.H4.many.small.qtl.H0.5.multiBLUP.csv"
)
file_paths_3 <- c(
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/many small qtl H0.8/Mean.5.fold.CV.PA.H4.many.small.qtl.H0.8.RRBLUP.csv",
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/many small qtl H0.8/Mean.5.fold.CV.PA.H4.many.small.qtl.H0.8.multiBLUP.csv"
)
file_paths_4 <- c(
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/Large qtl H0.2/Mean.5.fold.CV.PA.H4.Large qtl H0.2.GBLUP.csv",
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/Large qtl H0.2/Mean.5.fold.CV.PA.H4.Large qtl H0.2.multiBLUP.csv"
)
file_paths_5 <- c(
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/Large qtl H0.5/Mean.5.fold.CV.PA.H4.Large qtl H0.5.GBLUP.csv",
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/Large qtl H0.5/Mean.5.fold.CV.PA.H4.Large qtl H0.5.multiBLUP.csv"
)
file_paths_6 <- c(
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/Large qtl H0.8/Mean.5.fold.CV.PA.H4.Large qtl H0.8.GBLUP.csv",
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/Large qtl H0.8/Mean.5.fold.CV.PA.H4.Large qtl H0.8.multiBLUP.csv"
)
file_paths_7 <- c(
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/several medium qtl H0.2/Mean.5.fold.CV.PA.H4.many.small.qtl.H0.2.RRBLUP.csv",
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/several medium qtl H0.2/Mean.5.fold.CV.PA.H4.many.small.qtl.H0.2.multiBLUP.csv"
)
file_paths_8 <- c(
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/several medium qtl H0.5/Mean.5.fold.CV.PA.H4.several medium qtl H0.5.RRBLUP.csv",
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/several medium qtl H0.5/Mean.5.fold.CV.PA.H4.several medium qtl H0.5.multiBLUP.csv"
)
file_paths_9 <- c(
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/several medium qtl H0.8/Mean.5.fold.CV.PA.H4.several medium qtl H0.8.RRBLUP.csv",
  "C://Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/Simulated_Traits/several medium qtl H0.8/Mean.5.fold.CV.PA.H4.several medium qtl H0.8.multiBLUP.csv"
)

# Combine file paths into a list
all_file_paths <- list(file_paths_1, file_paths_2, file_paths_3, file_paths_4, file_paths_5, file_paths_6, file_paths_7, file_paths_8, file_paths_9)

# Create an empty data frame to store results
results_table <- data.frame(
  Scenario = character(),
  W_statistic = numeric(),
  P_value = numeric(),
  stringsAsFactors = FALSE
)

# Loop through each set of file paths
for (file_paths in all_file_paths) {
  
  # Read the CSV files (RRBLUP and multiBLUP)
  rrblup_data <- tryCatch({
    read_csv(file_paths[1])
  }, error = function(e) {
    message(paste("Error reading", file_paths[1], ":", e$message))
    return(NULL) # Return NULL if there's an error reading the file
  })
  
  multiblup_data <- tryCatch({
    read_csv(file_paths[2])
  }, error = function(e) {
    message(paste("Error reading", file_paths[2], ":", e$message))
    return(NULL) # Return NULL if there's an error reading the file
  })
  
  # Skip to next iteration if either file couldn't be read
  if (is.null(rrblup_data) || is.null(multiblup_data)) {
    next
  }
  
  # Ensure both data frames have the same number of rows
  if (nrow(rrblup_data) != nrow(multiblup_data)) {
    message(paste("Warning: Row count mismatch for", file_paths[1], "and", file_paths[2], ". Skipping this scenario."))
    next
  }
  
  # Find rows with NAs in either data frame
  na_rows_rrblup <- which(is.na(rrblup_data$Mean))
  na_rows_multiblup <- which(is.na(multiblup_data$Mean))
  
  # Find the union of rows with NAs in either data frame
  all_na_rows <- unique(c(na_rows_rrblup, na_rows_multiblup))
  
  # Remove rows with NAs from both data frames
  if (length(all_na_rows) > 0) {
    rrblup_data <- rrblup_data[-all_na_rows, ]
    multiblup_data <- multiblup_data[-all_na_rows, ]
  }
  
  # Extract the 'Mean' columns
  rrblup_means <- rrblup_data$Mean
  multiblup_means <- multiblup_data$Mean
  
  # Ensure the lengths are now the same
  if (length(rrblup_means) != length(multiblup_means)) {
    message(paste("Warning: Length mismatch after NA removal for", file_paths[1], "and", file_paths[2], ". Skipping this scenario."))
    next
  }
  
  # Perform the Wilcoxon signed-rank test
  wilcoxon_test <- wilcox.test(rrblup_means, multiblup_means, paired = TRUE)
  
  # Extract test results
  w_stat <- wilcoxon_test$statistic
  p_val <- wilcoxon_test$p.value
  
  # Determine scenario name based on file path
  scenario_name <- basename(dirname(file_paths[1])) # Extract the last directory name
  
  # Add results to the table
  results_table <- rbind(results_table, data.frame(
    Scenario = scenario_name,
    W_statistic = w_stat,
    P_value = p_val
  ))
}

# Print the results table
print(results_table)


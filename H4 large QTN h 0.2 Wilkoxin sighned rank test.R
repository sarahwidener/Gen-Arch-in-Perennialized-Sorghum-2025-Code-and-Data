
#H4 Large QTL heritability 0.2 GBLUP VS MultiBLUP wilkoxin sighned rank test

# Load necessary libraries
library(readr)
library(dplyr)

# Set working directory
setwd("/Users/sarahjw2/Box/Widener_Lipka_Shared_Folder/TLI/Genomic_Selection/H4/Simulation/")

# Read the CSV files
multiblup_data <- read_csv("Simulated_Traits/Large qtl H0.2/Mean.5.fold.CV.PA.H4.Large qtl H0.2.GBLUP.csv")
gblup_data <- read_csv("Simulated_Traits/Large qtl H0.2/Mean.5.fold.CV.PA.H4.Large qtl H0.2.multiBLUP.csv")

# Ensure both data frames have the same number of rows
if (nrow(multiblup_data) != nrow(gblup_data)) {
  stop("The number of rows in the two data frames must be the same.")
}

# Find rows with NAs in either data frame
na_rows_multiblup <- which(is.na(multiblup_data$Mean))
na_rows_gblup <- which(is.na(gblup_data$Mean))

# Find the union of rows with NAs in either data frame
all_na_rows <- unique(c(na_rows_multiblup, na_rows_gblup))

# Remove rows with NAs from both data frames
if (length(all_na_rows) > 0) {
  multiblup_data <- multiblup_data[-all_na_rows, ]
  gblup_data <- gblup_data[-all_na_rows, ]
}

# Extract the 'Mean' columns
multiblup_means <- multiblup_data$Mean
gblup_means <- gblup_data$Mean

# Ensure the lengths are now the same
if (length(multiblup_means) != length(gblup_means)) {
  stop("The lengths of the Mean vectors must be the same after removing NA values.")
}

# Perform the Wilcoxon signed-rank test
wilcoxon_test <- wilcox.test(multiblup_means, gblup_means, paired = TRUE)

# Print the test results
print(wilcoxon_test)

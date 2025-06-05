setRepositories(ind = 1:2)
devtools::install_github("samuelbfernandes/simplePHENOTYPES", build_vignettes = TRUE)

#initial install to run SNPRelate
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("SNPRelate")
BiocManager::install("gdsfmt")

nlibrary(mvtnorm, lqmm, data.table)





#example
setRepositories(ind = 1:2)
devtools::install_github("samuelbfernandes/simplePHENOTYPES", build_vignettes = TRUE)

#load data
library(simplePHENOTYPES)
data("SNP55K_maize282_maf04")
SNP55K_maize282_maf04[1:8, 1:10]

#single trait
create_phenotypes(
  geno_obj = SNP55K_maize282_maf04,
  add_QTN_num = 3,
  add_effect = 0.2,
  big_add_QTN_effect = 0.9,
  rep = 10,
  h2 = 0.7,
  model = "A",
  home_dir = tempdir())

#multi traits
test1 <-  create_phenotypes(
  geno_obj = SNP55K_maize282_maf04,
  add_QTN_num = 3,
  dom_QTN_num = 4,
  big_add_QTN_effect = c(0.3, 0.3, 0.3),
  h2 = c(0.2, 0.4, 0.4),
  add_effect = c(0.04,0.2,0.1),
  dom_effect = c(0.04,0.2,0.1),
  ntraits = 3,
  rep = 10,
  vary_QTN = FALSE,
  output_format = "multi-file",
  architecture = "pleiotropic",
  output_dir = "Results_Pleiotropic",
  to_r = TRUE,
  seed = 10,
  model = "AD",
  sim_method = "geometric",
  home_dir = tempdir()
)

custom_geometric_a <- list(trait_1 = c(0.04, 0.0016),
                           trait_2 = c(0.2, 0.04),
                           trait_3 = c(0.1, 0.01))
custom_geometric_d <- list(trait_1 = c(0.04, 0.0016, 6.4e-05, 2.56e-06),
                           trait_2 = c(0.2, 0.04, 0.008, 0.0016),
                           trait_3 = c(0.1, 0.01, 0.001, 1e-04))

test2 <-  create_phenotypes(
  geno_obj = SNP55K_maize282_maf04,
  add_QTN_num = 3,
  dom_QTN_num = 4,
  big_add_QTN_effect = c(0.3, 0.3, 0.3),
  h2 = c(0.2,0.4, 0.4),
  add_effect = custom_geometric_a,
  dom_effect = custom_geometric_d,
  ntraits = 3,
  rep = 10,
  vary_QTN = FALSE,
  output_format = "multi-file",
  architecture = "pleiotropic",
  output_dir = "Results_Pleiotropic",
  to_r = T,
  sim_method = "custom",
  seed = 10,
  model = "AD",
  home_dir = tempdir()
)

all.equal(test1, test2)


#PPA
cor_matrix <- matrix(c(   1, 0.3, -0.9,
                          0.3,   1,  -0.5,
                          -0.9, -0.5,    1 ), 3)

sim_results <- create_phenotypes(
  geno_obj = SNP55K_maize282_maf04,
  ntraits = 3,
  pleio_a = 3,
  pleio_e = 2,
  same_add_dom_QTN = TRUE,
  degree_of_dom = 0.5,
  trait_spec_a_QTN_num = c(4, 10, 1),
  trait_spec_e_QTN_num = c(3, 2, 5),
  h2 = c(0.2, 0.4, 0.8),
  add_effect = c(0.5, 0.33, 0.2),
  epi_effect = c(0.3, 0.3, 0.3),
  epi_interaction = 2,
  cor = cor_matrix,
  rep = 20,
  output_dir = "Results_Partially",
  output_format = "long",
  architecture = "partially",
  out_geno = "numeric",
  to_r = TRUE,
  model = "AE",
  home_dir = tempdir()
)

#SPA
create_phenotypes(
  geno_obj = SNP55K_maize282_maf04,
  add_QTN_num = 3,
  h2 = c(0.2, 0.4),
  add_effect = c(0.02, 0.05),
  rep = 5,
  seed = 200,
  output_format = "wide",
  architecture = "LD",
  output_dir = "Results_LD",
  out_geno = "plink",
  remove_QTN = TRUE,
  ld_max =0.8,
  ld_min =0.2,
  model = "A",
  ld_method = "composite",
  type_of_ld = "indirect",
  home_dir = tempdir()
)


#


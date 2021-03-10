
# Load packages -----------------------------------------------------------

library(loo, warn.conflicts = F)
library(readr, warn.conflicts = F)
library(magrittr, warn.conflicts = F)
library(tibble)
library(dplyr)
library(purrr)
library(stringr)

# Compare models by kfold IC ----------------------------------------------

# Grouping factor for splitting kfold-IC by model response
kfold_groups <-
  list.files("Results/model_kfold_IC/") %>%
  str_remove('_kfold.RDS') %>%
  str_split_fixed(., '_', 3) %>%
  .[,3] %>%
  unique()

# Paths to import model kfold IC values
kfold_paths <-
  list.files(path = "Results/model_kfold_IC", full.names = T) %>%
  setNames(str_remove(
    list.files("Results/model_kfold_IC/"),
    '_kfold.RDS')
  ) %>%
  # Ignore phylogeny-only, comparison is only relevant to intercept-only
  .[!grepl("phylo", .)]

# Import models with kfold IC
model_kfolds_comparison <-
  kfold_paths %>%
  map(readRDS) %>%
  split(kfold_groups) %>%
  # Compare kfold-IC among models
  map(loo::loo_compare) %>%
  map(~as_tibble(., rownames = 'Model')) %>%
  bind_rows()

# Save model kfold IC comparisons
write_tsv(model_kfolds_comparison, "Results/model_kfolds_comparison.tsv")




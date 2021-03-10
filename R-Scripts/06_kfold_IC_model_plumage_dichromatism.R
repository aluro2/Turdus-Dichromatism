
# Load packages -----------------------------------------------------------

library(brms, warn.conflicts = F)
library(readr, warn.conflicts = F)
library(magrittr, warn.conflicts = F)
library(stringr)
library(pbapply)
library(purrr)

# Get model paths ----------------------------------------------------------

model_paths <-
  list.files(path = "Results/Model_Posterior_Draws", full.names = T)

model_names <-
  list.files(path = "Results/Model_Posterior_Draws/") %>%
  str_remove(., ".RDS")

models <-
 pbapply::pblapply(model_paths,
         function(x){
           readRDS(x)
         }) %>%
  setNames(model_names)

# Add k-fold cross-folds to models ------------------------------------------

# This will only work on server with enough cores and RAM (used 8-cores, 64Gb
# RAM). Takes approx 7-8hrs to complete.

purrr::imap(
  models,
  function(x, n){
    model <- x
    save_name <- paste("Results/model_kfold_IC/", n, "_kfold.RDS", sep = "")
    kfold(
      x,
      K = 16,
      cores = 6
    ) %>%
      # Save models with kfold information criteria
      saveRDS(., file = save_name)
    message(paste("Model", n, "complete and saved!", sep = " "))
  }
)



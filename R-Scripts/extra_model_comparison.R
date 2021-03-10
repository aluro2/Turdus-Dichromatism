
# Load packages -----------------------------------------------------------

library(brms, warn.conflicts = F)
library(readr, warn.conflicts = F)
library(magrittr, warn.conflicts = F)
library(stringr)
library(pbapply)
library(purrr)

# Get model paths ----------------------------------------------------------

model_paths <-
  list.files(path = "Results/Model_Posterior_Draws", full.names = T) %>%
  setNames(str_remove(
    list.files("Results/Model_Posterior_Draws/"),
    '.RDS')
  )

model_groups <-
  list.files("Results/Model_Posterior_Draws/") %>%
  str_remove('.RDS') %>%
  str_split_fixed(., '_', 3) %>%
  .[,3] %>%
  unique()

models <-
  model_paths %>%
  furrr::future_map(readRDS, .progress = T)

 #######################
models[1:3] %>%
  map(bayes_R2)

test <-
  models %>%
    split(model_groups)

bayes_factor(test[1]$n_achromatic_patches_1$breeding_model_n_achromatic_patches_1,
             test[1]$n_achromatic_patches_1$sympatry_model_n_achromatic_patches_1)

##################




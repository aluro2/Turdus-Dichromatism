
# Load packages -----------------------------------------------------------
library(readr, warn.conflicts = F)
library(magrittr, warn.conflicts = F)
library(dplyr, warn.conflicts = F)
library(stringr, warn.conflicts = F)
library(purrr, warn.conflicts = F)
library(tidybayes, warn.conflicts = F)
library(pbapply)
library(brms)

# Import models  ----------------------------------------------------------

# Get paths to import models
model_paths <-
  list.files(path = "Results/Model_Posterior_Draws", full.names = T) %>%
  setNames(str_remove(
    list.files("Results/Model_Posterior_Draws/"),
    '.RDS')
  ) %>%
  # Ignore Intercept Only (null) and Phylogeny Only Models
  .[!grepl('null', names(.)) & !grepl('phylo', names(.))]

# Create grouping factor to separate models by responses
model_groups <-
  list.files("Results/Model_Posterior_Draws/") %>%
  str_remove('.RDS') %>%
  str_split_fixed(., '_', 3) %>%
  .[,3] %>%
  unique()

# Import models into a list and provide progress bar for time to completion
models <-
  pbapply::pblapply(model_paths,
                    function(x){
                      readRDS(x)
                    })

# Get (tidybayes) posterior draws for plotting ----------------------------
# fitted_vals <-
#   pbapply::pblapply(
#     models,
#     function(x)
#       add_fitted_draws(
#         newdata = x$data,
#         model = x,
#         scale = "response",
#         n = 3000,
#         seed = 8675309
#       ) %>%
#       data.table::as.data.table()
#   )
# 
# saveRDS(fitted_vals,
#         file = 'Figures/Figure_Data/fitted_vals.RDS')

# Get model draws and combine into single dataset
posterior_draws <-
  models %>%
  map(., ~gather_draws(., `^b_.*`, `sd_.*`, regex = TRUE)) %>%
  split(model_groups) %>%
  map(., ~bind_rows(.x, .id = 'Model')) %>%
  map(., ~ mutate(
    .x,
    'Plumage Metric' = if_else(str_detect(Model, '_achromatic'),  'Achromatic', 'Chromatic'),
    # JND threshold
    'JND Threshold' = case_when(
      str_detect(Model, '_1') ~ '1 JND',
      str_detect(Model, '_2') ~ '2 JND',
      str_detect(Model, '_3') ~ '3 JND'),
    Model = case_when(
      str_detect(Model, 'breeding') ~ 'Breeding Timing',
      str_detect(Model, 'landmass') ~ 'Breeding Spacing',
      str_detect(Model, 'sympatry') ~ 'Breeding Sympatry'
    ),
    Parameter =
      # Rename variables
      recode(.variable,
             b_Intercept = "Intercept",
             b_std_breeding_months = "Breeding Season Length",
             b_migratory_behaviorpartial = "Partial Migration vs. No Migration",
             b_migratory_behavioryes = "Full Migration vs. No Migration",
             `b_std_breeding_months:migratory_behaviorpartial` = "Breeding Season Length x Partial Migration",
             `b_std_breeding_months:migratory_behavioryes` = "Breeding Season Length x Full Migration",
             #sd_phylo__Intercept = "Phylogenetic Variation \n (Between-Species Standard-Deviation)",
             b_landmassisland = "Island vs. Mainland",
             b_ln_birdlifeintl_range_size_km2 = "Breeding Range Size",
             b_n_species_30 = "Number of Sympatric Species \n (≥ 30% Breeding Range Overlap)",
             sd_phylo__Intercept = "Phylogenetic Signal"
      ),
    Parameter = as_factor(Parameter)
  )
  ) %>%
  bind_rows() %>% 
  select(-.variable)

saveRDS(posterior_draws,
        file = 'Figures/Figure_Data/posterior_draws.RDS')

rm(models, posterior_draws)

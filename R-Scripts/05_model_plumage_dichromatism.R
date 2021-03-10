
# Load packages -----------------------------------------------------------
library(readr, warn.conflicts = F)
library(magrittr, warn.conflicts = F)
library(dplyr, warn.conflicts = F)
library(brms, warn.conflicts = F)
library(ggplot2, warn.conflicts = F)
library(tidybayes, warn.conflicts = F)
library(purrr)

# Import data and phylogenetic matrix-------------------------------------------------------------

model_data <-
  read_rds("Data/model_data.rds") %>%
  mutate(
    # natural-log transform breeding range sizes
    ln_birdlifeintl_range_size_km2 = log(birdlifeintl_range_size_km2),
    # center breeding months to reduce collinearity with migratory behavior
    std_breeding_months = scale(breeding_months)[, 1],
    obs = row_number(phylo)
  )

## Variance Inflation Factor (VIF) checks --
# Breeding model: Max VIF = 194 with unstandardized breeding_months
# car::vif(glm(n_achromatic_patches_1 ~ breeding_months*migratory_behavior, family =  binomial, data = model_data ))

# Breeding Model: Max VIF = 5 with standardized breeding_months
# car::vif(glm(n_achromatic_patches_1 ~ std_breeding_months*migratory_behavior, family =  binomial, data = model_data ))

# Landmass Model: Max VIF = 1.4
# car::vif(glm(n_achromatic_patches_1 ~ landmass * ln_birdlifeintl_range_size_km2, family =  binomial, data = model_data ))

# Sympatry Model: Max VIF  = 5.4
# car::vif(glm(n_chromatic_patches_1 ~ n_species_10 + n_species_20 + n_species_30, family =  binomial, data = model_data ))

phylo_mat <-
  read_rds("Data/phylo_mat.RDS")

# Model Formulas and Names ---------------------------------------------------------

responses <-
  c(
    "n_achromatic_patches_1",
    "n_achromatic_patches_2",
    "n_achromatic_patches_3",
    "n_chromatic_patches_1",
    "n_chromatic_patches_2",
    "n_chromatic_patches_3"
  )

formulas <-
  c(
    " | trials(5) ~ std_breeding_months*migratory_behavior + (1|phylo)",
    " | trials(5) ~ landmass + ln_birdlifeintl_range_size_km2 + (1|phylo)",
    " | trials(5) ~ n_species_30 + (1|phylo)"
  )

model_names <-
  c(
    "breeding_model",
    "landmass_model",
    "sympatry_model"
  ) %>%
  outer(., responses, paste, sep = "_") %>%
  as.vector() %>%
  sort()

model_formulas <-
  outer(responses, formulas, paste, sep = "") %>%
  as.list() %>%
  set_names(., model_names)

# Null Models
null_model_names <-
  c(
    "null_model",
    "phylo_model"
  ) %>%
  outer(., responses, paste, sep = "_") %>%
  as.vector() %>%
  sort()

null_formulas <-
  c(
    " | trials(5) ~ 1",
    " | trials(5) ~ 1 + (1|phylo) + (1|obs)"
  )

null_model_formulas <-
  outer(responses, null_formulas, paste, sep = "") %>%
  as.list() %>%
  set_names(., null_model_names)

## Combine all model formulas into single list
all_model_formulas <-
  c(model_formulas, null_model_formulas)

## Run brms models and save in Results/Model_Posterior_Draws

purrr::imap(all_model_formulas, function(y, n) {
  formula <- y
  save_name <- paste("Results/Model_Posterior_Draws/", n, ".RDS", sep = "")
  brm(
    formula,
    data = model_data,
    family = binomial(link = "logit"),
    cov_ranef = list(phylo = phylo_mat),
    iter = 6000,
    inits = "random",
    chains = 6,
    cores = 6,
    control = list(adapt_delta = 0.999, max_treedepth = 15, stepsize = 0.1),
    thin = 1,
    seed = 15,
    sample_prior = "yes", save_all_pars = TRUE
  ) %>%
    saveRDS(., file = save_name)
  message(paste("Model", n, "complete and saved!", sep = " "))
})

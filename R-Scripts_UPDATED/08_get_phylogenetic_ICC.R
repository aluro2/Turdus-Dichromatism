
# Load packages -----------------------------------------------------------
library(readr)
library(magrittr)
library(stringr)
library(dplyr)
library(tidyr)
library(pbapply)
library(furrr)
library(purrr)
library(performance)

# Get model paths ----------------------------------------------------------

model_paths <-
  list.files(path = "Results_UPDATED/Model_Posterior_Draws", full.names = T) %>%
  setNames(str_remove(
    list.files("Results_UPDATED/Model_Posterior_Draws/"),
    ".RDS"
  )) %>%
  # Ignore Intercept Only (null) and Phylogeny Only Models
  .[!grepl("phylo", names(.)) & !grepl("null", names(.))]

# Import models
models <-
  pbapply::pblapply(
    model_paths,
    function(x) {
      readRDS(x)
    }
  )

# Create grouping factor to separate models by responses
model_groups <-
  list.files("Results_UPDATED/Model_Posterior_Draws/") %>%
  str_remove('.RDS') %>%
  str_split_fixed(., '_', 3) %>%
  .[,3] %>%
  unique()


# brms phylogenetic signal, lambda ----------------------------------------
## Logistic dist. variance  =  (pi^2)/ 3 OR 3.289868
hyp <- paste("sd_phylo__Intercept^2 /", "(sd_phylo__Intercept^2 + 3.289868 = 0)")
phylosig <- brms::hypothesis(models$sympatry_model_n_chromatic_patches_1, hyp, class = NULL)

phylosig

plot(phylosig)

lambdas <-
  map(
    models,
    function(x){

      hyp <- paste("sd_phylo__Intercept^2 /", "(sd_phylo__Intercept^2 + 3.289868 = 0)")

      lambda_vals <- brms::hypothesis(x, hyp, class = NULL, alpha = 0.10)

      tibble("Phylogenetic Signal λ" = lambda_vals[[1]][[2]], CI_low= lambda_vals[[1]][[4]] , CI_high = lambda_vals[[1]][[5]])
    }
    #.progress = T
  ) %>%
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
    )
  )
  ) %>%
  bind_rows() %>%
  mutate_if(is.numeric, round, 2) %>%
  mutate(
    CI_low = paste("[", CI_low, sep = ""),
    CI_high = paste(CI_high, "]", sep = "")
  ) %>%
  unite(
    col = ".90_ci",
    CI_low,
    CI_high,
    sep = ", ") %>%
  unite(
    # trick to align values in Table 2
    col = "Posterior Median Log-Odds [90% Highest-Density Interval], Probability of Direction",
    `Phylogenetic Signal λ`,
    ".90_ci",
    sep = " "
  )  %>%
  mutate(
    Parameter = "Phylogenetic Signal λ, Median [90% Credible Interval]"
  ) %>%
  # Spread out estimates by response (Achromatic/Chromatic with JND Threshold)
  pivot_wider(
    id_cols = c(Model, Parameter),
    names_from = c(`Plumage Metric`,`JND Threshold`),
    values_from = `Posterior Median Log-Odds [90% Highest-Density Interval], Probability of Direction`,
    names_sep = ", "
  )

write_csv(
  lambdas,
  path = "Results_UPDATED/model_phylogenetic_signal_lambda.csv"
)

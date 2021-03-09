
# Load packages -----------------------------------------------------------
library(dplyr, warn.conflicts = F)
library(purrr, warn.conflicts = F)
#library(tidybayes, warn.conflicts = F)
library(brms)
library(bayestestR)
library(tidyr)
library(forcats)
library(flextable)
library(stringr)
library(pbapply)

# Get model paths ----------------------------------------------------------

model_paths <-
  list.files(path = "Results_UPDATED/Model_Posterior_Draws", full.names = T) %>%
  setNames(str_remove(
    list.files("Results_UPDATED/Model_Posterior_Draws/"),
    '.RDS')
  ) %>%
  # Ignore Intercept Only (null) and Phylogeny Only Models
  .[!grepl('null', names(.)) & !grepl('phylo', names(.))]

# Import models
models <-
  pbapply::pblapply(model_paths,
                    function(x){
                      readRDS(x)
                    })


# Get posterior medians, credible intervals and PDs-------

posterior_summary_data <-
  purrr::imap(
    models,
    function(x, n){
      # Get posteriors from models
      posterior_samples(
        x,
        pars = c("^b_.*", "^sd_phylo*"),
        fixed = FALSE) %>%
        # Get posterior medians, HDIs and PDs
        describe_posterior(
          centrality = "median",
          dispersion = FALSE,
          ci = 0.90,
          ci_method = "HDI",
          test = "pd"
        )  %>%
        as_tibble() %>%
        # Round all values to 2 decimal places
        mutate_if(is.numeric, round, 2) %>%
        # Ignore phylogenetic stdev of intercept, this will always be positive
        filter(., !Parameter == "sd_phylo__Intercept") %>%
        # Add model identifiers, response IDs and change predictor names
        mutate(
          'Plumage Metric' = if_else(str_detect(n, '_achromatic'),  'Achromatic', 'Chromatic'),
          # JND threshold
          'JND Threshold' = case_when(
            str_detect(n, '_1') ~ '1 JND',
            str_detect(n, '_2') ~ '2 JND',
            str_detect(n, '_3') ~ '3 JND'),
          Model = case_when(
            str_detect(n, 'breeding') ~ 'Breeding Timing',
            str_detect(n, 'landmass') ~ 'Breeding Spacing',
            str_detect(n, 'sympatry') ~ 'Breeding Sympatry'
          ),
          Parameter =
            # Rename variables
            recode(Parameter,
                   b_Intercept = "Intercept",
                   b_std_breeding_months = "Breeding Season Length",
                   b_migratory_behaviorpartial = "Partial Migration vs. No Migration",
                   b_migratory_behavioryes = "Full Migration vs. No Migration",
                   `b_std_breeding_months:migratory_behaviorpartial` = "Breeding Season Length x Partial Migration",
                   `b_std_breeding_months:migratory_behavioryes` = "Breeding Season Length x Full Migration",
                   #sd_phylo__Intercept = "Phylogenetic Variation \n (Between-Species Standard-Deviation)",
                   b_landmassisland = "Island vs. Mainland",
                   b_ln_birdlifeintl_range_size_km2 = "Breeding Range Size",
                   b_n_species_30 = "Number of Sympatric Species \n (≥ 30% Breeding Range Overlap)"
            )
        ) %>%
        # Reorder datasets
        select(Model, `Plumage Metric`, `JND Threshold`, Parameter, everything(), -CI)
    }
  ) %>%
  # Combine all model posterior summaries into single df
  map_df(., bind_rows)

####################################

typology <-
  data.frame(
    col_keys = c(
      "Model",
      "Plumage Metric",
      "JND Threshold",
      "Parameter",
      "Median",
      "CI_low",
      "CI_high",
      "pd"
    ),
    type = c(
      "Model",
      "Response",
      "Response",
      "Parameter",
      "Median",
      "90% HDI",
      "90% HDI",
      "Probability of Direction"
    ),
    stringsAsFactors = FALSE )

############ TABLE ##################
  posterior_summary_data %>%
  as_grouped_data(
    groups = c("Model", "Plumage Metric", "JND Threshold")
  ) %>%
  qflextable() %>%
  colformat_num(na_str = "") %>%
    set_header_df(., mapping = typology, key = "col_keys") %>%
    merge_h(part = "header") %>%
    merge_v(part = "header") %>%
    empty_blanks() %>%
  theme_booktabs()



# Table ----------------------------------------------------------------

# Table header labels

typology <-
  data.frame(
    col_keys = c(
      "Model",
      "Parameter",
      "Achromatic, 1 JND",
      "Achromatic, 2 JND",
      "Achromatic, 3 JND",
      "Chromatic, 1 JND",
      "Chromatic, 2 JND",
      "Chromatic, 3 JND"
    ),
    type = c(
      "Model",
      "Parameter",
      rep("Response Posterior Median [90% Highest-Density Interval], Probability of Direction", 6)
    ),
    what = c(
      "",
      "",
      rep("Achromatic", 3),
      rep("Chromatic", 3)
    ),
    measure = c(
      "",
      "",
      rep(c("1 JND", "2 JND", "3 JND"), 2)
    ),
    stringsAsFactors = FALSE )

# Create, display and save table
posterior_summary_data %>%
  # Group data
  as_grouped_data(
    groups = c("Model")
  ) %>%
  qflextable() %>%

  theme_booktabs() #%>%
  bold(., part = "header") %>%
  align(
    align = "left",
    part = "all"
  ) %>%
  fontsize(
    size = 10,
    part = "body"
  ) %>%
  set_table_properties(., width = 1, layout = "autofit")



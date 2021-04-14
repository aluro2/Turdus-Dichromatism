
# Load packages and model data --------------------------------------------

library(tidyverse)
library(kableExtra)


model_kfolds <-
  read_tsv("Results/model_kfolds_comparison.tsv") %>%
  # Rounds all values to 3 digits
  mutate_if(is.numeric, round, 2) %>%
  # Combine values with stderrors
  mutate(
    'ELPD Difference ± SE' = paste(elpd_diff, "±", se_diff),
    'kfold IC ± SE' = paste(elpd_kfold, "±", se_elpd_kfold),
    'ELPD Difference ± SE (kfold IC ± SE)' = paste(
      `ELPD Difference ± SE`, ' (', `kfold IC ± SE`, ')', sep =""),
    # Plumage reponse
    'Plumage Metric' = if_else(str_detect(Model, '_achromatic'),  'Achromatic', 'Chromatic'),
    # JND threshold
    'JND Threshold' = case_when(
      str_detect(Model, '_1') ~ '1 JND',
      str_detect(Model, '_2') ~ '2 JND',
      str_detect(Model, '_3') ~ '3 JND'),
    # Provide explicit model predictor names
    'Model Predictors' = case_when(
      str_detect(Model, 'breeding') ~ 'Breeding Season Length + Migratory Behavior + (Breeding Season Length x Migratory Behavior)',
      str_detect(Model, 'landmass') ~ 'Landmass + Breeding Range (km2)',
      str_detect(Model, 'sympatry') ~ 'Number of Sympatric Species with 10% Range Overlap + Number of Sympatric Species with 20% Range Overlap + Number of Sympatric Species with 30% Range Overlap'
    ),
    # Model Names
    Model = case_when(
      str_detect(Model, 'breeding') ~ 'Breeding Timing',
      str_detect(Model, 'landmass') ~ 'Breeding Spacing',
      str_detect(Model, 'sympatry') ~ 'Breeding Sympatry',
      str_detect(Model, 'phylo') ~ 'Phylogeny Only',
      str_detect(Model, 'null') ~ 'Intercept Only'
    )
  ) %>%
  # Get rid of unused columns
  select(
    `Model`,
    `Plumage Metric`,
    `JND Threshold`,
    `ELPD Difference ± SE (kfold IC ± SE)`) %>%
  pivot_wider(id_cols = c(`Plumage Metric`, `JND Threshold`),
              names_from  = Model,
              values_from = `ELPD Difference ± SE (kfold IC ± SE)`) %>% 
  mutate(`Plumage Metric` = "")


knitr::kable(model_kfolds, format = "latex", booktabs = T, linesep = "\\addlinespace") %>%
add_header_above(c("", "","Model" = 4), align = "l") %>% 
  kable_styling(latex_options = "scale_down", font_size = 14) %>% 
  pack_rows("Achromatic", 1, 3) %>% 
  pack_rows("Chromatic", 4, 6) %>% 
  write_file(path = "Figures/Table_01_model_kfold_comparison.tex")




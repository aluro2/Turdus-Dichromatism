
# Load packages -----------------------------------------------------------

library(flextable, warn.conflicts = F)
library(readr, warn.conflicts = F)
library(magrittr, warn.conflicts = F)
library(tibble)
library(tidyr)
library(dplyr)
library(stringr)

# Import kfold IC model comparison tables ---------------------------------

model_kfolds <-
  read_tsv("Results/model_kfolds_comparison.tsv")

# Make pdf tables ---------------------------------------------------------

table_data <-
  model_kfolds %>%
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
  pivot_wider(
    id_cols = Model,
    names_from = c(`Plumage Metric`,`JND Threshold`),
    values_from = `ELPD Difference ± SE (kfold IC ± SE)`,
    names_sep = ", "
  )

# Make (flex)table --------------------------------------------------------

# Table header labels

typology <-
  data.frame(
    col_keys = c(
      "Model",
      "Achromatic, 1 JND",
      "Achromatic, 2 JND",
      "Achromatic, 3 JND",
      "Chromatic, 1 JND",
      "Chromatic, 2 JND",
      "Chromatic, 3 JND"
    ),
    type = c(
      "Model",
      rep("ELPD Difference ± SE (kfold IC ± SE)", 6)
    ),
    what = c(
      "Model",
      rep("Achromatic", 3),
      rep("Chromatic", 3)
    ),
    measure = c(
      "Model",
      c("1 JND", "2 JND", "3 JND"),
      c("1 JND", "2 JND", "3 JND")
    ),
    stringsAsFactors = FALSE )

table_data %>%
# Group data
  as_grouped_data(
    groups = "Model",
    ) %>%
  qflextable(.) %>%
  set_header_df(., mapping = typology, key = "col_keys") %>%
  merge_h(part = "header") %>%
  merge_v(part = "header") %>%
  empty_blanks() %>%
  theme_booktabs() %>%
  bold(., part = "header") %>%
  ## Bolden best models by ELPD difference, all 0 or < -2
  # Breeding Sympatry
  bold(
    i = 2,
    j = 1:7
  ) %>%
  # Breeding Timing
  bold(
    i = 4,
    j = 3:4
  ) %>%
  # Breeding Spacing
  bold(
    i = 6,
    j = 3:4
    ) %>%
  ## Format table
  fontsize(
    part = "header",
    size = 11
  ) %>%
  fontsize(
    part = "body",
    size = 10
  ) %>%
  align(
    align = "left",
    part = "all"
  ) %>%
  set_table_properties(., width = 1, layout = "autofit") %>%
  # Export as .docx file
  save_as_html(
    path = "Figures/Table_01_model_kfold_comparison.html"
  )

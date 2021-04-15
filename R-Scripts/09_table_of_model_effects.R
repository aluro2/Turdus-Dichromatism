
# Load packages -----------------------------------------------------------
library(dplyr, warn.conflicts = F)
library(readr)
library(purrr, warn.conflicts = F)
library(brms)
library(bayestestR)
library(tidyr)
library(forcats)
library(flextable)
library(stringr)
library(pbapply)

# Get model paths ----------------------------------------------------------

model_paths <-
  list.files(path = "Results/Model_Posterior_Draws", full.names = T) %>%
  setNames(str_remove(
    list.files("Results/Model_Posterior_Draws/"),
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
            ),
          pd = ifelse(pd==1, 0.99, pd)
        ) %>%
        # Reorder datasets
        select(Model, `Plumage Metric`, `JND Threshold`, Parameter, everything(), -CI)
    }
  ) %>%
    # Combine all model posterior summaries into single df
    map_df(., bind_rows)


####################################

table_data <-
  posterior_summary_data %>%
  mutate(
    CI_low = paste("(", CI_low, sep = ""),
    CI_high = paste(CI_high, ")", sep = ""),
    pd = paste(", pd = ", pd, sep = "")
  ) %>%
  unite(
    col = ".90_ci",
    CI_low,
    CI_high,
    sep = ", ") %>%
  unite(
    col = "median.90_ci",
    Median,
    ".90_ci",
    sep = " "
  )  %>%
  unite(
    col = "Posterior Median Log-Odds (90% Highest-Density Interval), Probability of Direction",
    median.90_ci,
    pd,
    sep = ""
    ) %>%
# Spread out estimates by response (Achromatic/Chromatic with JND Threshold)
  pivot_wider(
    id_cols = c(Model, Parameter),
    names_from = c(`Plumage Metric`,`JND Threshold`),
    values_from = `Posterior Median Log-Odds (90% Highest-Density Interval), Probability of Direction`,
    names_sep = ", "
  ) %>%
  # Include phylogenetic signal of models
  bind_rows(.,
            read_csv("Results/model_phylogenetic_signal_lambda.csv")) %>%
  # Rearrange so phylogenetic signal is last for each model/response
  group_by(Model) %>%
  group_split() %>%
  bind_rows() %>%
  arrange(fct_relevel(Model, c('Breeding Timing','Breeding Spacing','Breeding Sympatry')))

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
    rep("Posterior Median Log-Odds (90% Highest-Density Interval), Probability of Direction", 6)
    ),
  what = c(
    "Model",
    "Parameter",
    rep("Achromatic", 3),
    rep("Chromatic", 3)
  ),
  measure = c(
    "Model",
    "Parameter",
    c("1 JND", "2 JND", "3 JND"),
    c("1 JND", "2 JND", "3 JND")
  ),
  stringsAsFactors = FALSE )

# Create, display, and save table --------------
table_data %>%
  # Group data
  as_grouped_data(
    groups = "Model"
  ) %>%
  qflextable() %>%
  set_header_df(., mapping = typology, key = "col_keys") %>%
  merge_h(part = "header") %>%
  merge_v(part = "header") %>%
  empty_blanks() %>%
  theme_booktabs() %>%
  #vline( j = 5, part = "body", border = officer::fp_border(color = "black")) %>%
  bold(., part = "header") %>%
  align(
    align = "left",
    part = "all"
  ) %>%
  # Breeding Season Length
  color(
    i = 3,
    j = c(4, 5, 7),
    color = "red"
  ) %>%
  bold(
    i = 3,
    j = c(4, 5, 7),
  ) %>%
  footnote(
    i = 3,
    j = 2,
    value = as_paragraph(
      "Length of breeding season in months"
    ),
    ref_symbols = "1",
    part = "body"
  ) %>%
  # Partial Migration
  color(
    i = 4,
    j = c(6, 8),
    color = "blue"
  ) %>%
  bold(
    i = 4,
    j = c(6, 8),
  ) %>%
  footnote(
    i = 4,
    j = 2,
    value = as_paragraph(
      "Altitudinal migration and localized movements during non-breeding season"
    ),
    ref_symbols = "2",
    part = "body"
  ) %>%
  # Full Migration
  color(
    i = 5,
    j = c(3:5, 7:8),
    color = "blue"
  ) %>%
  bold(
    i = 5,
    j = c(3:5, 7:8),
  ) %>%
  footnote(
    i = 5,
    j = 2,
    value = as_paragraph(
      "Consistent long-distance migration to and from breeding grounds"
    ),
    ref_symbols = "3",
    part = "body"
  ) %>%
  # Breeding Season Length x Partial Migration
  color(
    i = 6,
    j = c(4:5, 7),
    color = "blue"
  ) %>%
  bold(
    i = 6,
    j = c(4:5, 7),
  ) %>%
  # Breeding Season Length x Full Migration
  color(
    i = 7,
    j = c(3:4, 7),
    color = "blue"
  ) %>%
  bold(
    i = 7,
    j = c(3:4, 7),
  ) %>%
  # Island vs. Mainland
  color(
    i = 11,
    j = 6,
    color = "red"
  ) %>%
  bold(
    i = 11,
    j = 6,
  ) %>%
  # Breeding Range Size
  footnote(
    i = 11,
    j = 2,
    value = as_paragraph(
      "Natural-log transformed square kilometers"
    ),
    ref_symbols = "4",
    part = "body"
  ) %>%
  # Number of Sympatric Species
  color(
    i = 16,
    j = 6:8,
    color = "blue"
  ) %>%
  bold(
    i = 16,
    j = 6:8,
  ) %>%
  ### TABLE FORMATTING
  fontsize(
    size = 10,
    part = "body"
  ) %>%
  # FootNotes

# Create, display, and save table -----------------------------------------


  set_table_properties(., width = 1, layout = "autofit") %>%
  #fit_to_width(max_width = 11) #%>%
  # Export as .docx file
  save_as_pptx(
    path = "Figures/Table_02_model_effects.pptx"
  )


# Kable-style table -------------------------------------------------------
table_data %>% 
  mutate(Model = "") %>% 
  # # Coloring function for pd >=0.9
  # mutate(across(`Achromatic, 1 JND`:`Chromatic, 3 JND`,
  #      ~cell_spec(.x, format = "latex", color = if_else(
  #        str_detect(.x, "pd") &
  #          str_detect(.x, "^-.*$") &
  #          str_detect(.x, "0.9"),
  #        "red", if_else(
  #          str_detect(.x, "pd") &
  #            !str_detect(.x, "^-.*$") &
  #            str_detect(.x, "0.9"),
  #          "blue", ifelse(
  #            !str_detect(.x, "pd") |
  #              !str_detect(.x, "0.9"),
  #            "black", .x
  #          )))))) %>%
#Bolding function
# mutate(across(`Achromatic, 1 JND`:`Chromatic, 3 JND`,
#               ~cell_spec(.x, format = "latex", bold = if_else(
#                 str_detect(.x, "pd") &
#                   str_detect(.x, "0.9"),
#                 TRUE,
#                 FALSE)))) %>%
  knitr::kable(., format = "latex", booktabs = T, linesep = "\\addlinespace",
               caption = "Model predictor effect estimates (posterior median log-odds) on the
  number of achromatic and chromatic plumage patches with visual contrast values >
  1, 2, and 3 JND. Model effects with a probability of direction (pd) value ≥ 0.90
  are bolded in red for a negative effect and blue for a positive effect on
  plumage dichromatism.", 
               label = "table02",
               escape = F) %>%
    kable_styling(latex_options = "scale_down") %>% 
    group_rows(group_label = "Breeding Timing",
               start_row = 1,
               end_row = 8,
               colnum = 1,
               underline =  FALSE,
               indent = F) %>% 
  group_rows(group_label = "Breeding Spacing",
             start_row = 8,
             end_row = 11,
             colnum = 1,
             underline = FALSE) %>% 
  group_rows(group_label = "Breeding Sympatry",
             start_row = 12,
             end_row = 14,
             colnum = 1,
             underline = FALSE) %>% 
write_file(path = "Figures/Table_02_model_effects.tex")


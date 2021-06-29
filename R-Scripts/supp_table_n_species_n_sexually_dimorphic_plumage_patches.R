library(tidyverse)
library(gtsummary)

# Import JND data, generated from R-Scripts/analyze_within_species_between_sex_JNDs.R
jnds_data <-
  read_rds("Data/turdus_plumage_jnds_btw_sexes.RDS") %>%
  ungroup(.) %>%
  # Fix species scientific names to match names on phylogeny tips
  mutate(.,
         species = recode(species, "Turdus_rubripes" = "Turdus_plumbeus_rubripes"),
         species = recode(species, "Turdus_schistaceus" = "Turdus_plumbeus_schistaceus"),
         species = recode(species, "Turdus_plumbeus" = "Turdus_plumbeus_plumbeus"),
         species = recode(species, "Turdus_anthracinus" = "Turdus_chiguanco_anthracinus"),
         species = recode(species, "Turdus_confinis" = "Turdus_migratorius_confinis"),
         species = recode(species, "Turdus_gouldi" = "Turdus_rubrocanus_gouldi"),
         # species = recode(species, "Turdus_rubrocanus" = "Turdus_rubrocanus_rubrocanus"),
         species = recode(species, "Turdus_libonyanus" = "Turdus_libonyana")
  ) %>%
  group_by(species, patch) %>%
  # Averaging within species is done in
  # R-Scripts/analyze_within_species_between_sex_JNDs.R. Get number of chromatic
  # (dS) and achromatic (dL) perceivably-different plumage patches, setting JND
  # thresholds of 1, 2, or 3
  mutate(.,
         dS_threshold_1 = ifelse(mean_dS > 1, 1, 0),
         dS_threshold_2 = ifelse(mean_dS > 2, 1, 0),
         dS_threshold_3 = ifelse(mean_dS > 3, 1, 0),
         dL_threshold_1 = ifelse(mean_dL > 1, 1, 0),
         dL_threshold_2 = ifelse(mean_dL > 2, 1, 0),
         dL_threshold_3 = ifelse(mean_dL > 3, 1, 0)
  ) %>%
  group_by(species) %>%
  summarise(
    n_chromatic_patches_1 = as.integer(sum(dS_threshold_1)),
    n_chromatic_patches_2 = as.integer(sum(dS_threshold_2)),
    n_chromatic_patches_3 = as.integer(sum(dS_threshold_3)),
    n_achromatic_patches_1 = as.integer(sum(dL_threshold_1)),
    n_achromatic_patches_2 = as.integer(sum(dL_threshold_2)),
    n_achromatic_patches_3 = as.integer(sum(dL_threshold_3))
  )

jnds_data %>% 
  select(-species) %>% 
  pivot_longer(everything()) %>% 
  mutate(name = str_remove(name, "n_"),
         name = str_remove(name, "_patches")) %>% 
  separate(name, c("JND Type", "Threshold")) %>% 
  mutate(`JND Type` = str_to_title(`JND Type`),
         Threshold = paste(">", Threshold, "JND", sep = " ")) %>% 
  unite("JND Threshold", 1:2, sep = " ") %>% 
  rename("Number of Sexually-Dimorphic Plumage Patches" = value) %>% 
  gtsummary::tbl_summary(by = `JND Threshold`) %>% 
  as_gt() %>% 
  gt::gtsave(filename = "Figures/supp_00_n_species_n_dimorphic_patches.png")
  # LaTeX
  #as_latex()
  # Pandoc (.md)
  #as_kable
gtsummary::tbl_summary(jnds_data)

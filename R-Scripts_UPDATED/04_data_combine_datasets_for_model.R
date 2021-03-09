
# Load packages -----------------------------------------------------------
#library(tidyverse)
library(readr, warn.conflicts = F)
library(tidyr)
library(magrittr, warn.conflicts = F)
library(dplyr, warn.conflicts = F)
library(stringr, warn.conflicts = F)
library(ape, warn.conflicts = F)
library(phytools, warn.conflicts = F)


# Import data -------------------------------------------------------------

# Life history data. Gathered from Clement, P., & Hathway, R. (2010). Thrushes.
# Bloomsbury Publishing and Handbook of the Birds of the World
lifehistory_data <-
  read_csv("Data_UPDATED/life_history_data.csv")

# Import sympatry/range data generated from R-Scripts/analyze_range_sympatry.R
# Range and sympatry data from BirdLife International breeding range maps
sympatry_data <-
  read_csv("Data_UPDATED/sympatry_data_UPDATED.csv") %>%
  select(species = species_1, everything()) %>%
  mutate(species = str_replace(species, " ", "_")) %>%
  # Fix species scientific names to match names on phylogeny tips
  mutate(.,
         species = recode(species, "Turdus_rubripes" = "Turdus_plumbeus_rubripes"),
         species = recode(species, "Turdus_schistaceus" = "Turdus_plumbeus_schistaceus"),
         species = recode(species, "Turdus_plumbeus" = "Turdus_plumbeus_plumbeus"),
         species = recode(species, "Turdus_anthracinus" = "Turdus_chiguanco_anthracinus"),
         species = recode(species, "Turdus_confinis" = "Turdus_migratorius_confinis"),
         species = recode(species, "Turdus_gouldi" = "Turdus_rubrocanus_gouldi"),
         # species = recode(species, "Turdus_rubrocanus" = "Turdus_rubrocanus_rubrocanus"),
         species = recode(species, "Turdus_libonyanus" = "Turdus_libonyana"),
         species = recode(species, "Otocichla_mupinensis" = "Turdus_mupinensis"),
         species = recode(species, "Psophocichla_litsitsirupa" = "Turdus_litsitsirupa")
  )

# Import JND data, generated from R-Scripts/analyze_within_species_between_sex_JNDs.R
jnds_data <-
  read_rds("Data_UPDATED/turdus_plumage_jnds_btw_sexes.RDS") %>%
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


# Combine data into single dataset ----------------------------------------

comb_dat <-
  jnds_data %>%
  ungroup(.) %>%
  left_join(., lifehistory_data, by = "species", copy = T) %>%
  left_join(., sympatry_data, by = "species", copy = T) %>%
  # filter(., !species %in% "Turdus_rubrocanus") %>%
  mutate(.,
         species = recode(species, "Turdus_libonyana" = "Turdus_libonyanus"),
         species = recode(species, "Turdus_rubrocanus_rubrocanus" = "Turdus_rubrocanus")
  ) %>%
  rename(phylo = species) %>%
  select(phylo, everything())

# Match data with phylogeny -------------------------------------------------------------

# Import phylogeny of Nylander et al. (2008) Accounting for phylogenetic
# uncertainty in biogeography: a Bayesian approach to dispersal-vicariance
# analysis of the thrushes (Aves: Turdus). Systematic Biology, 57(2), 257-268.
# Phylogeny has been modified to include "subspecies" as sister species to their
# presumed main species.
phylo <-
  read.nexus("Phylogenies/turdus_phylo.nex")  %>%
  drop.tip(., "Turdus_poliocephalus_layardi")

# Get a phylogentic matrix, using Ornstein-Uhlenbeck model

phylo_mat <-
  vcvPhylo(
    tree = phylo,
    anc.nodes = F,
    model = "BM"
  )

saveRDS(phylo_mat, "Data_UPDATED/phylo_mat.RDS")

# Phylogeny tip names to match with dataset species names
tips <-
  phylo$tip.label

##mod_species <- unique(readRDS("/home/hauber_lab/Alec/brms_model_outputs/sympatry_model_dS.rds")$data$phylo)
# Get final dataset for model, making sure phylogeny matches up with data
model_data <-
  comb_dat %>%
  # Keep only species present in the phylogeny
  filter(., phylo %in% tips) %>%
  # Make nonmigratory behavior the reference category for migratory behavior and
  # mainland range the reference for landmass
  mutate(migratory_behavior = relevel(as.factor(migratory_behavior), ref = "no"),
         landmass = relevel(as.factor(landmass), ref = "mainland")) %>%
  # Scale and center numeric predictor vars
  mutate(
    breeding_months = as.integer(breeding_months),
    n_species_10 = as.integer(n_species_10),
    n_species_15 = as.integer(n_species_15),
    n_species_20 = as.integer(n_species_20),
    n_species_25 = as.integer(n_species_25),
    n_species_30 = as.integer(n_species_30),
    n_species_35 = as.integer(n_species_25),
    n_species_50 = as.integer(n_species_50),
    n_species_75 = as.integer(n_species_75),
    n_species_90 = as.integer(n_species_90)
    ) %>%
  drop_na()

## Double-check for matches/non-matches between phylogeny and data
tips %>%
  as.data.frame(.) %>%
  rename(., "phylo" = ".") %>%
  mutate(., phylo = as.character(phylo)) %>%
  # Return any mismatches between phylogeny tips and species names' in dataset
  anti_join(., model_data, by = names(.)[1])


saveRDS(model_data, "Data_UPDATED/model_data.rds")

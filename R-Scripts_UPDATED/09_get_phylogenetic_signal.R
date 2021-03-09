
library(readr)
library(dplyr)
library(tibble)
library(magrittr)
library(stringr)
library(ape)
library(phytools)
library(phylosignal)

# Import model data
model_data <-
  read_rds("Data_UPDATED/model_data.rds") %>%
  mutate(
    # natural-log transform breeding range sizes
    ln_birdlifeintl_range_size_km2 = log(birdlifeintl_range_size_km2),
    # center breeding months to reduce collinearity with migratory behavior
    std_breeding_months = scale(breeding_months)[, 1],
  )

# Import phylogeny and trim tips to match model data
phylo <-
  read.nexus("Phylogenies/turdus_phylo.nex")  %>%
  drop.tip(., c("Turdus_poliocephalus_layardi",
           "Turdus_maranonicus",
           "Turdus_rubrocanus_gouldi",
           "Turdus_plumbeus_schistaceus",
           "Turdus_migratorius_confinis")
  )
# Drop node labels
phylo$node.label <- NULL

# Get phylogeny tip names
tips <-
  phylo$tip.label

tips %>%
  as.data.frame(.) %>%
  rename(., "phylo" = ".") %>%
  mutate(., phylo = as.character(phylo)) %>%
  # Return any mismatches between phylogeny tips and species names' in dataset
  anti_join(., model_data, by = names(.)[1])

# Reorder model data by order of phylogeny tips
phylosig_data <-
  model_data[match(tips, model_data$"phylo"),] %>%
  data.frame(row.names = .$phylo) %>%
  select(
    n_chromatic_patches_1:n_achromatic_patches_3
  )


# Phylogenetic signal, phytools
phylosig(phylo, phylosig_data$n_chromatic_patches_2, method = "lambda", test = T)


# Phylogenetic signal, phylosignal package
p4d <-
  phylobase::phylo4d(phylo,
                     tip.data = phylosig_data,
                     rownamesAsLabels = T)

phylogenetic_signal <-
  phylosignal::phyloSignal(
  p4d
) %>%
  as.data.frame() %>%
  rownames_to_column("trait") %>%
  mutate_if(., is.numeric, round, 2) %>%
  mutate(
    'Plumage Metric' = if_else(str_detect(trait, '_achromatic'),  'Achromatic', 'Chromatic'),
    # JND threshold
    'JND Threshold' = case_when(
      str_detect(trait, '_1') ~ '1 JND',
      str_detect(trait, '_2') ~ '2 JND',
      str_detect(trait, '_3') ~ '3 JND')
  ) %>%
  select(-trait)

write_csv(
  phylogenetic_signal,
  path = "Results_UPDATED/trait_phylogenetic_signals.csv"
)


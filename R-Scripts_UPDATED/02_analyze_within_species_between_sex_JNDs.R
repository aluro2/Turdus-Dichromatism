
# Load packages -----------------------------------------------------------

# Load packages quietly
library(readr, warn.conflicts = F, verbose = F, quietly = T)
library(magrittr, warn.conflicts = F, verbose = F, quietly = T)
library(dplyr, warn.conflicts = F, verbose = F, quietly = T)
library(tidyr, warn.conflicts = F, verbose = F, quietly = T)
suppressPackageStartupMessages(library(pavo, warn.conflicts = F, verbose = F, quietly = T))
library(stringr, warn.conflicts = F, verbose = F, quietly = T)
library(pbapply)


# Import reflectance spectra ----------------------------------------------

reflectance_spectra <-
  readRDS("Data_UPDATED/reflectance_spectra.RDS")

# Receptor-Noise Limited Modelling of plumage dichromatism  ---------------
# Using Turdus merula visual system (Hart et al. 2000, doi: 10.1007/s003590050437)

vismod_data <-
  function(specs) {
    blackbird_sensmod <-
      sensmodel(
        peaksens = c(373, 454, 504, 557),
        lambdacut = c(330, 414, 514, 570),
        oiltype = c("T", "C", "Y", "R"),
        beta = T,
        om = F
      )

    blackbird_doublecone <-
      sensmodel(
        peaksens = 557,
        lambdacut = 439,
        oiltype = "P",
        beta = T,
        om = F
      )

    bb_dc <-
      blackbird_doublecone$lmax557

    specs %>%
        vismodel(.,
          visual = blackbird_sensmod,
          achromatic = bb_dc,
          illum = "D65",
          qcatch = "Qi",
          bkg = "ideal",
          trans = "blackbird",
          relative = F,
          vonkries = F
        )
  }

# Get cone catch data for all plumage reflectance spectra
vismod_data <-
  vismod_data(reflectance_spectra)

message("IGNORE WARNING: used default Turdus merula ocular media transmission, 'blackbird'.
        Warning message is a bug in pavo package.")

# Remove reflectance spectra from environment as it is no longer needed
rm(reflectance_spectra)

# Get species IDs to run JND calculations only within species to save time
vismod_species_ID <-
  do.call(rbind, strsplit(rownames(vismod_data), "\\."))[, 1]

# Split data into list by species
split_vismod_data <-
  vismod_data %>%
  split(., vismod_species_ID)

# Receptor-Noise Limited Models  ------------------------------------------

jnds <-
  pblapply(
    split_vismod_data,
    function(x) {
      ## weber fractions from  from Olsson et al. (2018) 10.1093/beheco/arx133,
      ## chromatic average for birds, weber.achro from Melopsittacus undulatus for
      ## brightness disc
      suppressMessages(
        coldist(x,
          noise = "neural",
          qcatch = "Qi",
          n = c(1, 1.78, 2.21, 1.96),
          achromatic = T,
          weber = 0.1,
          weber.ref = "longest",
          weber.achro = 0.18
        )
      )
    }
  )

message(
  "With-species between-sex Just Noticeable Differences (JNDS) calculated using Turdus merula visual system."
)

# Get only JNDs between sexes of same species --------------------------------------

jnds_patches_within_sp_btw_sexes <-
  jnds %>%
  bind_rows() %>%
  # Make new identity columns for species-species, sex-sex and patch-patch JND comparison
  separate(., "patch1", c("species1", "sex1", "patch1")) %>%
  separate(., "patch2", c("species2", "sex2", "patch2")) %>%
  # Rename identity columns' values
  mutate(.,
    indiv1 = str_extract(sex1, "\\-*\\d+\\.*\\d*"),
    indiv2 = str_extract(sex2, "\\-*\\d+\\.*\\d*"),
    sex1 = if_else(str_detect(sex1, "fema"), "female", "male"),
    sex2 = if_else(str_detect(sex2, "fema"), "female", "male"),
    species1 = paste("Turdus", species1, sep = "_"),
    species2 = paste("Turdus", species2, sep = "_")
  ) %>%
  # Keep only JND values where male vs. female patches within a given species are compared.
  # Needed filter() when coldist() above was run across all species/sexes/patches, but
  # no longer necessary with split vismod_data and lapply(). Leaving here
  # anyway, as it doesn't change things.
  filter(., patch1 == patch2, species1 == species2, !sex1 == sex2) %>%
  select(., species = species1, patch = patch1, dS, dL) %>%
  group_by(species, patch) %>%
  # Get mean and standard deviation (sd) of JND values for each species
  summarise(mean_dS = mean(dS), sd_dS = sd(dS), mean_dL = mean(dL), sd_dL = sd(dL))


# Save data ---------------------------------------------------------------

saveRDS(jnds_patches_within_sp_btw_sexes, "Data_UPDATED/turdus_plumage_jnds_btw_sexes.RDS")

write_csv(jnds_patches_within_sp_btw_sexes, "Data_UPDATED/Data_CSV/turdus_plumage_jnds_btw_sexes.csv")

message("JND data saved as turdus_plumage_jnds_btw_sexes in Data and Data_CSV.")

# Load packages and data --------------------------------------------------

library(tidyverse)
library(pavo)
library(future, warn.conflicts = F, verbose = F, quietly = T)
library(progressr)
library(pbapply)

# Plumage spectral data ---------------------------------------------------
reflectance_spectra <-
  readRDS("Data/reflectance_spectra.RDS")


jnd_data <- 
  function(specs) {
    blackbird_sensmod <- sensmodel(peaksens = c(373, 454, 504, 557),
                                   lambdacut = c(330, 414, 514, 570),
                                   oiltype = c("T", "C", "Y", "R"),
                                   beta = T,
                                   om = F
    )
    
    blackbird_doublecone <- sensmodel(
      peaksens = 557,
      lambdacut = 439,
      oiltype = "P",
      beta = T, 
      om = F
    )
    
    bb_dc <- blackbird_doublecone$lmax557
    
    
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
      ) %>% 
      ##weber fractions from  from Olsson et al. (2018) 10.1093/beheco/arx133, chromatic average for birds, weber.achro from Melopsittacus undulatus for brightness disc
      coldist(., noise = "neural",
              qcatch = "Qi",
              n = c(1, 1.78, 2.21, 1.96),
              achromatic =  T,
              weber = 0.1,
              weber.ref = "longest",
              weber.achro = 0.18
      )
  }

# Takes about 10 minutes...
jnds <-
  jnd_data(reflectance_spectra)

# JNDs between same sexes of different species 

jnds_patches_btw_sp_within_sexes <-
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
  filter(., patch1 == patch2, sex1 == sex2) %>%
  filter(., !species1 == species2) %>% 
  dplyr::select(-patch2, -sex2) %>% 
  group_by(species1, species2, sex1, patch1) %>%
  # Get mean and standard deviation (sd) of JND values for each species
  summarise(mean_dS = mean(dS), sd_dS = sd(dS), mean_dL = mean(dL), sd_dL = sd(dL), n = n()) %>% 
  rename(sex = sex1, patch = patch1)

write_csv(jnds_patches_btw_sp_within_sexes, "Data/turdus_plumage_interspecific_jnds.csv")
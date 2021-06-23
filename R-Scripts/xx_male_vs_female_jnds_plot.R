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
  readRDS("Data/reflectance_spectra.RDS")

## Create ID factors for averaging within species/sex/patch, average specs, and
## smooth with span=0.2
names(reflectance_spectra) <- str_remove(names(reflectance_spectra), "[1-3]")

spec_ID <-
  do.call(rbind, strsplit(names(reflectance_spectra), "\\."))[, 1:3]

avg_specs<-
  reflectance_spectra %>% 
  aggspec(by = list(
    spec_ID[,1],
    spec_ID[,2],
    spec_ID[,3])) 

rgbcols <-
  spec2rgb(avg_specs) %>%
  tibble(rgb = ., species = names(.)) %>% 
  separate(species, into = c("species", "sex", "patch")) %>% 
  mutate(species = paste("Turdus", species, sep = "_")) %>%

  pivot_wider(id_cols = c(species,patch), names_from = sex, values_from = "rgb")

jnds_patches_within_sp_btw_sexes <-
  readRDS("Data/turdus_plumage_jnds_btw_sexes.RDS") %>% 
  left_join(., rgbcols)


# Male vs. female JND plots -----------------------------------------------

# Density plot
jnds_patches_within_sp_btw_sexes %>% 
  ggplot(aes(x = log10(mean_dL), y = log10(mean_dS))) +
  geom_density2d_filled() +
  scale_fill_viridis_d(option = "inferno") +
  geom_point(shape = 4, color = "white", size = 1, alpha = 0.5) +
  #geom_text(aes(label = species), alpha = 0.2) +
  geom_hline(yintercept = 0, linetype = "dotted", color = "white", alpha = 1) +
  geom_vline(xintercept = 0, linetype = "dotted", color = "white", alpha = 1) +
  guides(fill = "none") +
  facet_wrap(patch~., nrow =2, scales = "fixed") +
  theme_classic() +
  theme(text = element_text(family = "Lato"))

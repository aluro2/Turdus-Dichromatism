
# Load packages -----------------------------------------------------------

# Load packages quietly
library(readr, warn.conflicts = F, verbose = F, quietly = T)
library(future, warn.conflicts = F, verbose = F, quietly = T)
library(magrittr, warn.conflicts = F, verbose = F, quietly = T)
library(dplyr, warn.conflicts = F, verbose = F, quietly = T)
library(tidyr, warn.conflicts = F, verbose = F, quietly = T)
suppressPackageStartupMessages(library(pavo, warn.conflicts = F, verbose = F, quietly = T))
library(progressr, warn.conflicts = F, verbose = F, quietly = T)

# Import spectra in parallel processes ------------------------------------

plan(multiprocess)

specs %<-% {
  pavo::getspec(
    where = "Turdus_Spectral_Data",
    ext = "jaz",
    lim = c(300, 700)
  )
}

with_progress(specs,
  enable = T
)

message("Plumage reflectance spectra imported")

## Create ID factors for averaging within species/sex/patch, average specs, and
## smooth with span=0.2
spec_ID <-
  do.call(rbind, strsplit(names(specs), "\\."))[, 1:3]

## Average spectra within individual bird skins, remove wing patch measurements
## (N=1 species with wing patch measured)
avg_specs <-
  specs %>%
  procspec(.,
    opt = "smooth",
    span = 0.20
  ) %>%
  aggspec(.,
    by = list(
      spec_ID[, 1],
      spec_ID[, 2],
      spec_ID[, 3]
    ),
    FUN = mean
  ) %>%
  select(., -contains("wing"))

message("Plumage reflectance spectra averaged within individual bird skins")


#  Save Data --------------------------------------------------------------

saveRDS(avg_specs, "Data_UPDATED/reflectance_spectra.RDS")

write_csv(avg_specs, "Data_UPDATED/Data_CSV/reflectance_spectra.csv")

message("Averaged reflectance spectra saved in Data and Data_CSV")

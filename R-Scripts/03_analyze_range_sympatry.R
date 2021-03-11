# Load packages -----------------------------------------------------------

#library(tidyverse)
library(magrittr, warn.conflicts = F, quietly = T)
library(tibble, warn.conflicts = F, quietly = T)
library(dplyr, warn.conflicts = F, quietly = T)
library(tidyr, warn.conflicts = F, quietly = T)
library(tidyverse)
library(letsR)
library(raster)

## Import Shapefile ranges from Birdlife International
turdus_ranges <-
  shapefile("Turdus_Data/turdus_birdlife_ranges/all_turdus_final.shp")

##Calculate presence/absence matrix for all species at 11.132km^2 deg resolution
## CAUTION!! NEED A SERVER WITH LOTS OF RAM--function works on 64Gb RAM, but not 16Gb RAM
pres_abs_matrix <-
  lets.presab(turdus_ranges,
              resol = 0.1,
              count = TRUE)

rm(turdus_ranges)

saveRDS(pres_abs_matrix, file = "Turdus_Data/turdus_letsR_data/pres_abs_matrix.RDS")

# Make a Turdus genus breeding range map showing number of Turdus species within a range
#colfunc <- colorRampPalette(colors = c("yellow","blue"), space = "rgb", bias = 1)
#png(filename = "turdus_species_worldmap.png", width = 10, height = 8, units = "cm",  res = 600, pointsize = 5)
#par(mar=rep(5,4))
#plot(pres_abs_matrix, xlab = "Longitude", ylab = "Latitude", useRaster = T, interpolate = T,
#     col_rich = colfunc(1), maxpixels = 1000000, world = F, asp =1.1, main = "Number of Turdus Species within Breeding Range")
#map(add = T, lwd = 0.1, type = "l", fill = T, col = NULL)
#dev.off()

## Get Range sizes in square kilometers
pres_abs_matrix <-
  readRDS(file = "Turdus_Data/turdus_letsR_data/pres_abs_matrix.RDS")

ranges_km2 <-
  lets.rangesize(pres_abs_matrix, units = "squaremeter") %>%
  as.data.frame(.) %>%
  rownames_to_column(., var = "species") %>%
  mutate(., Range_size_km2 = Range_size*1e-6)

## Calculate proportion of cells in each species' range where another species is also present
overlaps <-
  lets.overlap(pres_abs_matrix, method = "Proportional")

saveRDS(overlaps, file = "Turdus_Data/turdus_letsR_data/overlaps.RDS")

## Number of sympatric species, where presence indicated by range overlaps >10%
overlaps<-
  readRDS("Turdus_Data/turdus_letsR_data/overlaps.RDS")

n_species_overlap <-
  list(
    species_1 = rownames(overlaps)[row(overlaps)] %||% row(overlaps),
    species_2 = colnames(overlaps)[col(overlaps)] %||% col(overlaps),
    prop_range_overlap = overlaps
  ) %>%
  map_dfc(as.vector) %>%
  .[!.$species_1 == .$species_2, ] %>%
  arrange(., species_1) %>%
  group_by(species_1) %>%
  mutate(
    has_sympatry_10 = if_else(prop_range_overlap > 0.10, 1, 0),
    has_sympatry_15 = if_else(prop_range_overlap > 0.15, 1, 0),
    has_sympatry_20 = if_else(prop_range_overlap > 0.20, 1, 0),
    has_sympatry_25 = if_else(prop_range_overlap > 0.25, 1, 0),
    has_sympatry_30 = if_else(prop_range_overlap > 0.30, 1, 0),
    has_sympatry_35 = if_else(prop_range_overlap > 0.35, 1, 0),
    has_sympatry_50 = if_else(prop_range_overlap > 0.50, 1, 0),
    has_sympatry_75 = if_else(prop_range_overlap > 0.75, 1, 0),
    has_sympatry_90 = if_else(prop_range_overlap > 0.90, 1, 0),
  ) %>%
  summarise(.,
            n_species_10 = sum(has_sympatry_10),
            n_species_15 = sum(has_sympatry_15),
            n_species_20 = sum(has_sympatry_20),
            n_species_25 = sum(has_sympatry_25),
            n_species_30 = sum(has_sympatry_30),
            n_species_35 = sum(has_sympatry_35),
            n_species_50 = sum(has_sympatry_50),
            n_species_75 = sum(has_sympatry_75),
            n_species_90 = sum(has_sympatry_90),


  )

# Median species' breeding range sympatry overlap for sympatric species at least 30% range overlap
median_sympatric_overlap <-
  list(
    species_1 = rownames(overlaps)[row(overlaps)] %||% row(overlaps),
    species_2 = colnames(overlaps)[col(overlaps)] %||% col(overlaps),
    prop_range_overlap = overlaps
  ) %>%
  map_dfc(as.vector) %>%
  .[!.$species_1 == .$species_2, ] %>%
  arrange(., species_1) %>%
  group_by(species_1) %>%
  filter(., prop_range_overlap >0.30) %>%
  #mutate(has_sympatry = if_else(prop_range_overlap > 0, "symp", "allo")) %>%
  #filter(has_sympatry == "symp") #%>%
  summarise(., median_sym_overlap = round(median(prop_range_overlap), 3))

sympatry_dat <-
  left_join(n_species_overlap, median_sympatric_overlap) %>%
  replace(is.na(.), 0)

write_csv(sympatry_dat, "Data/sympatry_data.csv")

## Plot number of species considered to be sympatric at different % range overlap cutoffs
sympatry_dat %>%
  filter(n_species_10 > 0) %>%
  gather(key = sympatry_metric, value = value, -species_1) %>%
  filter(!sympatry_metric == "median_sym_overlap") %>%
  ggplot(., aes(x = sympatry_metric, y = value, group = species_1)) +
  geom_line(color = "blue", alpha = 0.3, position=position_jitter(height = 0.1)) +
  stat_summary(aes(y = value, x = sympatry_metric, group = 1), fun = median, geom = "line", size = 3, color = "darkblue") +
  labs(y = "Count of Sypatric Species",
       x = "Percent of Range Overlap Cutoff for Sympatry") 

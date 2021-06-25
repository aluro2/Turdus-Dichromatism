
# Load packages -----------------------------------------------------------

library(tidyverse)
library(letsR)
library(raster)
library(fuzzyjoin)
# run apt-get install libudunits2-dev in terminal to get libudunits2.so.0 dep
library(sf)
library(patchwork)

## Import Shapefile ranges -------------------------------------------------
turdus_ranges <- 
  shapefile("Turdus_Data/turdus_birdlife_ranges/all_turdus_final.shp") %>% 
  st_as_sf()

# Data used in models
model_data <-
  read_rds("Data/model_data.rds") %>%
  mutate(
    # natural-log transform breeding range sizes
    ln_birdlifeintl_range_size_km2 = log(birdlifeintl_range_size_km2),
    # center breeding months to reduce collinearity with migratory behavior
    std_breeding_months = scale(breeding_months)[, 1],
    obs = row_number(phylo),
    phylo = sub('.*\\_', '', phylo)
  ) 
# get matching species btw map and model data
matched_data <-
  turdus_ranges$SCINAME %>%
    tibble(phylo = .) %>% 
    fuzzyjoin::fuzzy_left_join(model_data, by = "phylo", match_fun = str_detect) %>% 
    na.omit() %>% 
    dplyr::select(-phylo.y) %>% 
    rename(SCINAME = phylo.x)

# create full dataset with model vars for maps
turdus_data <-
  left_join(turdus_ranges, matched_data, by = "SCINAME")

turdus_data

# get world map
world1 <-
  sf::st_as_sf(map('world', plot = FALSE, fill = TRUE))


# Maps --------------------------------------------------

# Migratory behavior
migratory_behavior_map <-
  turdus_data %>% 
    filter(!is.na(migratory_behavior)) %>% 
    ggplot() +
    geom_sf(data = world1, lwd = 0, fill = "white", alpha= 1) +
    geom_sf(aes(fill = migratory_behavior), size= 0.05, show.legend = TRUE, alpha = 0.5) + 
    scale_fill_brewer(direction = 1, palette = "Paired",
                      name = "Migratory Behavior",
                      labels = c("No migration",
                                 "Partial migration",
                                 "Full migration")) +
    ggtitle("Migratory Behavior") +
    theme_dark()

# Average breeding months
agg_bm <-
  aggregate(x = turdus_data["breeding_months"], by = "breeding_months", FUN = mean, na.rm = TRUE)


breeding_months_map <-
  turdus_data %>% 
  filter(!is.na(breeding_months)) %>% 
  ggplot() +
  geom_sf(data = world1, lwd = 0, fill = "white", alpha= 1) +
  geom_sf(aes(fill = breeding_months), size= 0.00, show.legend = TRUE, alpha = 0.5) + 
    scale_fill_gradient(low = "pink", high = "darkred", na.value = NA,
                        name = "Breeding Season Length \n (Months)") +
  ggtitle("Breeding Months") +
  theme_dark()

{
# Chromatic patches
n_chromatic_patches_1_map <-
  turdus_data %>% 
    filter(!is.na(n_chromatic_patches_1)) %>% 
    ggplot() +
    geom_sf(data = world1, lwd = 0, fill = "white", alpha= 1) +
    geom_sf(aes(fill = n_chromatic_patches_1), size= 0.00, show.legend = TRUE, alpha = 0.5) + 
    scale_fill_gradient(low = "lightyellow", high = "darkorange", na.value = NA,
                        name = "Number of Sexually-Dimorphic Plumage Patches \n > 1 JND") +
    ggtitle("Breeding Months") +
    theme_dark()

n_chromatic_patches_2_map <-
  turdus_data %>% 
  filter(!is.na(n_chromatic_patches_2)) %>% 
  ggplot() +
  geom_sf(data = world1, lwd = 0, fill = "white", alpha= 1) +
  geom_sf(aes(fill = n_chromatic_patches_2), size= 0.00, show.legend = TRUE, alpha = 0.5) + 
  scale_fill_gradient(low = "lightyellow", high = "darkorange", na.value = NA,
                      name = "Number of Sexually-Dimorphic Plumage Patches \n > 2 JND") +
  ggtitle("Breeding Months") +
  theme_dark()

n_chromatic_patches_3_map <-
  turdus_data %>% 
  filter(!is.na(n_chromatic_patches_3)) %>% 
  ggplot() +
  geom_sf(data = world1, lwd = 0, fill = "white", alpha= 1) +
  geom_sf(aes(fill = n_chromatic_patches_3), size= 0.00, show.legend = TRUE, alpha = 0.5) + 
  scale_fill_gradient(low = "lightyellow", high = "darkorange", na.value = NA,
                      name = "Number of Sexually-Dimorphic Plumage Patches \n > 3 JND") +
  ggtitle("Breeding Months") +
  theme_dark()

# Achromatic patches

n_achromatic_patches_1_map <-
  turdus_data %>% 
  filter(!is.na(n_achromatic_patches_1)) %>% 
  ggplot() +
  geom_sf(data = world1, lwd = 0, fill = "white", alpha= 1) +
  geom_sf(aes(fill = n_achromatic_patches_1), size= 0.00, show.legend = TRUE, alpha = 0.5) + 
  scale_fill_gradient(low = "lightyellow", high = "darkorange", na.value = NA,
                      name = "Number of Sexually-Dimorphic Plumage Patches \n > 1 JND") +
  ggtitle("Breeding Months") +
  theme_dark()

n_achromatic_patches_2_map <-
  turdus_data %>% 
  filter(!is.na(n_achromatic_patches_2)) %>% 
  ggplot() +
  geom_sf(data = world1, lwd = 0, fill = "white", alpha= 1) +
  geom_sf(aes(fill = n_achromatic_patches_2), size= 0.00, show.legend = TRUE, alpha = 0.5) + 
  scale_fill_gradient(low = "lightyellow", high = "darkorange", na.value = NA,
                      name = "Number of Sexually-Dimorphic Plumage Patches \n > 2 JND") +
  ggtitle("Breeding Months") +
  theme_dark()

n_achromatic_patches_3_map <-
  turdus_data %>% 
  filter(!is.na(n_achromatic_patches_3)) %>% 
  ggplot() +
  geom_sf(data = world1, lwd = 0, fill = "white", alpha= 1) +
  geom_sf(aes(fill = n_achromatic_patches_3), size= 0.00, show.legend = TRUE, alpha = 0.5) + 
  scale_fill_gradient(low = "lightyellow", high = "darkorange", na.value = NA,
                      name = "Number of Sexually-Dimorphic Plumage Patches \n > 3 JND") +
  ggtitle("Breeding Months") +
  theme_dark()
}


n_chromatic_patches_1_map + n_chromatic_patches_2_map + n_chromatic_patches_3_map

##Calculate presence/absence matrix for all species at 11.132km^2 deg resolution
#pres_abs_matrix <- readRDS(file = "Turdus_Data/turdus_letsR_data/pres_abs_matrix.RDS")
# 
# lets.addvar(pres_abs_matrix, test, onlyvar = T)
# 
# 
#colfunc <- colorRampPalette(colors = c("yellow","blue"), space = "rgb", bias = 1)
# png(filename = "turdus_species_worldmap.png", width = 10, height = 8, units = "cm",  res = 600, pointsize = 5)
# par(mar=rep(5,4))
#plot(pres_abs_matrix, xlab = "Longitude", ylab = "Latitude", useRaster = T, interpolate = T, 
#      col_rich = colfunc(1), maxpixels = 1000000, world = F, asp =1.1, main = "Number of Turdus Species within Breeding Range")
# map(add = T, lwd = 0.1, type = "l", fill = T, col = NULL)
# dev.off()

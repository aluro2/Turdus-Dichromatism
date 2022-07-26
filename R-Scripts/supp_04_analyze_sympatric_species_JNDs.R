
# Load packages and data --------------------------------------------------

library(tidyverse)
library(raster)
library(pavo)
library(future, warn.conflicts = F, verbose = F, quietly = T)
library(progressr)
library(pbapply)


# JNDs data ---------------------------------------------------------------

jnds_patches_btw_sp_within_sexes <- 
  read_csv("Data/turdus_plumage_interspecific_jnds.csv") %>%
  mutate(., 
         species1 = recode(species1, "Turdus_rubripes" = "Turdus_plumbeus_rubripes" ),
         species1 = recode(species1, "Turdus_schistaceus" = "Turdus_plumbeus_schistaceus"),
         species1 = recode(species1, "Turdus_plumbeus" = "Turdus_plumbeus_plumbeus"),
         species1 = recode(species1, "Turdus_anthracinus" = "Turdus_chiguanco_anthracinus"),
         species1 = recode(species1, "Turdus_confinis" = "Turdus_migratorius_confinis" ),
         species1 = recode(species1, "Turdus_gouldi" = "Turdus_rubrocanus_gouldi"),
         #species1 = recode(species1, "Turdus_rubrocanus" = "Turdus_rubrocanus_rubrocanus"),
         species1 = recode(species1, "Turdus_libonyanus" = "Turdus_libonyana"),
         
         species2 = recode(species2, "Turdus_rubripes" = "Turdus_plumbeus_rubripes" ),
         species2 = recode(species2, "Turdus_schistaceus" = "Turdus_plumbeus_schistaceus"),
         species2 = recode(species2, "Turdus_plumbeus" = "Turdus_plumbeus_plumbeus"),
         species2 = recode(species2, "Turdus_anthracinus" = "Turdus_chiguanco_anthracinus"),
         species2 = recode(species2, "Turdus_confinis" = "Turdus_migratorius_confinis" ),
         species2 = recode(species2, "Turdus_gouldi" = "Turdus_rubrocanus_gouldi"),
         #species2 = recode(species2, "Turdus_rubrocanus" = "Turdus_rubrocanus_rubrocanus"),
         species2 = recode(species2, "Turdus_libonyanus" = "Turdus_libonyana")
  ) %>% 
  ungroup() %>% 
  group_by(species1, species2, sex1) %>%
  #  Get number of chromatic
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
  summarise(
    n_chromatic_patches_1 = as.integer(sum(dS_threshold_1)),
    n_chromatic_patches_2 = as.integer(sum(dS_threshold_2)),
    n_chromatic_patches_3 = as.integer(sum(dS_threshold_3)),
    n_achromatic_patches_1 = as.integer(sum(dL_threshold_1)),
    n_achromatic_patches_2 = as.integer(sum(dL_threshold_2)),
    n_achromatic_patches_3 = as.integer(sum(dL_threshold_3))
  )

# Sympatry data -----------------------------------------------------------

## Number of sympatric species, where presence indicated by range overlaps >10%
overlaps<-
  readRDS("Turdus_Data/turdus_letsR_data/overlaps.RDS")

n_species_overlap <- 
  list( 
    species1 = rownames(overlaps)[row(overlaps)] %||% row(overlaps), 
    species2 = colnames(overlaps)[col(overlaps)] %||% col(overlaps), 
    prop_range_overlap = overlaps 
  ) %>% 
  map_dfc(as.vector) %>% 
  .[!.$species1 == .$species2, ] %>% 
  arrange(., species1) %>% 
  group_by(species1) %>% 
  mutate(
    has_sympatry_0 = if_else(prop_range_overlap == 0, 1, 0),
    has_sympatry_10 = if_else(prop_range_overlap > 0.10, 1, 0), 
    has_sympatry_20 = if_else(prop_range_overlap > 0.20, 1, 0), 
    has_sympatry_30 = if_else(prop_range_overlap > 0.30, 1, 0), 
    has_sympatry_40 = if_else(prop_range_overlap > 0.40, 1, 0), 
    has_sympatry_50 = if_else(prop_range_overlap > 0.50, 1, 0), 
    has_sympatry_60 = if_else(prop_range_overlap > 0.60, 1, 0), 
    has_sympatry_70 = if_else(prop_range_overlap > 0.70, 1, 0), 
    has_sympatry_80 = if_else(prop_range_overlap > 0.80, 1, 0), 
    has_sympatry_90 = if_else(prop_range_overlap > 0.90, 1, 0), 
  ) %>% 
  mutate(., 
         species1 = str_replace(species1, " ", "_"),
         species2 = str_replace(species2, " ", "_"),
         species1 = recode(species1, "Otocichla_mupinensis" = "Turdus_mupinensis" ),
         species1 = recode(species1, "Psophocichla_litsitsirupa" = "Turdus_litsitsirupa" ),
         species1 = recode(species1, "Turdus_rubripes" = "Turdus_plumbeus_rubripes" ),
         species1 = recode(species1, "Turdus_schistaceus" = "Turdus_plumbeus_schistaceus"),
         species1 = recode(species1, "Turdus_plumbeus" = "Turdus_plumbeus_plumbeus"),
         species1 = recode(species1, "Turdus_anthracinus" = "Turdus_chiguanco_anthracinus"),
         species1 = recode(species1, "Turdus_confinis" = "Turdus_migratorius_confinis" ),
         species1 = recode(species1, "Turdus_gouldi" = "Turdus_rubrocanus_gouldi"),
         #species1 = recode(species1, "Turdus_rubrocanus" = "Turdus_rubrocanus_rubrocanus"),
         species1 = recode(species1, "Turdus_libonyanus" = "Turdus_libonyana"),
         
         species2 = recode(species2, "Otocichla_mupinensis" = "Turdus_mupinensis" ),
         species2 = recode(species2, "Psophocichla_litsitsirupa" = "Turdus_litsitsirupa" ),
         species2 = recode(species2, "Turdus_rubripes" = "Turdus_plumbeus_rubripes" ),
         species2 = recode(species2, "Turdus_schistaceus" = "Turdus_plumbeus_schistaceus"),
         species2 = recode(species2, "Turdus_plumbeus" = "Turdus_plumbeus_plumbeus"),
         species2 = recode(species2, "Turdus_anthracinus" = "Turdus_chiguanco_anthracinus"),
         species2 = recode(species2, "Turdus_confinis" = "Turdus_migratorius_confinis" ),
         species2 = recode(species2, "Turdus_gouldi" = "Turdus_rubrocanus_gouldi"),
         #species2 = recode(species2, "Turdus_rubrocanus" = "Turdus_rubrocanus_rubrocanus"),
         species2 = recode(species2, "Turdus_libonyanus" = "Turdus_libonyana")
  )  


# JND +  sympatry data -----------------------------------------------------------


sympatry_jnd <-
  left_join(n_species_overlap,
            jnds_patches_btw_sp_within_sexes,
            by = c("species1", "species2")) %>% 
  drop_na() 

# Sympatry at 30% range overlap -------------------------------------------

 median_sympatry30_species_pairs <-
  sympatry_jnd %>% 
  # Keep only species paris with 30% breeding range overlap
  filter(has_sympatry_30 == 1) %>% 
  select(species1, species2, sex1, n_chromatic_patches_1:n_achromatic_patches_3) %>% 
  pivot_longer(cols = n_chromatic_patches_1:n_achromatic_patches_3,
               names_to = "jnd_threshold",
               values_to = "n_patches") %>%
  filter(sex1 == "male") %>%
  group_by(species1) %>% 
  summarise(n_pairs = n()) %>% 
  select(n_pairs) %>% 
  summarise(median_species_pairs = median(n_pairs))


# Sympatry at various % range overlaps ------------------------------------


summarised_sympatry_jnd <-
  sympatry_jnd %>% 
  pivot_longer(cols = has_sympatry_0:has_sympatry_90,
                 names_to = "sympatry") %>% 
  pivot_longer(cols = n_chromatic_patches_1:n_achromatic_patches_3,
               names_to = "jnd_threshold",
               values_to = "n_patches") %>% 
  filter(value == 1) %>% 
  group_by(sympatry, sex1, jnd_threshold, species1) %>% 
  summarise(median = median(n_patches),
            mad = mad(n_patches),
            n = n(),
            min = min(n_patches)) %>%
  group_by(sympatry, sex1, jnd_threshold) %>%
    summarise(grand_median = median(median),
              grand_mad = mad(median),
              total_n = n(),
              grand_min = min(min)) %>%
  mutate(sympatry = as.factor(str_replace(sympatry, "has_sympatry_", "")),
         metric = ifelse(str_detect(jnd_threshold, "achro"), "Achromatic", "Chromatic"),
         jnd_threshold = paste(">", str_extract(jnd_threshold, "(\\d)+"), "JND")) %>% 
  arrange(metric, jnd_threshold)

write_csv(summarised_sympatry_jnd, "Data/summarised_sympatry_jnd.csv")

# Plot median # discriminable patches per sympatry threshold --------------

summarised_sympatry_jnd %>% 
  ggplot(aes(x = sympatry,
             y = grand_median,
             fill = sex1)) +
  geom_line(aes(group = sex1,
                color = sex1),
            position = position_dodge(width = 1)) +
  geom_bar(position = "dodge", stat = "identity", alpha = 0.3) +
  geom_pointrange(aes(ymin = grand_median - grand_mad,
                      ymax = grand_median + grand_mad,
                      color = sex1),
                position = position_dodge(width = 1)) +
  scale_y_continuous(limits = c(-0.65, 5.5), breaks = 0:5) +
  labs(x = "Percent Breeding Range Overlap Threshold",
         y = "Number of Between-Species \n Discriminable Plumage Patches",
       color = "Sex",
       fill = "Sex") +
  facet_grid(metric ~ jnd_threshold) +
  theme_bw() +
  theme(panel.grid.minor = element_blank(),
        text = element_text(family = "Lato"),
        axis.title = element_text(size = 12),
        axis.text = element_text(size = 8),
        strip.text = element_text(size = 14))

ggsave("Figures/sympatry-heterospecific-plumage.png",
       width = 10,
       height = 6,
       units = "in"
       )

# Shortened summary for 30% range overlap ---------------------------------

summarised_sympatry_jnd %>% 
  filter(
    sympatry == 30
  )



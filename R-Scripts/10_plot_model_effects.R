
# Load packages -----------------------------------------------------------

library(tidyverse)
library(tidybayes)
library(pbapply)
library(RColorBrewer)
library(patchwork)
library(gridExtra)
library(lemon)

# Import Model Effects -----------------------------------------------------

model_paths <-
  list.files(path = "Results/Model_Posterior_Draws", full.names = T) %>%
  setNames(str_remove(
    list.files("Results/Model_Posterior_Draws/"),
    '.RDS')
  ) %>%
  # Ignore Intercept Only (null) and Phylogeny Only Models
  .[!grepl('null', names(.)) & !grepl('phylo', names(.))]

# Import models
models <-
  pbapply::pblapply(model_paths,
                    function(x){
                      readRDS(x)
                    })


# Get posterior medians, credible intervals and PDs-------

posterior_summary_data <-
  purrr::imap(
    models,
    function(x, n){
      # Get posteriors from models
      posterior_samples(
        x,
        pars = c("^b_.*", "^sd_phylo*"),
        fixed = FALSE) %>%
        # Get posterior medians, HDIs and PDs
        describe_posterior(
          centrality = "median",
          dispersion = FALSE,
          ci = 0.90,
          ci_method = "HDI",
          test = "pd"
        )  %>%
        as_tibble() %>%
        # Round all values to 2 decimal places
        mutate_if(is.numeric, round, 2) %>%
        # Add model identifiers, response IDs and change predictor names
        mutate(
          'Plumage Metric' = if_else(str_detect(n, '_achromatic'),  'Achromatic', 'Chromatic'),
          # JND threshold
          'JND Threshold' = case_when(
            str_detect(n, '_1') ~ '1 JND',
            str_detect(n, '_2') ~ '2 JND',
            str_detect(n, '_3') ~ '3 JND'),
          Model = case_when(
            str_detect(n, 'breeding') ~ 'Breeding Timing',
            str_detect(n, 'landmass') ~ 'Breeding Spacing',
            str_detect(n, 'sympatry') ~ 'Breeding Sympatry'
          ),
          Parameter =
            # Rename variables
            recode(Parameter,
                   b_Intercept = "Intercept",
                   b_std_breeding_months = "Breeding Season Length",
                   b_migratory_behaviorpartial = "Partial Migration vs. No Migration",
                   b_migratory_behavioryes = "Full Migration vs. No Migration",
                   `b_std_breeding_months:migratory_behaviorpartial` = "Breeding Season Length x Partial Migration",
                   `b_std_breeding_months:migratory_behavioryes` = "Breeding Season Length x Full Migration",
                   #sd_phylo__Intercept = "Phylogenetic Variation \n (Between-Species Standard-Deviation)",
                   b_landmassisland = "Island vs. Mainland",
                   b_ln_birdlifeintl_range_size_km2 = "Breeding Range Size",
                   b_n_species_30 = "Number of Sympatric Species \n (≥ 30% Breeding Range Overlap)",
                   sd_phylo__Intercept = "Phylogenetic Signal"
            )
        ) %>%
        # Reorder datasets
        select(Model, `Plumage Metric`, `JND Threshold`, Parameter, everything(), -CI)
    }
  ) %>%
  # Combine all model posterior summaries into single df
  map_df(., bind_rows) %>% 
  filter(!Parameter == "Intercept",
         !Parameter == "Phylogenetic Signal") %>% 
  mutate(Parameter = as_factor(Parameter),
         Parameter = fct_relevel(Parameter,
                                 "Phylogenetic Signal",
                                 "Breeding Season Length",
                                 "Full Migration vs. No Migration",
                                 "Partial Migration vs. No Migration",
                                 "Breeding Season Length x Full Migration",
                                 "Breeding Season Length x Partial Migration",
                                 "Island vs. Mainland",
                                 "Breeding Range Size",
                                 "Number of Sympatric Species \n (≥ 30% Breeding Range Overlap)",
                                 after = 1L)) 


# Plot model effects ------------------------------------------------------
achro <- brewer.pal(3, "Greys")
chrom<- brewer.pal(3, "OrRd")

plots <-
  posterior_summary_data %>% 
    split(.$Model) %>% 
    map(~ggplot(.x, aes(x = Median, y = Parameter, xmin = CI_low, xmax = CI_high,
                    color = interaction(`JND Threshold`,`Plumage Metric`))) +
          geom_vline(xintercept = 0, size = 2, alpha = 0.4) +
          geom_pointrange(position = position_dodge(width = 0.6),
                          size = 1) +
          geom_text(aes(x = CI_high, y = Parameter, label = paste("pd =",pd,"")),
                    position = ggstance::position_dodgev(height = 1.5)) +
          scale_color_manual(values = c(achro, chrom),
                             labels = c("Achromatic, 1 JND",
                                        "Achromatic, 2 JND",
                                        "Achromatic, 3 JND",
                                        "Chromatic, 1 JND",
                                        "Chromatic, 2 JND",
                                        "Chromatic, 3 JND")) +
          guides(color=guide_legend(nrow=3,byrow=FALSE)) +
          labs(x = "Median Log-Odds of Dichromatic Plumage Patch",
               y = "Model Paramter",
               color = "Achromatic/Chromatic \n JND Threshold") +
          facet_wrap(~`Plumage Metric`, scale = "free_x") +
          coord_cartesian() +
          theme_linedraw() +
          theme(text = element_text(family = "Lato"),
                axis.title = element_text(size = 11),
                strip.text.x = element_text(size = 11),
                panel.background = element_rect(fill = "grey29"),
                legend.direction = "vertical",
                legend.position = "none") 
          ) 



# Lemon

legend <- g_legend(plots$`Breeding Sympatry` + theme(legend.position='bottom'))

grid.arrange(plots$`Breeding Sympatry` + theme(legend.position='hidden'), 
             plots$`Breeding Spacing` + theme(legend.position='hidden'),
             plots$`Breeding Timing` + theme(legend.position='hidden'), legend)

# Patchwork
# plots$`Breeding Spacing` <- plots$`Breeding Spacing` + guides(colour = "none")
# 
# plots$`Breeding Timing` <- plots$`Breeding Timing` + guides(colour = "none")
# 
# plots$`Breeding Sympatry` + plots$`Breeding Timing` + plots$`Breeding Spacing` +
#   plot_layout(guides = "collect") & theme(legend.position = "bottom")
# 
# combined <- plots$`Breeding Sympatry` + plots$`Breeding Timing`
# combined + plot_layout(guides = "collect")


# Load packages -----------------------------------------------------------

library(brms)
library(magrittr)
library(stringr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(patchwork)
library(pbapply)

# Get model paths ----------------------------------------------------------

model_paths <-
  list.files(path = "Results/Model_Posterior_Draws", full.names = T) %>%
  setNames(str_remove(
    list.files("Results/Model_Posterior_Draws/"),
    ".RDS"
  )) %>%
  # Ignore Intercept Only (null) and Phylogeny Only Models
  .[!grepl("null", names(.)) & !grepl("phylo", names(.))]

# Import models
models <-
  pbapply::pblapply(
    model_paths,
    function(x) {
      readRDS(x)
    }
  )


# Conditional effects plots -----------------------------------------------

breeding_season_length_x_migration <-
  plot(
    conditional_effects(
      models$breeding_model_n_achromatic_patches_1,
      effects = "std_breeding_months:migratory_behavior",
      # conditions = data.frame(migratory_behavior = c("no", "partial", "yes")),
      # Use median values
      robust = T,
      probs = c(0.10, 0.90),
      method = "fitted",
      re_formula = NULL,
      nsamples = 5000
    ),
    plot = FALSE
  )[[1]]

breeding_season_length_x_migration +
  aes(
    color = migratory_behavior,
    fill = migratory_behavior
  ) +
  scale_color_viridis_d() +
  scale_fill_viridis_d() +
  facet_grid(
    . ~ migratory_behavior,
    labeller = labeller(
      migratory_behavior =
        c(no = "No Migration", partial = "Partial Migration", yes = "Full Migration")
    )
  ) +
  guides(
    color = F,
    fill = F
  ) +
  labs(
    x = "Z-Score Breeding Season Length",
    y = "Number of Sexually Dimorphic \n Achromatic Patches > 2 JND"
  ) +
  theme_classic()


# Sympatry Plot -----------------------------------------------------------

sympatry_mods <-
  models[grepl("sympatry_model_n_chromatic", names(models))]


sympatry_plots <-
  models[grepl("sympatry_model_n_chromatic", names(models))] %>%
  purrr::imap(
    .,
    function(x, n){

      #cols <- as.list(viridis::viridis(n = 3))
      color_ramp <- colorRampPalette(c("dodgerblue", "darkblue"))
      cols <- as.list(color_ramp(3))

      color <- case_when(
        str_detect(n, "1") ~ cols[1],
        str_detect(n, "2") ~ cols[2],
        str_detect(n, "3") ~ cols[3])
      response <- case_when(
        str_detect(n, "1") ~ "Number of Sexually Dimorphic \n Chromatic Patches > 1 JND",
        str_detect(n, "2") ~ "Number of Sexually Dimorphic \n Chromatic Patches > 2 JND",
        str_detect(n, "3") ~ "Number of Sexually Dimorphic \n Chromatic Patches > 3 JND")
  cond_plot <-
    plot(
    conditional_effects(
      x,
      effects = "n_species_30",
      robust = T,
      probs = c(0.05, 0.95),
      method = "fitted",
      re_formula = NULL,
      nsamples = 5000
      ),
    plot = FALSE
  )[[1]]

  cond_plot +
    aes(group = 1,
        color = color,
        fill = color) +
    labs(
      x = "Number of Sympatric Species \n (≥ 30% Breeding Range Overlap)",
      y = response
    ) +
    theme(
      axis.text = element_text(size = 10)
    ) +
    theme_classic()
    }
  )

(sympatry_plots[[1]] + labs(x="")) + sympatry_plots[[2]] + (sympatry_plots[[3]] + labs(x=""))

ggsave(filename = "Figures/Figure_02_Sympatric_Species.png",
       width = 10,
       height = 5,
       units = "in")


# Migration Plot -----------------------------------------------------------

migration_plots <-
  models[grepl("breeding_model_n_achromatic", names(models))] %>%
  purrr::imap(
    .,
    function(x, n){

      #cols <- as.list(viridis::viridis(n = 3))
      color_ramp <- colorRampPalette(c("dodgerblue", "darkblue"))
      cols <- as.list(color_ramp(3))

      color <- case_when(
        str_detect(n, "1") ~ cols[1],
        str_detect(n, "2") ~ cols[2],
        str_detect(n, "3") ~ cols[3])
      response <- case_when(
        str_detect(n, "1") ~ "Number of Sexually Dimorphic \n Chromatic Patches > 1 JND",
        str_detect(n, "2") ~ "Number of Sexually Dimorphic \n Chromatic Patches > 2 JND",
        str_detect(n, "3") ~ "Number of Sexually Dimorphic \n Chromatic Patches > 3 JND")
      cond_plot <-
        plot(
          conditional_effects(
            x,
            effects = "migratory_behavior",
            robust = T,
            probs = c(0.10, 0.90),
            method = "fitted",
            re_formula = NULL,
            nsamples = 5000,
            points = T
          ),
          plot = FALSE
        )[[1]]

      cond_plot +
        aes(group = 1,
            color = color,
            fill = color) +
        labs(
          x = "Migratory Behavior",
          y = response
        ) +
        theme(
          axis.text = element_text(size = 10)
        ) +
        theme_classic()
    }
  )

migration_plots[[1]] + migration_plots [[2]] + migration_plots[[3]]

ggsave(filename = "Figures/Figure_02_Sympatric_Species.png",
       width = 10,
       height = 5,
       units = "in")


# Load packages -----------------------------------------------------------
library(dplyr, warn.conflicts = F)
library(purrr, warn.conflicts = F)
library(ggplot2, warn.conflicts = F)
library(tidybayes, warn.conflicts = F)
library(forcats)
#library(patchwork)


# Experimental ------------------------------------------------------------

fitted_vals <-
  readRDS("Figures/Figure_Data/fitted_vals.RDS")

fitted_vals$breeding_model_n_chromatic_patches_1 %>%
  ggplot(aes(
    x = migratory_behavior,
    y = .value
  )) +
  stat_gradientinterval(aes(y = .value),
                        .width = c(0.90, 0.50),
                        fill = "dodgerblue",
                        slab_type = "pdf",
                        adjust = 1
  ) +
  theme_classic()

# Import (tidybayes) posterior draws for plotting ----------------------------
posterior_draws <-
  readRDS(file = "Figures/Figure_Data/posterior_draws.RDS")

plot_data <-
  posterior_draws %>%
  ungroup() %>%
  mutate(
    .variable =
      # Rename variables
    recode(.variable,
      b_Intercept = "Intercept",
      b_std_breeding_months = "Breeding Season Length",
      b_migratory_behaviorpartial = "Partial Migration vs. No Migration",
      b_migratory_behavioryes = "Full Migration vs. No Migration",
      `b_std_breeding_months:migratory_behaviorpartial` = "Breeding Season Length x Partial Migration",
      `b_std_breeding_months:migratory_behavioryes` = "Breeding Season Length x Full Migration",
      sd_phylo__Intercept = "Phylogenetic Variation \n (Between-Species Standard-Deviation)",
      b_landmassisland = "Island vs. Mainland",
      b_ln_birdlifeintl_range_size_km2 = "Breeding Range Size",
      b_n_species_30 = "Number of Sympatric Species \n (≥ 30% Breeding Range Overlap)"
    ),
    # Set variables as factors for ordering
    .variable = as.factor(.variable),
    # Get odds from log-odds
    .value_odds = exp(.value),
    # Get probability from log-odds
    .value_prob = (exp(.value) / (1 + exp(.value)))
  ) %>%
  # Remove Phylogenetic SD
  filter(!.variable == "Phylogenetic Variation \n (Between-Species Standard-Deviation)",
         !.variable == "Intercept") %>%
  split(.$`Plumage Metric`) %>%
  map(~ split(.x, .$Model)) %>%
  # Order variables by posterior values
  map(map, ~ mutate(.x,
    .variable = forcats::fct_reorder(.variable, desc(.value)),
    # Make Phylogenetic Variance last for all plots
    .variable = forcats::fct_relevel(.variable, "Intercept", after = Inf)
  )) %>%
  # Combine into single df
  map_df(., bind_rows)

# Facetted interval plot ----------------------------------------------------------------


      yellowpal <- colorRampPalette(c("lightyellow", "yellow"))
      graypal <- colorRampPalette(c("gray", "black"))

      plot_data %>%
        group_by(
          Model,
          `Plumage Metric`,
          `JND Threshold`,
          .variable) %>%
        mode_hdi(.value,
                 .width = c(0.50, 0.80)) %>%
        # Generate plot
        ggplot(aes(
          x = .variable,
          y = .value,
          ymin = .lower,
          ymax = .upper
        )) +
        geom_pointinterval(
          aes(
            color = interaction(`JND Threshold`, `Plumage Metric`),
            shape = interaction(`JND Threshold`, `Plumage Metric`)
          ),
          position = position_dodge(width = 0.8),
          point_size = 3,
          #interval_size = 15,
          interval_alpha = 0.8,
          thickness = 30
        ) +
        scale_color_manual(
          name = "JND Threshold",
          labels = rev(
            c(
            "Chromatic, 3 JND",
            "Chromatic, 2 JND",
            "Chromatic, 1 JND",
            "Achromatic, 3 JND",
            "Achromatic, 2 JND",
            "Achromatic, 1 JND"
          )
          ),
          values = c(
            # Achromatic palette
            graypal(3),
            # Chromatic palette
            yellowpal(3)
            ),
        ) +
        scale_shape_manual(
          name = "JND Threshold",
          values = c(rep(16,3), rep(17,3)),
          labels = rev(
            c(
              "Chromatic, 3 JND",
              "Chromatic, 2 JND",
              "Chromatic, 1 JND",
              "Achromatic, 3 JND",
              "Achromatic, 2 JND",
              "Achromatic, 1 JND"
            )
          ),
        ) +
        guides(
          color = guide_legend(reverse = TRUE),
          shape = guide_legend(reverse = TRUE)
        ) +
      geom_hline(yintercept = 0, linetype = "dashed", color = "white") +
        labs(
          x = "Predictor",
          y = "Log-Odds"
        ) +
        coord_flip() +
        facet_wrap(
          ncol = 2,
          dir = "v",
          `Plumage Metric` ~ Model,
          scales = "free_y",
          labeller = "label_both") +
        theme_dark() +
        theme(
          panel.grid.minor = element_blank(),
          panel.grid.major.x = element_blank()
        )


# Separate plots ----------------------------------------------------------


  map(
    map,
    ~ ggplot(
      .x,
      aes(
        x = .variable,
        y = .value,
        color = `JND Threshold`,
        shape = `JND Threshold`
      )
    ) +
      # stat_interval(alpha = 1,
      #             size = 5,
      #             position = position_dodge2(),
      #             point_interval = mode_hdi) +
      # scale_color_brewer(palette = 'YlGnBu') +
      stat_pointinterval(
        position = position_dodge(width = 0.5),
        point_interval = mode_hdci,
        .width = c(0.50, 0.80)
      ) +
      scale_color_brewer(
        name = "JND Threshold",
        palette = "Blues"
      ) +
      geom_hline(yintercept = 0, linetype = "dashed", color = "white") +
      labs(
        x = "Predictor",
        y = "Log-Odds",
        color = "Credible Interval"
      ) +
      coord_flip() +
      facet_wrap(.~ `Plumage Metric`) +
      brms::theme_black() +
      theme(
        panel.grid.minor = element_blank(),
        panel.grid.major.x = element_blank()
      )
  )




chromatic_plots <-
  (plots$Chromatic$`Breeding Timing` / plots$Chromatic$`Breeding Spacing` / plots$Chromatic$`Breeding Sympatry`)

achromatic_plots <-
  (plots$Achromatic$`Breeding Timing` / plots$Achromatic$`Breeding Spacing` / plots$Achromatic$`Breeding Sympatry`)


chromatic_plots | achromatic_plots
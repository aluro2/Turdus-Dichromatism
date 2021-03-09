
# Load packages -----------------------------------------------------------

library(brms, warn.conflicts = F)
library(readr, warn.conflicts = F)
library(magrittr, warn.conflicts = F)
library(stringr)
library(pbapply)
library(furrr)
library(future)
library(dplyr)
library(ggplot2)
library(grid)
library(gridExtra)
library(png)

# Get model paths ----------------------------------------------------------

model_paths <-
  list.files(path = "Results_UPDATED/Model_Posterior_Draws", full.names = T)

model_names <-
  list.files(path = "Results_UPDATED/Model_Posterior_Draws/") %>%
  str_remove(., ".RDS")

models <-
  pbapply::pblapply(model_paths,
                    function(x){
                      readRDS(x)
                    }) %>%
  setNames(model_names)

# Model posterior predictive checks (pp_check) ------------------------------------------

future::plan('multiprocess')

furrr::future_imap(
  models,
  function(x, n){

    model <- x

    save_name <- paste("Figures/Posterior_Predictive_Fits/", n, ".png", sep = "")

    model_name <-
      case_when(
        str_detect(n, 'breeding') ~ 'Breeding Timing',
        str_detect(n, 'landmass') ~ 'Breeding Spacing',
        str_detect(n, 'sympatry') ~ 'Breeding Sympatry',
        str_detect(n, 'phylo') ~ 'Phylogeny Only',
        str_detect(n, 'null') ~ 'Intercept Only'
      )

    response_name <-
        if_else(
          str_detect(
          n, '_achromatic'),
          'Achromatic', 'Chromatic')

    jnd_threshold <-
      case_when(
        str_detect(n, '_1') ~ '1 JND',
        str_detect(n, '_2') ~ '2 JND',
        str_detect(n, '_3') ~ '3 JND')

    plot <-
      pp_check(x, type = 'bars', nsamples = 1000) +
      labs(
        y = 'Number of Species',
        x = paste(
          'Number of',
          response_name,
          'Patches',
          '>',
          jnd_threshold,
          sep = " "),
        title = model_name,
        subtitle = paste(
          response_name,
          jnd_threshold,
          sep = ", ")
        ) +
      theme_dark()

      # Save pp_check plots
      ggsave(plot = plot,
             device = 'png',
             width = 3.5,
             height = 2.5,
             units = 'in',
             filename = save_name)
  },
  .progress = TRUE
)
    #message(paste("Model", n, "complete and saved!", sep = " "))

plot_paths <-
  list.files('Figures/Posterior_Predictive_Fits',
             full.names = T)

#png_plots <-
pdf("Figures/supp_01_posterior_prediction_fits.pdf")

plot_paths %>%
  future_map(png::readPNG) %>%
  purrr::map(grid::rasterGrob) %>%
  marrangeGrob(grobs = .,
               nrow = 3,
               ncol = 2)

dev.off()


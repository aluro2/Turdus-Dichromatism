
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
library(bayesplot)

# Import models ----------------------------------------------------------

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

# Model caterpillar plots ------------------------------------------


purrr::imap(
  models,
  function(x, n){
    
    model <- x
    
    save_name <- paste("Figures/Model_Diagnostic_Plots/", n, ".pdf", sep = "")
    
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
    
    
      bayesplot::color_scheme_set(
        ifelse(response_name == 'Achromatic',
               "gray",
               "brightblue")
      )
      
    
    plot <-
      bayesplot::mcmc_combo(x,
                      regex_pars = "^b_",
                      type = "combo",
                      widths = c(1,2),
                      gg_theme =
                        ggplot2::theme_dark() +
                        ggplot2::theme(title = element_text(size = 10),
                                       panel.background = element_rect(fill = "gray20"),
                                       panel.grid.minor = element_blank()) +
                        legend_none())
    
    # Save pp_check plots
    ggsave(plot = plot,
           device = 'pdf',
           width = 11,
           height = 8.5,
           units = 'in',
           filename = save_name)
  }
)
#message(paste("Model", n, "complete and saved!", sep = " "))
# 
# plot_paths <-
#   list.files('Figures/Model_Diagnostic_Plots/',
#              full.names = T)[1:2]
# 
# 
# pdf("Figures/supp_03_model_mcmc_plots.pdf")
# 
#   plot_paths %>%
#   purrr::map(png::readPNG) %>%
#   purrr::map(grid::rasterGrob) %>%
#   marrangeGrob(grobs = .,
#                nrow = 1,
#                ncol = 1,
#                top = plot_paths[1:2])
# dev.off()


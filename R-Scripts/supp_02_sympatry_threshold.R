library(tidyverse)

# Import data
model_data <-
  readRDS("Data/model_data.rds") %>% 
  mutate(trials = 5 - n_chromatic_patches_1)

# Names of response vars
dichro_patches <-
  names(model_data)[grep(names(model_data), pattern = "patches")]

# Get data into long format
plot_data <-
  model_data %>% 
  select(contains("n_"), -median_sym_overlap, -species_in_models) %>% 
  pivot_longer(contains("n_species"), "sympatry_threshold") %>% 
  mutate(sympatry_threshold = paste(str_replace(sympatry_threshold, "n_species_", ""), "% range overlap", sep = "")) 


# Plot relationship btw plumage dichromatism response and number of sympatric species (per each % range overlap threshold) --------

dichro_patches %>% 
  purrr::map(function(z){
    
    save_name <- 
      paste("/tmp/", z, ".png", sep = "")
    
    y_lab <-
      if_else(str_detect(z,"_chromatic"),
              paste("Number of chromatic patches", ">",
                    str_extract(z, "[1-3]"),
                                "JND"),
              paste("Number of achromatic patches", ">",
                    str_extract(z, "[1-3]"),
                                "JND")
      )
    
    col <-
      if_else(str_detect(z, "_chromatic"),
              "blue",
              "red")
    plot <-
      plot_data %>% 
        select(z, sympatry_threshold, value) %>% 
        ggplot(aes_string(y = z, x = "value")) +
          geom_point(size = 0.2, color = col) +
          geom_smooth(color = col, method = "loess") +
          labs(x = "Number of Sympatric Species",
               y = y_lab) +
          facet_wrap(sympatry_threshold ~ .) 
    
    # Save  plots
    ggsave(plot = plot,
           device = 'png',
           width = 6,
           height = 4,
           units = 'in',
           filename = save_name)
    
  })


# Combine and save plots as single pdf ------------------------------------------------

plot_paths <-
  list.files('/tmp',
             pattern = "*.png",
             full.names = T)

pdf("Figures/supp_02_sympatry_thresholds.pdf")

plot_paths %>%
  purrr::map(png::readPNG) %>%
  purrr::map(grid::rasterGrob) %>%
  gridExtra::marrangeGrob(grobs = .,
               nrow = 3,
               ncol = 2)

dev.off()

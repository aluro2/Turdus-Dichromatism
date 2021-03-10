
# Load packages -----------------------------------------------------------
library(readr, warn.conflicts = F)
library(magrittr, warn.conflicts = F)
library(dplyr, warn.conflicts = F)
library(stringr, warn.conflicts = F)
#library(tidyr, warn.conflicts = F)
library(brms, warn.conflicts = F)
library(ggplot2, warn.conflicts = F)
library(tidybayes, warn.conflicts = F)


# Import models  ----------------------------------------------------------
{
  model_paths <-
    list.files("Results/Model_Posterior_Draws", full.names = T)

  model_names <-
    str_remove(str_split_fixed(model_paths, "/", 3)[,3], ".rds")

  models <-
    lapply(model_paths,
           function(x){
             readRDS(x)
           })

  names(models) <- model_names

  list2env(models, globalenv())
}

# Get model draws and combine into single dataset

posterior_draws <-
  pbapply::pblapply(
    models,
    function(x){
      gather_draws(model = x,
                   `^b_.*`, `sd_.*`, regex = TRUE) %>%
        filter(!grepl('b_Intercept', .variable))
    }
  )
# this will make one dataset, but it may be easier to keep as list of models
#%>%
#bind_rows(., .id = '.model')


plots <-
  lapply(posterior_draws,
         function(x)
         {
           ggplot(x,
                  aes(x = .variable,
                      y = .value)) +
             stat_interval(alpha = 1,
                           size = 3) +
             scale_color_brewer(palette = 'Reds') +
             stat_pointinterval(color = 'white') +
             geom_hline(yintercept = 0, linetype = "dashed") +
             coord_flip() +
             theme_dark()

         })

ggplot(posterior_draws,
       aes(x = .variable,
           y = .value)) +
  stat_interval(alpha = 1,
                size = 3) +
  scale_color_brewer(palette = 'Reds') +
  stat_pointinterval(color = 'white') +
  geom_hline(yintercept = 0, linetype = "dashed") +
  coord_flip() +
  theme_dark()



##### Experimental plots


mcmc_plot(sympatry_model_jnd03_chromatic,
          type = "acf")

plot_n_species_30 <-
  conditional_effects(
    sympatry_model_jnd03_chromatic,
    method = 'posterior_epred',
    effects = as.factor('n_species_30'),
    ordinal =  T,
    nsamples = 100,
    spaghetti = F,
    plot = F,
    resolution = 500,
    surface = T,
    .surface_args = 'interpolate = T'
  )

plot(plot_n_species_30,
     plot = F)[[1]] +
  theme_black()

model_data_clean <-
  sympatry_model_jnd03_chromatic$data %>%
  mutate(n_chromatic_patches_3 = ordered(n_chromatic_patches_3))

plot_data <-
  model_data_clean %>%
  add_fitted_draws(
    sympatry_model_jnd03_chromatic,
    n = 5000,
    seed = 15,
    value =  'P(N-Dichromatic Patches)',
    scale = 'response'
  ) %>%
  mutate(
    n_chromatic_patches_3 = levels(model_data_clean$n_chromatic_patches_3)[.category],
    n_species_30 = as.factor(n_species_30))


ggplot(plot_data,
       aes(
         x = n_species_30,
         y = n_chromatic_patches_3
       )) +
  geom_tile(aes(fill = `P(N-dichromatic patches)`)) +
  scale_fill_viridis_c(option = 'plasma')


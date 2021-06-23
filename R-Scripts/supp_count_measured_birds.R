library(pavo)
library(tidyverse)

measured_birds <-
  read_csv("Data/Data_Copy_CSV/measured-birds.csv") %>% 
  filter(!species_ind == "wl_wl") %>% 
  separate(species_ind, into = c("species", "indiv")) %>% 
  mutate(sex = if_else(str_detect(indiv, "male"), "male", "female"),
         indiv = str_extract(indiv, "[1-9]")) %>% 
  group_by(species, sex) %>% 
  summarise(n = n()) %>% 
  write_csv("Data/Data_Copy_CSV/count-measured-birds.csv")

         

# Load packages -----------------------------------------------------------

library(tidyverse)
library(letsR)
library(maptools)

#Calculate presence/absence matrix for all species at 11.132km^2 deg resolution
pres_abs_matrix <-
  readRDS(file = "Turdus_Data/turdus_letsR_data/pres_abs_matrix.RDS")

sr_turdus <-
  pres_abs_matrix$Richness_Raster

sr_turdus[sr_turdus == 0] <- NA

colfunc <-
  colorRampPalette(colors = c("#ebeb65","#32a87f","blue"),
                   space = "Lab",
                   bias = 1.5)

png(filename = "Figures/01_turdus_species_worldmap.png", width = 7, height = 5, units = "in",  res = 600, pointsize = 8)

par(mar=rep(5,4))

plot(sr_turdus,
     xlab = "",
     ylab = "",
     useRaster = T,
     interpolate = T,
     col = colfunc(10),
     maxpixels = 1000000,
     asp = 1.1,
     axes = F,
     bty = "n",
     colNA = "white")

map(add = T, lwd = 0.1, type = "l", fill = F, myborder = F, bty = "n", boundary = T)

dev.off()


# Mollweide projection map ------------------------------------------------

# Set up maps

sr_turdus_mw <-
  projectRaster(sr_turdus, crs =  "+proj=moll +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84")

map(add = T, lwd = 0.3, type = "l", fill = F, myborder = T, bty = "n", boundary = T,
    projection = "mollweide")

data(wrld_simpl)

wrld_simpl <-
  spTransform(wrld_simpl, CRS = "+proj=moll +lon_0=0 +x_0=0 +y_0=0 +ellps=WGS84")

# Make plot

colfunc <-
  colorRampPalette(colors = c("#ebeb65","#32a87f","blue"),
                   space = "Lab",
                   bias = 1.5)

png(filename = "Figures/01_turdus_species_worldmap.png", width = 7, height = 6.5, units = "in",  res = 600, pointsize = 8)

par(mar=rep(5,4))

plot(wrld_simpl, lwd = 0.0001); plot(sr_turdus_mw,
     useRaster = T,
     interpolate = T,
     col = colfunc(10),
     maxpixels = 1000000,
     asp = 2,
     axes = F,
     bty = "n", add = T); plot(wrld_simpl, lwd = 0.5, add = T)

dev.off()


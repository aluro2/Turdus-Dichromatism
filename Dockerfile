FROM rocker/tidyverse:4.0.0

# Install packages and dependencies for pavo, raster and letsR packages
RUN apt-get update && apt-get install -y \
        libmagick++-dev \
        gdal-bin \
        proj-bin \
        libgdal-dev \
        libproj-dev \
&& rm -rf /var/lib/apt/lists/* \
&& apt-get clean 

# Install R packages

RUN R -e "devtools::install_version('pavo', version = '2.4.0', repos='http://cran.us.r-project.org', clean = T, Ncpus = 6, quick = T)" \
&& R -e "devtools::install_version('rstan', version = '2.19.2', repos='http://cran.us.r-project.org', clean = T, Ncpus = 6, quick = T)" \
&& R -e "devtools::install_version('brms', version = '2.13.0', repos='http://cran.us.r-project.org', clean = T, Ncpus = 6, quick = T)" \
&& R -e "devtools::install_version('ape', version = '5.4', repos='http://cran.us.r-project.org', clean = T, Ncpus = 6, quick = T)" \
&& R -e "devtools::install_version('phytools', version = '0.7-47', repos='http://cran.us.r-project.org', clean = T, Ncpus = 6, quick = T)" \
&& R -e "devtools::install_version('tidybayes', version = '2.0.3', repos='http://cran.us.r-project.org', clean = T, Ncpus = 6, quick = T)" \
&& R -e "devtools::install_version('pbapply', version = '1.4-2', repos='http://cran.us.r-project.org', clean = T, Ncpus = 6, quick = T)" \
&& R -e "devtools::install_version('raster', version = '3.1-5', repos='http://cran.us.r-project.org', clean = T, Ncpus = 6, quick = T)" \
&& R -e "devtools::install_version('letsR', version = '3.2', repos='http://cran.us.r-project.org', clean = T, Ncpus = 6, quick = T)"

# Install extra R packages
RUN R -e "devtools::install_version('flextable', version = '0.5.10', repos='http://cran.us.r-project.org', clean = T, Ncpus = 6, quick = T)"

Run R -e "devtools::install_version('patchwork', version = '1.0.0', repos='http://cran.us.r-project.org', clean = T, Ncpus = 6, quick = T)"


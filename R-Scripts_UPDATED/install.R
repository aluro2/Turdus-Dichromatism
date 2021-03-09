
# Install and compile packages from source --------------------------------

# Use multiple cores when compiling packages
Sys.setenv(MAKEFLAGS = "-j4")

devtools::install_version("pavo", version = "2.4.0", repos='http://cran.us.r-project.org')

devtools::install_version("rstan", version = "2.19.2", repos='http://cran.us.r-project.org')

devtools::install_version("brms", version = "2.13.0", repos='http://cran.us.r-project.org')

devtools::install_version("ape", version = "5.4", repos='http://cran.us.r-project.org')

devtools::install_version("phytools", version = "0.7-47", repos='http://cran.us.r-project.org')

devtools::install_version("tidybayes", version = "2.0.3", repos='http://cran.us.r-project.org')

devtools::install_version("pblappy", version = "1.4-2", repos='http://cran.us.r-project.org')

devtools::install_version("future", version = "1.17.0", repos='http://cran.us.r-project.org')

devtools::install_version("raster", version = "3.1-5", repos='http://cran.us.r-project.org')

devtools::install_version("letsR", version = "3.2", repos='http://cran.us.r-project.org')



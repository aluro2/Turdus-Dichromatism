#!/bin/bash

# Get Project Directory
analysis_dir="$(dirname $(dirname $(dirname $(realpath $0 ))))/Turdus_analyses"
echo $analysis_dir

# Change to Project Directory
cd $analysis_dir

# Allow progress bar animation in terminal
export R_PROGRESSR_ENABLE=TRUE

# Start R Script
Rscript R-Scripts/data_import_spectra.R --parallel=6

echo END OF: data_import_spectra.R
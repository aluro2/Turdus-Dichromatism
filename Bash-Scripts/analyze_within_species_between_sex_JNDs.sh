#!/bin/bash

# Get Project Directory
analysis_dir="$(dirname $(dirname $(dirname $(realpath $0 ))))/Turdus-Dichromatism"
echo $analysis_dir

# Change to Project Directory
cd $analysis_dir

# Allow progress bar animation in terminal
export R_PROGRESSR_ENABLE=TRUE

# Start R Script
Rscript R-Scripts/analyze_within_species_between_sex_JNDs.R --parallel=8

echo END OF: analyze_within_species_between_sex_JNDs.R
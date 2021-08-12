#!/usr/bin/env bash

cd Figures

echo "Converting tables..."

# Latex to pdf
xelatex Table_01_model_kfold_comparison.tex && pdfcrop Table_01_model_kfold_comparison.pdf Table_01_model_kfold_comparison.pdf

# Remove extraneous files
rm Table_01_model_kfold_comparison.log Table_01_model_kfold_comparison.aux

# Convert pdf to png
pdftoppm -r 350 Table_01_model_kfold_comparison.pdf Table_01_model_kfold_comparison -png

# Latex to pdf
xelatex Table_02_model_effects.tex && pdfcrop Table_02_model_effects.pdf Table_02_model_effects.pdf

# Remove extraneous files
rm Table_02_model_effects.log Table_02_model_effects.aux

# Convert pdf to png
pdftoppm -r 350 Table_02_model_effects.pdf Table_02_model_effects -png

echo "DONE"
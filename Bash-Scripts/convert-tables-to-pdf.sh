#!/usr/bin/env bash

cd Figures

echo "Converting tables..."

xelatex Table_01_model_kfold_comparison.tex && pdfcrop Table_01_model_kfold_comparison.pdf Table_01_model_kfold_comparison.pdf

rm Table_01_model_kfold_comparison.log Table_01_model_kfold_comparison.aux

xelatex Table_02_model_effects.tex && pdfcrop Table_02_model_effects.pdf Table_02_model_effects.pdf

rm Table_02_model_effects.log Table_02_model_effects.aux

echo "DONE"
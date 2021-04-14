#!/bin/bash

cd ../Manuscript/

pandoc --filter pandoc-citeproc --pdf-engine=xelatex turdus-dichromatism-ABL.md -o turdus-dichromatism-ABL.pdf 
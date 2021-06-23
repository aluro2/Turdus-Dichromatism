#!/usr/bin/env bash

echo "Converting documents..."

# Convert to pdf
docker run --rm -v $PWD:/pandoc -w /pandoc/ dalibo/pandocker --citeproc -s --mathjax -f markdown --pdf-engine=xelatex Manuscript/turdus-dichromatism-ABL.md -o Manuscript/turdus-dichromatism-ABL.pdf

# Convert to raw LaTeX
docker run --rm -v $PWD:/pandoc -w /pandoc/ dalibo/pandocker --citeproc -s --reference-link --bibliography=Manuscript/Turdus-Dichromatism.bib --csl=Manuscript/proceedings-of-the-royal-society-b.csl -f markdown Manuscript/turdus-dichromatism-ABL.md -o Manuscript/turdus-dichromatism-ABL.tex

# Convert to docx
docker run --rm -v $PWD:/pandoc -w /pandoc/ dalibo/pandocker --citeproc -s -f markdown Manuscript/turdus-dichromatism-ABL.md -o Manuscript/turdus-dichromatism-ABL.docx

echo "DONE"
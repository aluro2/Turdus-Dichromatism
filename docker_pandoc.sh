#!/usr/bin/env bash

# Convert to pdf
docker run --rm -v $PWD:/pandoc -w /pandoc/ dalibo/pandocker --citeproc --mathjax -f markdown --pdf-engine=xelatex Manuscript/turdus-dichromatism-ABL.md -o Manuscript/turdus-dichromatism-ABL.pdf

# Convert to raw LaTeX
docker run --rm -v $PWD:/pandoc -w /pandoc/ dalibo/pandocker --citeproc --mathjax -f markdown Manuscript/turdus-dichromatism-ABL.md -o Manuscript/turdus-dichromatism-ABL.tex

# Convert to docx
docker run --rm -v $PWD:/pandoc -w /pandoc/ dalibo/pandocker --citeproc --template=Manuscript/10_SUBMIT.docx Manuscript/turdus-dichromatism-ABL.md -o Manuscript/turdus-dichromatism-ABL.docx
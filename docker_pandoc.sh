#!/usr/bin/env bash

#docker run --rm -v $PWD:/data -w /data/ pandoc/latex:latest --citeproc --pdf-engine=xelatex Manuscript/turdus-dichromatism-ABL.md -o Manuscript/turdus-dichromatism-ABL.pdf

docker run --rm -v $PWD:/pandoc -w /pandoc/ dalibo/pandocker --citeproc --mathjax --pdf-engine=xelatex Manuscript/turdus-dichromatism-ABL.md -o Manuscript/turdus-dichromatism-ABL.pdf

docker run --rm -v $PWD:/pandoc -w /pandoc/ dalibo/pandocker --citeproc Manuscript/turdus-dichromatism-ABL.md -o Manuscript/turdus-dichromatism-ABL.docx
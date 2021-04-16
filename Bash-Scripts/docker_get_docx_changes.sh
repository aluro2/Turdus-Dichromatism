#!/usr/bin/env bash



# Convert docx to Markdown with tracked changes
docker run --rm -v $PWD:/pandoc -w /pandoc/ dalibo/pandocker --citeproc --track-changes=all -f docx Manuscript/turdus-dichromatism-ABL.docx -o Manuscript/DOCX-CHANGES.md
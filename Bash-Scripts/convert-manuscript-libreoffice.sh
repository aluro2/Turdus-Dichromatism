#!/bin/bash

cd Manuscript

libreoffice --headless --convert-to odt turdus-dichromatism-ABL.fodt

echo "Conversion to .odt complete!"

libreoffice --headless --convert-to docx turdus-dichromatism-ABL.odt

echo "Conversion to .docx complete!"
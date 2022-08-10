#!/bin/bash
# Avital Pinnick, 2021
# Builds html and docx files

SOURCE=html_files
DEST=docx_files

# delete current build
rm -fr $SOURCE
rm -fr $DEST

# build HTML files
./build_tools/build_html.sh

# build DOCX files
echo "Converting HTML to DOCX:"

mkdir $DEST
for f in $SOURCE/*.html; do
  echo "- $(basename "${f%%.*}").docx"
  pandoc -o $DEST/$(basename "${f%%.*}").docx $f
done

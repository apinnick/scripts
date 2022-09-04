#!/bin/bash
# Avital Pinnick, 2021
# Builds html and odt files
# This is for testing. Actual build is done in GitLab CI.

SOURCE=html_files
DEST=odt_files

# delete current build
rm -fr $SOURCE
rm -fr $DEST

# build HTML files
./build_tools/build_html.sh

# build DOCX files
echo "Converting HTML to ODT:"

mkdir $DEST
for f in $SOURCE/*.html; do
  echo "- $(basename "${f%%.*}").odt"
  pandoc -o $DEST/$(basename "${f%%.*}").odt $f
done

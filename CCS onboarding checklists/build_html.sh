#!/bin/bash
# Avital Pinnick, 2021
# Builds HTML versions of the checklists and saves them in "docs/build"

FILES=`find docs -name 'master.adoc'`
DEST=html_files

# remove build directory
rm -fr $DEST
mkdir -p $DEST

echo "Building HTML files:"
for f in $FILES; do
  FILENAME=$(grep "^= .*" $f | sed -e 's/= //; s/ /_/g; s/\(.*\)/\L\1/' )
  echo "- $FILENAME.html"
  asciidoctor --failure-level WARN -b xhtml5 -d book -o $DEST/$FILENAME.html $f
done

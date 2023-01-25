#!/bin/bash
# Avital Pinnick, Jan. 25, 2023
# This script generates a list of package names from the Build tab of the errata tool
# Copy the contents of the builds tab and save as a text file.
#
# Usage: $ ./errata-build-list.sh <build.txt>

if [ -z "$1" ];
then
  printf '\nYou must specify a build file.\n\nExiting...\n\n'
  exit 2
fi

OLD_LIST=$1
NEW_LIST=new-build-list.txt

cp $OLD_LIST ./$NEW_LIST

sed -i 's/^Product.*//g; s/^Non-RPM.*//g; s/^tar.*//g; s/^unsigned.*//g' $NEW_LIST
sed -i '/^$/d' $NEW_LIST
sort -o $NEW_LIST{,}

echo -e "Generated $NEW_LIST"

echo -e "Done\n"

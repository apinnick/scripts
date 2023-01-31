#!/bin/bash
# Avital Pinnick, Jan. 25, 2023
# This script generates a list of package names from text copied from the Build tab of the Errata Tool.
# Copy the contents of the Builds tab to a text file and run the script.
#
# Usage: $ ./errata-build-list.sh <build.txt>

if [ -z "$1" ];
then
  printf '\nYou must specify a target file.\n\nExiting...\n\n'
  exit 2
fi

OLD_LIST=$1
NEW_LIST=clean-package-list.txt

rm $NEW_LIST &>/dev/null
cp $OLD_LIST ./$NEW_LIST

# Remove unwanted text
sed -i 's/^Product.*//g; s/^Non.*//g; s/^tar.*//g; s/^unsigned.*//g; s/^Remove.*//g' $NEW_LIST
# Remove blank lines
sed -i '/^$/d' $NEW_LIST
# Sort list alphabetically
sort -o $NEW_LIST{,}

echo -e "\nGenerated ./$NEW_LIST with $(cat $NEW_LIST | wc -l) lines"
echo -e "Done\n"

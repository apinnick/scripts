#!/bin/bash

# Avital Pinnick, March 25, 2024
# Script to change "title case" headers and captions to "sentence case".

# I recommend trying this on a small number of files in case the results are unexpected.
# How to use this script:
if [ -z "$1" ];
then
  printf '\nYou must specify a target directory. Optional: file name string.\n\nExamples:\n$ ./title-case.sh modules ref_a* (for reference modules beginning with "ref_a*")\n$ ./title-case.sh modules (all files in directory)\n\nExiting...\n\n'
  exit 2
fi

if [ -z "$2" ];
then
  STRING=""
fi

DIR=$1
STRING=$2

# Changes headers to sentence case: "= My Header" to "= My header","= My Sub-Section" to "= My sub-section"
HEADERS='/^=/s/\([A-Za-z0-9}]\) \([A-Z][a-z]\)/\1 \L\2/g;/^=/s/\([A-Za-z0-9}]\)-\([A-Z]\)/\1-\L\2/g'
# Changes captions to sentence case: ".My Caption" to ".My caption",".My Sub-Section" to ".My sub-section"
CAPTIONS='/^\.[A-Za-z0-9}]/s/\([A-Za-z0-9}]\) \([A-Z][a-z]\)/\1 \L\2/g;/^\.[A-Za-z0-9}]/s/\([A-Za-z0-9}]\)-\([A-Z][a-z]\)/\1-\L\2/g'

# Single names that you want to exclude are defined in "exclude.txt".
# The first letter of the name must be lower case: "ansible","iPv6", etc.

# Compound names that you want to exclude are defined in "complex_lc" array and replaced by "complex_uc" array.
# This solution is not very pretty, so I might try to find something better.
complex_lc=("[Cc]entOS stream" "[Ss]alt minion" "[Aa]mazon web service" "[Aa]zure resource manager" \
  "[Pp]uppet agent" "[Ii]nsights inventory" "[Hh]at cloud" "[Tt]ransparent hugepage" "release files"\
  "[Cc]ontent delivery network" "[Hh]at identity management" "[Hh]ybrid cloud console" "[Aa]ctive directory")

complex_uc=("CentOS Stream" "Salt Minion" "Amazon Web Service" "Azure Resource Manager" \
  "Puppet Agent" "Insights Inventory" "Hat Cloud" "Transparent Hugepage" "Release files" \
  "Content Delivery Network" "Hat Identity Management" "Hybrid Cloud Console" "Active Directory")

for file in $DIR$STRING; do
  sed -i -e "$HEADERS" $file
  sed -i -e "$CAPTIONS" $file

  # "Exclude" list: This line maps the "exclude.txt" file to the EXCLUDE array.
  mapfile -t EXCLUDE < exclude.txt

  # Fix names on the "exclude.txt" list
  for name in ${EXCLUDE[@]}; do
    sed -i -e "/^=/s/\b\($name\)/\u\0/g;/^\.[A-Za-z0-9}]/s/\b\($name\)/\u\0/g" $file
  done
  # Fix compound names
  for index in "${!complex_lc[@]}"; do
    sed -i -e "/^=/s/${complex_lc[$index]}/${complex_uc[$index]}/g;/^\.[A-Za-z0-9}]/s/${complex_lc[$index]}/${complex_uc[$index]}/g" $file
  done
done


#!/bin/bash
# Avital Pinnick, April 1, 2024
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
  STRING=*
fi

DIR=$1
STRING=$2

echo $DIR
echo $STRING

# Changes single and hyphenated words in headers to sentence case.
# Examples: "= My Header" to "= My header","= My Sub-Section" to "= My sub-section"
HEADERS='/^=/s/\([A-Za-z0-9}]\) \([A-Z][a-z]\)/\1 \L\2/g;/^=/s/\([A-Za-z0-9}]\)-\([A-Z][a-z]\)/\1-\L\2/g'

# Changes single and hyphenated words in captions to sentence case.
# Examples: ".My Caption" to ".My caption",".My Sub-Section" to ".My sub-section"
CAPTIONS='/^\.[A-Za-z0-9}]/s/\([A-Za-z0-9}]\) \([A-Z][a-z]\)/\1 \L\2/g;/^\.[A-Za-z0-9}]/s/\([A-Za-z0-9}]\)-\([A-Z][a-z]\)/\1-\L\2/g'

# Excluding terms:

# Single-word names are defined in "exclude.txt". The first letter of the name must be lower case: "ansible","iPv6", etc.
# The "exclude.txt" file is mapped to the EXCLUDE array.
mapfile -t EXCLUDE < <(sed 's/^\([A-Za-z]\)/\l\1/g' exclude.txt)

# Compound names are defined in "complex_lc" array and replaced by "complex_uc" array.
# They are listed here because reading them from a file does not work if string contains spaces.
# This solution is not very pretty, so I might try to find something better.
complex_lc=("[Cc]entOS stream" "[Ss]alt minion" "[Aa]zure resource manager" \
  "[Ii]nsights inventory" "[Hh]at cloud" "[Tt]ransparent hugepage" "release files" \
  "[Cc]ontent delivery network" "[Hh]at identity management" "[Hh]ybrid cloud console" \
  "[Aa]ctive directory" "[Rr]ed [Hh]at" "[Aa]mazon web service" "[Gg]oogle compute engine" \
  "[Ss]alt client" "[Ss]alt master" "[Aa]nsible collections" "[Aa]nsible vault" )

complex_uc=("CentOS Stream" "Salt Minion" "Azure Resource Manager" \
  "Insights Inventory" "Hat Cloud" "Transparent Hugepage" "Release files" \
  "Content Delivery Network" "Hat Identity Management" "Hybrid Cloud Console" \
  "Active Directory" "Red Hat" "Amazon Web Service" "Google Compute Engine" \
  "Salt Client" "Salt Master" "Ansible Collections" "Ansible Vault" )

for file in $DIR/$STRING*; do
  echo Checking $file
  sed -i -e "$HEADERS" $file
  sed -i -e "$CAPTIONS" $file
  # Fix names on the "exclude.txt" list
  for name in ${EXCLUDE[@]}; do
    sed -i -e "/^=/s/\($name\)/\u\0/g;/^\.[A-Za-z0-9}]/s/\($name\)/\u\0/g" $file
  done
  # Fix compound names
  for index in "${!complex_lc[@]}"; do
    sed -i -e "/^=/s/${complex_lc[$index]}/${complex_uc[$index]}/g;/^\.[A-Za-z0-9}]/s/${complex_lc[$index]}/${complex_uc[$index]}/g" $file
  done
done

echo Done
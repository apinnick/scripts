#!/bin/bash
# Avital Pinnick, Sept. 30, 2024
# This script counts the number of steps in a group of modules.
# If the number of steps exceeds a certain number, the script outputs the file name and the number of steps and substeps to a text file.
#
# Usage: ./find-long-procedures.sh <directory> <string>

if [ -z "$1" ];
then
  printf '
Usage: $ ./find-long-procedures.sh </directory> OPT:<file_name_string>.
Examples:
  * All files in specified directory: "$ ./find-long-procedures.sh ../openshift-docs/virt/install"
  * File names starting with "proc_a" in specified directory: "$ ./find-long-procedures.sh ../openshift-docs/modules proc_a*"

Exiting...\n\n'
  exit 2
fi

if [ -z "$2" ];
then
  STRING=*
fi

# relative path from where you are running this script. Example: ../foreman-documentation/guides/common/modules
DIR=$1
# file name string. Example: proc_a*
STRING=$2
# Max number of steps to search for
MAX_STEPS=10

rm long-procedures.txt &>/dev/null

echo -e "Files in $DIR with more than $MAX_STEPS steps\n" > long-procedures.txt

for file in $DIR/*$STRING*.adoc; do
  steps="$(grep -E '^\. [A-Z]' $file | wc -l)"
  substeps="$(grep -E '^\.. [A-Z]' $file | wc -l)"
  filename="$(basename $file)"
  if (("$steps" >= "$MAX_STEPS")); then
  echo - $filename: $steps steps, $substeps substeps >> long-procedures.txt
  fi
done

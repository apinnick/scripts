#!/bin/bash
# Avital Pinnick, Oct. 1, 2024
# This script counts the number of steps in a group of modules.
# If the number of steps exceeds a certain number, the script outputs the directory,file name, # of steps and # of substeps to a CSV file.
# Usage: ./find-long-procedures.sh <directory> <string>

if [ -z "$1" ];
then
  printf '
Usage: $ ./find-long-procedures.sh </directory> OPT:<file_name_string>
Examples:
  * All files in specified directory: "$ ./find-long-procedures.sh ../openshift-docs/virt/install"
  * File names starting with "proc_a" in specified directory: "$ ./find-long-procedures.sh ../openshift-docs/modules proc_a*"
    NOTE: You must leave a space between the directory and the file name string.

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

output="long-procedures.csv"

rm $output &>/dev/null

echo "Directory,File,# steps,# substeps" > $output

for file in $DIR/*$STRING*.adoc; do
  steps="$(grep -E '^\. [A-Z]' $file | wc -l)"
  substeps="$(grep -E '^\.. [A-Z]' $file | wc -l)"
  filename="$(basename $file)"
  if (("$steps" >= "$MAX_STEPS")); then
  echo -e ${DIR#../},$filename,$steps,$substeps >> $output
  i=$((i+1))
  fi
done

echo -e "\nDone. '$output' contains $i files."

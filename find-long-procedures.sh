#!/bin/bash
# Avital Pinnick, Sept. 30, 2024
# This script counts the number of steps in a group of modules. Then, it outputs the file names and number of steps to a text file.
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

for file in $DIR/*$STRING*.adoc; do
  # grep -E '^\.{1,3} [A-Z]' $file | wc -l
  steps="$(grep -E '^\.{1,3} [A-Z]' $file | wc -l)"
  filename="$(basename $file)"
  if (("$steps" >= "$MAX_STEPS")); then
  echo - $filename has $steps steps >> long-procedures.txt
  fi
done
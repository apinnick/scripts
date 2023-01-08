#!/bin/bash
# Avital Pinnick, December 29, 2022
# This script generates a CSV file showing the last commit date for files.
# Useful for identifying files that might be abandoned or obsolete.
# This script is not recursive. It only searches the specified directory.
#
# Usage: $ ./csv-last-commit.sh </directory> OPT:<file_name_string>

if [ -z "$1" ];
then
  printf '\nYou must specify a target directory. Optional: file name string.\n\nExamples:\n$ ./csv-last-commit.sh ../openshift-docs/modules virt- (for file names containing "virt-")\n$ ./csv-last-commit.sh ../openshift-docs/virt/install (all files in directory)\n\nExiting...\n\n'
  exit 2
fi

if [ -z "$2" ];
then
  STRING=*
fi

DIR=$1
STRING=$2
TOTAL=$(ls -l $DIR/*$STRING* | grep 'adoc\|md' | wc -l )
LAST_COMMIT=last-commit.csv

rm $LAST_COMMIT  &>/dev/null

# echo -e "Last Git commit for $TOTAL files containing '$STRING' in $DIR:\n" > $LAST_COMMIT

echo "File,Date,Name,Hash,Message" > $LAST_COMMIT

for file in $DIR/*$STRING*; do
  if [ ! -d "$file" ]; then
    echo -e $(basename $file), | tr -d \\n >> $LAST_COMMIT
    git -C "$DIR" log -n 1 --date=short --pretty=format:"%cd,%cn,%h,%s%n" $(basename $file) >> $LAST_COMMIT
  fi
done

echo -e "\nGenerated './$LAST_COMMIT'.\nDone\n"

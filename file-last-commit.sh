#!/bin/bash
# Avital Pinnick, December 29, 2022
# This script generates a list of files, showing the last commit date.
# Useful for identifying files that might be abandoned or obsolete.
# Usage: $ ./file-last-commit.sh </directory> OPT:<file_name_string>

if [ -z "$1" ];
then
  printf 'You must specify a directory. Optional: File name string.\n\nExamples:\n$ ./file-last-commit.sh ../openshift-docs/modules virt- (for module names containing "virt-")\n$ ./file-last-commit.sh ../openshift-docs/virt/install (all files)\n\nExiting...\n\n'
  exit 2
fi

if [ -z "$2" ];
then
  STRING=*
fi

DIR=$1
STRING=$2
TOTAL=$(ls -1 $DIR/*$STRING*.adoc | wc -l)
LAST_COMMIT=file-last-commit.txt

echo -e "Last Git commit for $TOTAL files containing '$STRING' in $DIR:\n" > $LAST_COMMIT

for file in $DIR/*$STRING*; do
  if [ ! -d "$file" ]; then
    echo -e $(basename $file) >> $LAST_COMMIT
    git -C "$DIR" log -n 1 --date=short --pretty=format:"%cr: %cn %cd, %h %s %n" $(basename $file) >> $LAST_COMMIT
    echo "" >> $LAST_COMMIT
  fi
done

echo -e "\nGenerated './$LAST_COMMIT' with last commit for $TOTAL files containing '$STRING' in '$DIR'."
echo Done
#!/bin/bash
# Avital Pinnick, Jan. 10, 2022
# This script generates a list of files, showing the last commit date.
# Useful for identifying files that might be abandoned or obsolete.
# This script is not recursive. It only searches the specified directory.
#
# Usage: $ ./file-last-commit.sh </directory> OPT:<file_name_string>

if [ -z "$1" ];
then
  printf '\nYou must specify a target directory. Optional: file name string.\n\nExamples:\n$ ./file-last-commit.sh ../openshift-docs/modules virt- (for file names containing "virt-")\n$ ./file-last-commit.sh ../openshift-docs/virt/install (all files in directory)\n\nExiting...\n\n'
  exit 2
fi

if [ -z "$2" ];
then
  STRING=""
fi

DIR=$1
STRING=$2
TOTAL=$(ls -l $DIR/*$STRING* | grep 'adoc\|md' | wc -l )
LAST_COMMIT=file-last-commit.txt

echo -e "\nGenerating './$LAST_COMMIT' with last Git commit for $TOTAL files in $DIR."

echo -e "Last Git commit for $TOTAL files in $DIR:\n" > $LAST_COMMIT

for file in $DIR/*$STRING*; do
  if [ ! -d "$file" ]; then
    echo -e $(basename $file) >> $LAST_COMMIT
    git -C "$DIR" log -n 1 --date=short --pretty=format:"%cr: %cn %cd, %h %s %n" $(basename $file) >> $LAST_COMMIT
    echo "" >> $LAST_COMMIT
  fi
done

echo -e "Done\n"

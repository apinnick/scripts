#!/bin/bash
# Avital Pinnick, December 28, 2022
# This script generates a file containing a list of the last commit for each file in a directory.
# Usage: $ ./file-last-commit.sh <target_directory>

if [ -z "$1" ];
then
  printf 'No directory specified.\n\nUsage: $ ./file-last-commit.sh <target_directory>\n\nExiting...\n\n'
  exit 2
fi

DIR=$1
LAST_COMMIT=file-last-commit.txt

echo -e "Most recent Git commit for files in $DIR:\n" > $LAST_COMMIT

for file in $DIR/*; do
  echo -e "$(basename $file):" >> $LAST_COMMIT
  # '-n' sets the number of commits to display.
  git -C "$DIR" log -n 1 --date=short --pretty=format:"  %cn %cd (%cr)%n  %h: %s %n" $(basename $file) >> $LAST_COMMIT
  echo "" >> $LAST_COMMIT
done

echo -e "\nGenerated './$LAST_COMMIT' with most recent Git commit for files in '$DIR'."
echo Done
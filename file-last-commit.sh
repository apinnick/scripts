#!/bin/bash
# Avital Pinnick, December 8, 2022
# This script shows the last commit for each file in a directory.
# Use it to detect changes made to files since your last commit.
# Usage
# Example: $ ./file-last-commit.sh <target_directory>

if [ -z "$1" ];
then
  printf 'No directory specified.\n\nUsage: $ ./file-last-commit.sh <target_directory>\n\nExiting...\n\n'
  exit 2
fi

DIR=$1
LAST_COMMIT=last_commit.txt

echo -e "\nMost recent Git commit for files in $DIR:\n" > $LAST_COMMIT

for file in $DIR/*; do
  echo -e "$(basename $file):" >> $LAST_COMMIT
  # '-n' sets the number of commits to display.
  git -C "$DIR" log -n 1 --pretty=format:"- %an, %ad %h: %s %n" $(basename $file) >> $LAST_COMMIT
  echo "" >> $LAST_COMMIT
done

echo -e "Generated '$LAST_COMMIT' with most recent Git commit for files in '$DIR'."
echo Done
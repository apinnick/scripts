#!/bin/bash
# Avital Pinnick, April 2025
# Finds modules containing level 2+ headers in a directory and outputs a list
# Usage: ./find-subheadings.sh <directory>

if [ -z "$1" ];
then
  printf '
Usage: $ ./find-subheadings.sh </directory>
Exiting...\n\n'
  exit 2
fi

# relative path from where you are running this script. Example: ../foreman-documentation/guides/common/modules
DIR=$1

output="Output.txt"
rm $output &>/dev/null

echo -e "Checking '/$DIR' for files with level 2+ headers."

echo -e "Files in '/$DIR' with level 2+ headers:\n" > $output

for file in $DIR/*.adoc; do
  subheader_number="$(grep -E '^={2,5} .' $file | wc -l)"
  filename="$(basename $file)"
  if (("$subheader_number" >= "1")); then
  echo -e $filename - $subheader_number >> $output
  i=$((i+1))
  fi
done

if [ "$i" > "0" ]; then
  echo -e "Done. $output contains $i files.";
  else
  echo "Done. No files with level 2+ headers found.";
  rm $output &>/dev/null
fi


#!/bin/bash
# IN PROGRESS

OUTPUT="CQA-report.md"
rm $OUTPUT &>/dev/null

echo -e "# CQA report\n" > $OUTPUT
echo -e "This report describes Content Quality Assessment issues found in Asciidoc files.\n" >> $OUTPUT

# ASSEMBLY CHECKS
echo -e "## Assembly checks\n" >> $OUTPUT

echo -e "TBD\n" >> $OUTPUT

echo -e "## Module checks\n" >> $OUTPUT

# LONG PROCEDURES
echo -e "### Long procedures\n\nFinds modules with more than 10 steps, regardless of conditionalization.\n" >> $OUTPUT
echo -e "Result:" >> $OUTPUT
while IFS= read -r filepath; do
  steps="$(grep -E '^\. [A-Z]' $filepath | wc -l)"
  filename="$(basename $filepath)"
  if (("$steps" >= "10")); then
    echo - $filename >> $OUTPUT
    i=$((i+1))
  fi
done < module-list.txt
if [[ "$i" == "" ]]; then
  echo "No long procedures found." >> $OUTPUT
fi


# assembly checks

# while IFS= read -r filepath; do
#   echo hello assembly!
# done < assembly.txt
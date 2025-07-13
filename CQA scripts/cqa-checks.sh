#!/bin/bash
# IN PROGRESS


OUTPUT="CQA-report.md"
rm $OUTPUT &>/dev/null

echo -e "# CQA report\n" > $OUTPUT
echo -e "This report describes Content Quality Assessment issues found in Asciidoc files.\n" >> $OUTPUT

# Check if assembly.txt exists
if [[ ! -f "assembly.txt" ]]; then
  echo "Error: assembly.txt not found!"
  rm $OUTPUT &>/dev/null
  exit 1
fi

# ASSEMBLY CHECKS
echo -e "\n## Assembly checks\n" >> $OUTPUT

# Check for content type attribute
echo -e "**Missing content type attribute**\n" >> $OUTPUT
cat assembly.txt | xargs -I {} sh -c '
  # Check if the specific line *is* present in the file
  if grep -P "^:_mod-docs-content-type: ASSEMBLY" "$1" > /dev/null; then
    # If it *is* present, do nothing (or handle the "present" case)
    : # A no-op command
  else
    # If it is *not* present (grep returned 1), then print the file name
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# Check assembly for more than one title (= )
echo -e "**More than one title (= ) found**\n" >> $OUTPUT
cat assembly.txt | xargs -I {} sh -c '
  count=$(grep -P -c "^= [A-Za-z0-9]" "$1")
  if [ "$count" -ge 2 ]; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# Check assembly for level 2 (=== ) header
echo -e "**Level 2 header (=== ) found**\n" >> $OUTPUT
# Use xargs to process files in parallel (or sequentially if -P 1)
# -P 0 uses as many processes as possible, or specify a number like -P 4
# -I {} replaces {} with each argument
cat assembly.txt | xargs -I {} sh -c '
  if grep -P "^=== [A-Z0-9].*" "$1" > /dev/null; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# Module checks
echo -e "## Module checks\n" >> $OUTPUT

# Check for content type attribute
echo -e "**Missing content type attribute**\n" >> $OUTPUT
cat module-list.txt | xargs -I {} sh -c '
  # Check if the specific line *is* present in the file
  if grep -P "^:_mod-docs-content-type: (CONCEPT|REFERENCE|PROCEDURE)" "$1" > /dev/null; then
    # If it *is* present, do nothing (or handle the "present" case)
    : # A no-op command
  else
    # If it is *not* present (grep returned 1), then print the file name
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# LONG PROCEDURE
echo -e "**Long procedure found**\n" >> $OUTPUT
cat module-list.txt | xargs -I {} sh -c '
  filepath="$1"
  steps=$(grep -E "^\. [A-Z]" "$filepath" | wc -l)
  filename=$(basename "$filepath")
  if (( steps >= 10 )); then
    echo "- $filename"
    i=$((i+1))
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# Forbidden text block
echo -e "**Forbidden text block**" >> $OUTPUT
cat module-list.txt | xargs -I {} sh -c '
  if grep -iPq "^\.(?! |Prerequisites|Procedure|Troubleshooting|Next|Additional|Verification)" "$1"; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# More than one procedure block
echo -e "**More than one procedure block**" >> $OUTPUT
cat module-list.txt | xargs -I {} sh -c '
  count=$(grep -P -c "^\.Procedure" "$1")
  if [ "$count" -ge 2 ]; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# Procedure embellishment
echo -e "**Procedure embellishment**\n" >> $OUTPUT
cat module-list.txt | xargs -I {} sh -c '
  if grep -P "^\.Procedure.+" "$1"; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

echo "Done. CQA-report.md created."

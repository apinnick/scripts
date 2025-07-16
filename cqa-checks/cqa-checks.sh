#!/bin/bash
# Avital Pinnick, 2025

# To be parameterized
MODULE_PATH=../foreman-documentation/guides/common/modules

OUTPUT="CQA-report.md"
rm $OUTPUT &>/dev/null

echo -e "# CQA report\n" > $OUTPUT
echo -e "This report describes Content Quality Assessment issues found in Asciidoc assemblies and modules.\n" >> $OUTPUT

# Check if assembly.txt exists
if [[ ! -f "assembly.txt" ]]; then
  echo "Error: assembly.txt not found!"
  rm $OUTPUT &>/dev/null
  exit 1
fi

# Check if module-list.txt exists
if [[ ! -f "module-list.txt" ]]; then
  echo "Error: module-list.txt not found!"
  rm $OUTPUT &>/dev/null
  exit 1
fi

# Add path to module-list.txt
# sed -i 's|^|../foreman-documentation/guides/common/modules/|' module-list.txt

# File checks
echo -e "## File checks\n" >> $OUTPUT

# Check for content type attribute
echo -e "**Content type attribute missing**\n" >> $OUTPUT
cat assembly.txt module-list.txt | xargs -I {} sh -c '
  # Check if the specific line *is* present in the file
  if grep -P "^:_mod-docs-content-type: " "$1" > /dev/null; then
    # If it *is* present, do nothing (or handle the "present" case)
    : # A no-op command
  else
    # If it is *not* present (grep returned 1), then print the file name
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# Anchor ID
echo -e "**ID missing**\n" >> $OUTPUT
cat assembly.txt module-list.txt | xargs -I {} sh -c '
  # Check if the specific line *is* present in the file
  if grep -P "^\[id.*\]" "$1" > /dev/null; then
    # If it *is* present, do nothing (or handle the "present" case)
    : # A no-op command
  else
    # If it is *not* present (grep returned 1), then print the file name
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# Long titles
echo -e "**Header > 10 words found**\n" >> $OUTPUT
cat assembly.txt module-list.txt | xargs -I {} sh -c '
    # Find lines starting with "= ", "== ", or "=== "
    grep -E "^={1,3} " "$1" | while IFS= read -r line; do
        # Remove the leading "={1,3} " and count the words
        word_count=$(echo "$line" | sed -E "s/^={1,3} //" | wc -w)
        # Check if word count is greater than 10
        if [ "$word_count" -gt 10 ]; then
            echo "- $1"
            # Break the inner loop and go to the next file if a match is found
            break
        fi
    done
' _ {} >> $OUTPUT

echo -e "\n_Done_\n" >> $OUTPUT

# Admonition titles
# [NOTE], [WARNING], etc., must not be followed by a block title.
echo -e "**Admonition with title found**\n" >> $OUTPUT
cat assembly.txt module-list.txt | xargs -I {} sh -c '
  if grep -Pzo "(?s)\[[A-Z]+\]\n\.[A-Za-z].*" "$1" > /dev/null; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# Image without text description
echo -e "**Image without description found**\n" >> $OUTPUT
cat assembly.txt module-list.txt | xargs -I {} sh -c '
  if grep -E "^image.*\[\]$" "$1" > /dev/null; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# ASSEMBLY CHECKS
echo -e "\n## Assembly module checks\n" >> $OUTPUT

# Check assembly for more than one title (= )
echo -e "**More than one '= ' header found**\n" >> $OUTPUT
cat assembly.txt | xargs -I {} sh -c '
  count=$(grep -P -c "^= [A-Za-z0-9]" "$1")
  if [ "$count" -ge 2 ]; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# Check assembly for '=== ' header
echo -e "**'=== ' header found**\n" >> $OUTPUT
# Use xargs to process files in parallel (or sequentially if -P 1)
# -P 0 uses as many processes as possible, or specify a number like -P 4
# -I {} replaces {} with each argument
cat assembly.txt | xargs -I {} sh -c '
  if grep -P "^=== [A-Z0-9].*" "$1" > /dev/null; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# Check for block titles
echo -e "**Block title found**" >> $OUTPUT
cat assembly.txt | xargs -I {} sh -c '
  if grep -P "^\." "$1" > /dev/null; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# PROCEDURES
echo -e "## Procedure module checks\n" >> $OUTPUT

# Procedure with '== ' header
echo -e "**'== ' header found**" >> $OUTPUT
cat module-list.txt | xargs -I {} sh -c '
  if grep -P "^:_mod-docs-content-type: PROCEDURE" "$1" > /dev/null; then
    if grep -P "^== [A-Z0-9].*" "$1" > /dev/null; then
    echo "- $1"
    fi
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# LONG PROCEDURE
echo -e "**Procedure > 10 steps found**" >> $OUTPUT
cat module-list.txt | xargs -I {} sh -c '
  steps=$(grep -E "^\. [A-Z]" "$1" | wc -l)
  if (( steps >= 10 )); then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# Impermissible block title
# Might have to split this.
echo -e "**Impermissible block title found**\n" >> $OUTPUT
echo -e "Block titles other than Prerequisites, Procedure, Troubleshooting, Next steps, Additional resources, Verification\n" >> $OUTPUT
cat module-list.txt | xargs -I {} sh -c '
  if grep -iPq "^\.(?!\.{1,3}|\s[A-Z]|Prerequisites|Procedure|Troubleshooting|Next steps|Additional resources|Verification).*" "$1"; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# More than one procedure
echo -e "**More than one procedure found**" >> $OUTPUT
cat module-list.txt | xargs -I {} sh -c '
  count=$(grep -P -c "^\.Procedure" "$1")
  if [ "$count" -ge 2 ]; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# Procedure embellishment
echo -e "**Incorrect 'Procedure' title found**\n" >> $OUTPUT
echo -e "Example: Procedure for upgrading\n" >> $OUTPUT
cat module-list.txt | xargs -I {} sh -c '
  if grep -Pq "^\.Procedure.+" "$1"; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# END
echo "Done. CQA-report.md created."

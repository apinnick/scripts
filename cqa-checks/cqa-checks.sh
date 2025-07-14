#!/bin/bash
# Avital Pinnick, 2025

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

# File checks
echo -e "## File checks\n" >> $OUTPUT

# Check for content type attribute
echo -e "**Missing content type attribute**\n" >> $OUTPUT
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
echo -e "**Missing ID**\n" >> $OUTPUT
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

# Admonition titles
# [NOTE], [WARNING], etc., must not be followed by a block title.
echo -e "**Admonition title**\n" >> $OUTPUT
cat assembly.txt module-list.txt | xargs -I {} sh -c '
  if grep -Pzo "(?s)\[[A-Z]+\]\n\.[A-Za-z].*" "$1" > /dev/null; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# ASSEMBLY CHECKS
echo -e "\n## Assembly module checks\n" >> $OUTPUT

# Check assembly for more than one title (= )
echo -e "**More than one '= ' header**\n" >> $OUTPUT
cat assembly.txt | xargs -I {} sh -c '
  count=$(grep -P -c "^= [A-Za-z0-9]" "$1")
  if [ "$count" -ge 2 ]; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# Check assembly for '=== ' header
echo -e "**'=== ' header**\n" >> $OUTPUT
# Use xargs to process files in parallel (or sequentially if -P 1)
# -P 0 uses as many processes as possible, or specify a number like -P 4
# -I {} replaces {} with each argument
cat assembly.txt | xargs -I {} sh -c '
  if grep -P "^=== [A-Z0-9].*" "$1" > /dev/null; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# Check for consecutive includes (in progress)
echo -e "**Consecutive includes (WIP)**" >> $OUTPUT
cat assembly.txt | xargs -I {} sh -c '
  if grep -Pzo '^include::.*\ninclude*$' "$1" > /dev/null; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# "^\s*\n\s*$"

# Check for block titles
echo -e "**Block title (.text)**" >> $OUTPUT
cat assembly.txt | xargs -I {} sh -c '
  if grep -P "^\." "$1" > /dev/null; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# PROCEDURES
echo -e "## Procedure module checks\n" >> $OUTPUT

# Procedure with '== ' header
echo -e "**'== ' header**" >> $OUTPUT
cat module-list.txt | xargs -I {} sh -c '
  if grep -P "^:_mod-docs-content-type: PROCEDURE" "$1" > /dev/null; then
    if grep -P "^== [A-Z0-9].*" "$1" > /dev/null; then
    echo "- $1"
    fi
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# LONG PROCEDURE
echo -e "**More than 10 steps**" >> $OUTPUT
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

# Impermissible block title
# Might have to split this.
echo -e "**Impermissible block title**\n" >> $OUTPUT
echo -e "Permitted block titles: Prerequisites, Procedure, Troubleshooting, Next steps, Additional resources, Verification\n" >> $OUTPUT
cat module-list.txt | xargs -I {} sh -c '
  if grep -iPq "^\.(?!\.{1,3}|\s[A-Z]|Prerequisites|Procedure|Troubleshooting|Next steps|Additional resources|Verification).*" "$1"; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# More than one procedure
echo -e "**More than one procedure block**" >> $OUTPUT
cat module-list.txt | xargs -I {} sh -c '
  count=$(grep -P -c "^\.Procedure" "$1")
  if [ "$count" -ge 2 ]; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# Procedure embellishment
echo -e "**Procedure title embellishment**\n" >> $OUTPUT
echo -e "Example: Procedure for upgrading\n" >> $OUTPUT
cat module-list.txt | xargs -I {} sh -c '
  if grep -Pq "^\.Procedure.+" "$1"; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# END
echo "Done. CQA-report.md created."

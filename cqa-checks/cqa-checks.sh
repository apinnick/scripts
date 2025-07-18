#!/bin/bash
# Avital Pinnick, 2025

# To be parameterized
# MODULE_PATH=../foreman-documentation/guides/common/modules

OUTPUT="CQA-report.md"
ASSEMBLIES="assemblies.txt"
MODULES="module-list.txt"
rm $OUTPUT &>/dev/null

echo -e "# CQA report\n" > $OUTPUT
echo -e "This report describes Content Quality Assessment issues found in Asciidoc assemblies and modules in SOURCE_FILE (TBD).\n" >> $OUTPUT

# Check if $ASSEMBLIES exists
if [[ ! -f "$ASSEMBLIES" ]]; then
  echo "Error: $ASSEMBLIES not found!"
  rm $OUTPUT &>/dev/null
  exit 1
fi

# Check if $MODULES exists
if [[ ! -f "$MODULES" ]]; then
  echo "Error: $MODULES not found!"
  rm $OUTPUT &>/dev/null
  exit 1
fi

# Add path to $MODULES
# sed -i 's|^|../foreman-documentation/guides/common/modules/|' $MODULES
echo -e Checking "$ASSEMBLIES" and "$MODULES"

# File checks
echo -e "## File checks\n" >> $OUTPUT

echo "Running file checks"

# Check for content type attribute
echo -e "**Content type attribute missing**\n" >> $OUTPUT
cat $ASSEMBLIES $MODULES | xargs -I {} sh -c '
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
cat $ASSEMBLIES $MODULES | xargs -I {} sh -c '
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
cat $ASSEMBLIES $MODULES | xargs -I {} sh -c '
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

# Blank line after '= ' header
echo -e "**'= ' header not followed by blank line**\n" >> $OUTPUT
# Generated by Gemini
AWK_SCRIPT=$(cat <<'EOF_AWK'
# Rule 1: When a line matches the pattern /^\s*=\s*[A-Za-z]/
/^\s*=\s*[A-Za-z]/ {
    found_pattern_line = 1; # Set flag that we found the pattern
    next; # Move to the next line to check
}

# Rule 2: This block executes for every line.
# It checks if the current line is the one immediately following the pattern.
{
    if (found_pattern_line == 1) {
        # Check if the current line is NOT blank AND NOT "endif::[]"
        if ($0 !~ /^[[:space:]]*$/ && ($0 !~ /^endif::\[\]\s*$/)) {
            print FILENAME; # Print filename if it meets criteria
            exit;           # Exit successfully (found a match)
        }
        # If the line was blank OR contained "endif::[]", reset the flag
        # and continue processing, as this sequence doesn't count as a match.
        found_pattern_line = 0;
    }
}

# Rule 3: This END block handles the case where the pattern line is the last line of the file.
# In this scenario, there's no subsequent line, so by definition, it's not
# followed by a blank line or "ifdef[]". So, we consider it a match.
END {
    if (found_pattern_line == 1) {
        print FILENAME; # Print filename if pattern was last line
    }
}
EOF_AWK
)

cat $ASSEMBLIES $MODULES | xargs -I {} sh -c '
    FILE="$1"
    AWK_SCRIPT="$2" # AWK script is passed as the second argument
    # Execute awk using the passed script content
    if echo "$AWK_SCRIPT" | awk -f /dev/stdin "$FILE" | grep -q "^$FILE$"; then
        echo "- $FILE"
    fi
' _ {} "$AWK_SCRIPT" >> "$OUTPUT"
echo -e "\n_Done_\n" >> "$OUTPUT"

# Admonition titles
# [NOTE], [WARNING], etc., must not be followed by a block title.
echo -e "**Admonition with title found**\n" >> $OUTPUT
cat $ASSEMBLIES $MODULES | xargs -I {} sh -c '
  if grep -Pzo "(?s)\[[A-Z]+\]\n\.[A-Za-z].*" "$1" > /dev/null; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# Image without text description
echo -e "**Image without description found**\n" >> $OUTPUT
cat $ASSEMBLIES $MODULES | xargs -I {} sh -c '
  if grep -E "^image.*\[\]$" "$1" > /dev/null; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# ASSEMBLY CHECKS
echo -e "\n## Assembly module checks\n" >> $OUTPUT

echo "Running assembly checks"

# Check assembly for more than one title (= )
echo -e "**More than one '= ' header found**\n" >> $OUTPUT
cat $ASSEMBLIES | xargs -I {} sh -c '
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
cat $ASSEMBLIES | xargs -I {} sh -c '
  if grep -P "^=== [A-Z0-9].*" "$1" > /dev/null; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# Check for block titles
echo -e "**Block title found**" >> $OUTPUT
cat $ASSEMBLIES | xargs -I {} sh -c '
  if grep -P "^\." "$1" > /dev/null; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# PROCEDURES
echo -e "## Procedure module checks\n" >> $OUTPUT

echo "Running procedure module checks"

# Procedure with '== ' header
echo -e "**'== ' header found**" >> $OUTPUT
cat $MODULES | xargs -I {} sh -c '
  if grep -P "^:_mod-docs-content-type: PROCEDURE" "$1" > /dev/null; then
    if grep -P "^== [A-Z0-9].*" "$1" > /dev/null; then
    echo "- $1"
    fi
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# LONG PROCEDURE
echo -e "**Procedure > 10 steps found**" >> $OUTPUT
cat $MODULES | xargs -I {} sh -c '
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
cat "$MODULES" | xargs -I {} sh -c '
  FILE="$1"
  if grep -P "^:_mod-docs-content-type: PROCEDURE" "$1" > /dev/null; then
    if grep -iPq "(?s)^\.(?!\.{1,3}|\s[A-Z]|Prerequisites|Procedure|Troubleshooting|Next steps|Additional resources|Verification).*" "$FILE"; then
      echo "- $FILE"
    fi
  fi
' _ {} >> $OUTPUT
echo -e "\n_Done_\n" >> $OUTPUT

# More than one procedure
echo -e "**More than one procedure found**" >> $OUTPUT
cat $MODULES | xargs -I {} sh -c '
  count=$(grep -P -c "^\.Procedure" "$1")
  if [ "$count" -ge 2 ]; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# Procedure embellishment
echo -e "**Incorrect 'Procedure' title found**\n" >> $OUTPUT
echo -e "Example: Procedure for upgrading\n" >> $OUTPUT
cat $MODULES | xargs -I {} sh -c '
  if grep -Pq "^\.Procedure.+" "$1"; then
    echo "- $1"
  fi
' _ {} >> "$OUTPUT"
echo -e "\n_Done_\n" >> $OUTPUT

# CONCEPT MODULES
echo -e "## Concept module checks\n" >> $OUTPUT

echo "Running concept module checks"
# Impermissible block title
echo -e "**Impermissible block title found**\n" >> $OUTPUT
echo -e "Concept modules can only contain 'Next steps' or 'Additional resources' as block titles.\nConsider replacing '.Title' with '== Title'.\n" >> $OUTPUT
cat "$MODULES" | xargs -I {} sh -c '
  FILE="$1"
  if grep -P "^:_mod-docs-content-type: CONCEPT" "$1" > /dev/null; then
    if grep -iPq "(?s)^\.(?!\.{1,3}|\s[A-Z]|Next steps|Additional resources).*" "$FILE"; then
      echo "- $FILE"
    fi
  fi
' _ {} >> $OUTPUT
echo -e "\n_Done_\n" >> $OUTPUT

# Concept with '=== ' header
echo -e "**'=== ' header found**" >> $OUTPUT
cat $MODULES | xargs -I {} sh -c '
  if grep -P "^:_mod-docs-content-type: CONCEPT" "$1" > /dev/null; then
    if grep -P "^=== [A-Z0-9a-z].*" "$1" > /dev/null; then
    echo "- $1"
    fi
  fi
' _ {} >> $OUTPUT
echo -e "\n_Done_\n" >> $OUTPUT

# END
echo "Done. CQA-report.md created."
